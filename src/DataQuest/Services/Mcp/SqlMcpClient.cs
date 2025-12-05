// ============================================================================
// DataQuest - SQL MCP Client Implementation
// Purpose: Wrapper around MSSQL MCP Server for DatabaseManager use
// Date: December 5, 2025
// ============================================================================

using DataQuest.Services.Mcp.Models;
using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading.Tasks;

namespace DataQuest.Services.Mcp
{
    /// <summary>
    /// SQL MCP Client implementation
    /// 
  /// Wraps SQL Server connection and execution
    /// Delegates to MCP infrastructure for standardized operations
    /// </summary>
    public class SqlMcpClient : ISqlMcpClient
  {
   private readonly string _connectionString;
        private readonly ILogger<SqlMcpClient> _logger;

   public SqlMcpClient(
      string connectionString,
       ILogger<SqlMcpClient> logger)
 {
    _connectionString = connectionString ?? throw new ArgumentNullException(nameof(connectionString));
       _logger = logger ?? throw new ArgumentNullException(nameof(logger));
        }

   /// <summary>
        /// Executes a SQL script from file
   /// </summary>
        public async Task<SqlExecutionResult> ExecuteScriptAsync(
      string scriptPath,
           SqlMcpExecutionOptions options = null)
  {
      var startTime = DateTime.UtcNow;
options ??= new SqlMcpExecutionOptions();

  try
        {
   if (!File.Exists(scriptPath))
 {
       var message = $"Script file not found: {scriptPath}";
      _logger.LogError(message);
             return SqlExecutionResult.CreateFailure(message, DateTime.UtcNow - startTime);
              }

 _logger.LogInformation("Executing script: {Script}", scriptPath);
      var scriptContent = await File.ReadAllTextAsync(scriptPath);

      // Execute with batching support for GO statements
        var result = await ExecuteBatchedScriptInternalAsync(
      scriptContent,
      options);

      var duration = DateTime.UtcNow - startTime;
  _logger.LogInformation(
  "Script execution completed in {Duration:hh\\:mm\\:ss.fff}",
      duration);

   return result;
     }
      catch (Exception ex)
       {
    var duration = DateTime.UtcNow - startTime;
  _logger.LogError(ex, "Script execution failed");
            return SqlExecutionResult.CreateFailure(ex.Message, duration);
            }
        }

     /// <summary>
        /// Executes raw SQL query
        /// </summary>
public async Task<SqlExecutionResult> ExecuteQueryAsync(
  string query,
         SqlMcpExecutionOptions options = null)
      {
         var startTime = DateTime.UtcNow;
     options ??= new SqlMcpExecutionOptions();

        try
         {
      if (string.IsNullOrWhiteSpace(query))
   {
     var message = "Query cannot be empty";
       _logger.LogError(message);
    return SqlExecutionResult.CreateFailure(message, DateTime.UtcNow - startTime);
         }

 _logger.LogDebug("Executing query: {Query}", query[..Math.Min(100, query.Length)] + "...");

    using (var connection = new SqlConnection(_connectionString))
       {
      await connection.OpenAsync();

    using (var command = connection.CreateCommand())
    {
  command.CommandText = query;
     command.CommandTimeout = options.TimeoutSeconds;

     using (var reader = await command.ExecuteReaderAsync())
         {
     var response = new SQLExecuteResponse
  {
   Success = true,
  Query = query,
    ExecutionTimeMs = (long)(DateTime.UtcNow - startTime).TotalMilliseconds
      };

     // Read column names
   for (int i = 0; i < reader.FieldCount; i++)
      {
       response.Columns.Add(reader.GetName(i));
         }

  // Read rows
    var rowCount = 0;
        while (await reader.NextResultAsync())
         {
           rowCount++;
  if (rowCount > options.MaxRows)
    {
   response.IsTruncated = true;
       break;
    }

       var row = new QueryRow();
       for (int i = 0; i < reader.FieldCount; i++)
     {
                row.Values[reader.GetName(i)] = reader.IsDBNull(i) ? null : reader.GetValue(i);
   }
      response.Rows.Add(row);
  }

    response.RowCount = rowCount;
      response.Summary = $"{rowCount} rows returned";

   var duration = DateTime.UtcNow - startTime;
      return SqlExecutionResult.CreateSuccess(response, duration);
 }
         }
            }
    catch (Exception ex)
 {
   var duration = DateTime.UtcNow - startTime;
        _logger.LogError(ex, "Query execution failed");
    return SqlExecutionResult.CreateFailure(ex.Message, duration);
   }
     }

   /// <summary>
      /// Checks if database exists
        /// </summary>
        public async Task<bool> DatabaseExistsAsync(string databaseName)
    {
  try
     {
 using (var connection = new SqlConnection(_connectionString))
    {
      await connection.OpenAsync();

     using (var command = connection.CreateCommand())
        {
   command.CommandText = $"SELECT 1 WHERE DB_ID('{databaseName}') IS NOT NULL";
      var result = await command.ExecuteScalarAsync();
        return result != null;
}
       }
      }
          catch (Exception ex)
    {
_logger.LogError(ex, "Error checking database existence");
       return false;
         }
 }

        /// <summary>
      /// Gets database schema information
        /// </summary>
        public async Task<SchemaDescribeResponse> GetSchemaAsync(string databaseName)
   {
  try
     {
     using (var connection = new SqlConnection(_connectionString))
         {
       await connection.OpenAsync();

 var response = new SchemaDescribeResponse
           {
   DatabaseName = databaseName,
   RetrievedAt = DateTime.UtcNow,
     Tables = new List<TableSchema>()
   };

      // Query all tables
 using (var command = connection.CreateCommand())
     {
 command.CommandText = $@"
USE [{databaseName}]
SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE = 'BASE TABLE'
";

        using (var reader = await command.ExecuteReaderAsync())
        {
      while (await reader.ReadAsync())
    {
      var tableName = reader.GetString(0);
   var table = new TableSchema { TableName = tableName };

    // Get columns
          await GetTableColumnsAsync(connection, tableName, table);
    // Get row count
         table.RowCount = await GetTableRowCountAsync(tableName);

      response.Tables.Add(table);
       }
        }
    }

    response.Summary = $"Schema for {databaseName}: {response.Tables.Count} tables";
        return response;
       }
     }
        catch (Exception ex)
 {
      _logger.LogError(ex, "Error getting schema");
     return new SchemaDescribeResponse { DatabaseName = databaseName };
      }
    }

/// <summary>
      /// Gets table row count
        /// </summary>
   public async Task<int> GetTableRowCountAsync(string tableName)
     {
      try
 {
   using (var connection = new SqlConnection(_connectionString))
   {
 await connection.OpenAsync();

     using (var command = connection.CreateCommand())
        {
  command.CommandText = $"SELECT COUNT(*) FROM [{tableName}]";
     var result = await command.ExecuteScalarAsync();
        return (int)(result ?? 0);
 }
        }
        }
  catch (Exception ex)
      {
    _logger.LogError(ex, "Error getting row count for {Table}", tableName);
     return 0;
      }
     }

     /// <summary>
  /// Executes script with batching (GO statement support)
      /// </summary>
    public async Task<SqlExecutionResult> ExecuteBatchedScriptAsync(
   string scriptPath,
  SqlMcpExecutionOptions options = null)
  {
          var startTime = DateTime.UtcNow;
  options ??= new SqlMcpExecutionOptions();

      try
    {
  if (!File.Exists(scriptPath))
 {
    var message = $"Script file not found: {scriptPath}";
_logger.LogError(message);
     return SqlExecutionResult.CreateFailure(message, DateTime.UtcNow - startTime);
       }

  var scriptContent = await File.ReadAllTextAsync(scriptPath);
    return await ExecuteBatchedScriptInternalAsync(scriptContent, options);
        }
            catch (Exception ex)
    {
    var duration = DateTime.UtcNow - startTime;
      _logger.LogError(ex, "Batched script execution failed");
     return SqlExecutionResult.CreateFailure(ex.Message, duration);
    }
        }

     /// <summary>
        /// Gets current database connection status
        /// </summary>
      public async Task<bool> IsConnectedAsync()
  {
     try
{
      using (var connection = new SqlConnection(_connectionString))
    {
    await connection.OpenAsync();
      return connection.State == System.Data.ConnectionState.Open;
        }
            }
 catch (Exception ex)
    {
  _logger.LogError(ex, "Error checking connection status");
       return false;
   }
        }

 // Helper methods

     /// <summary>
        /// Internal method to execute batched script with GO support
        /// </summary>
       private async Task<SqlExecutionResult> ExecuteBatchedScriptInternalAsync(
 string scriptContent,
 SqlMcpExecutionOptions options)
       {
      var startTime = DateTime.UtcNow;

 try
 {
  // Split by GO statements
          var batches = SplitScriptByGo(scriptContent);
  var totalRowsAffected = 0;

        using (var connection = new SqlConnection(_connectionString))
   {
   await connection.OpenAsync();

    foreach (var batch in batches)
       {
       if (string.IsNullOrWhiteSpace(batch))
         continue;

    using (var command = connection.CreateCommand())
     {
      command.CommandText = batch;
  command.CommandTimeout = options.TimeoutSeconds;

   var rowsAffected = await command.ExecuteNonQueryAsync();
              totalRowsAffected += rowsAffected >= 0 ? rowsAffected : 0;
     }
         }
       }

     var response = new SQLExecuteResponse
           {
   Success = true,
     RowCount = totalRowsAffected,
    ExecutionTimeMs = (long)(DateTime.UtcNow - startTime).TotalMilliseconds,
        Summary = $"Script executed successfully. {totalRowsAffected} rows affected."
  };

   var duration = DateTime.UtcNow - startTime;
  return SqlExecutionResult.CreateSuccess(response, duration, "Batched script executed successfully");
    }
           catch (Exception ex)
     {
var duration = DateTime.UtcNow - startTime;
    _logger.LogError(ex, "Batched script execution failed");
     return SqlExecutionResult.CreateFailure(ex.Message, duration);
   }
 }

     /// <summary>
/// Splits SQL script by GO statements
        /// </summary>
   private List<string> SplitScriptByGo(string script)
  {
      var batches = new List<string>();
 var lines = script.Split(new[] { "\r\n", "\r", "\n" }, StringSplitOptions.None);
    var currentBatch = new System.Text.StringBuilder();

 foreach (var line in lines)
       {
if (line.Trim().Equals("GO", StringComparison.OrdinalIgnoreCase))
        {
   if (currentBatch.Length > 0)
{
   batches.Add(currentBatch.ToString());
     currentBatch.Clear();
            }
 }
  else
          {
         if (currentBatch.Length > 0)
  currentBatch.AppendLine();
 currentBatch.Append(line);
       }
    }

  if (currentBatch.Length > 0)
        {
   batches.Add(currentBatch.ToString());
        }

  return batches;
     }

    /// <summary>
        /// Gets table columns info
     /// </summary>
private async Task GetTableColumnsAsync(
  SqlConnection connection,
    string tableName,
     TableSchema table)
      {
     try
  {
using (var command = connection.CreateCommand())
        {
   command.CommandText = $@"
SELECT 
    COLUMN_NAME,
   DATA_TYPE,
 CHARACTER_MAXIMUM_LENGTH,
   IS_NULLABLE,
    COLUMNPROPERTY(OBJECT_ID('{tableName}'), COLUMN_NAME, 'IsIdentity') AS IsIdentity
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = '{tableName}'
ORDER BY ORDINAL_POSITION
";

      using (var reader = await command.ExecuteReaderAsync())
        {
    while (await reader.ReadAsync())
   {
  var column = new ColumnInfo
     {
   ColumnName = reader.GetString(0),
 DataType = reader.GetString(1),
  MaxLength = reader.IsDBNull(2) ? null : (int?)reader.GetInt32(2),
   IsNullable = reader.GetString(3).Equals("YES"),
         IsIdentity = reader.IsDBNull(4) ? false : ((int)reader.GetValue(4)) == 1
             };
  table.Columns.Add(column);
    }
  }
      }
           }
     catch (Exception ex)
  {
      _logger.LogError(ex, "Error getting columns for {Table}", tableName);
           }
        }
    }
}
