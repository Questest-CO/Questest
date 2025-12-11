using System.Collections.Generic;
using System.Data;
using System.Threading.Tasks;
using Microsoft.Extensions.Configuration;
using Oracle.ManagedDataAccess.Client;

using PPZKwestionariusze.Models;

namespace PPZKwestionariusze.Services
{
    public class OptionsService
    {
        private readonly string _connectionString;

        public OptionsService(IConfiguration configuration)
        {
            _connectionString = configuration.GetConnectionString("DefaultConnection");
        }

        public async Task<List<Option>> GetOptionsForQuestion(int ID)
        {
            var options = new List<Option>();

            using (var connection = new OracleConnection(_connectionString))
            {
                await connection.OpenAsync();
                var command = new OracleCommand("SELECT ID, CONTENT, DATE_CREATED, QUESTIONID, IS_CORRECT, result_id, points_to_result FROM OPTIONS WHERE QUESTIONID = :Id ORDER BY ID", connection);
                command.Parameters.Add(new OracleParameter(":Id", ID));

                var reader = await command.ExecuteReaderAsync();
                while (await reader.ReadAsync())
                {
                    options.Add(new Option
                    {
                        Id = reader.GetInt32(0),
                        Content = reader.GetString(1),
                        DateCreated = reader.GetDateTime(2),
                        QuestionId = reader.GetInt32(3),
                        IsCorrect = reader.GetString(4),
                        ResultId = reader.IsDBNull(5) ? (int?)null : reader.GetInt32(5),
                        PointsToResults = reader.IsDBNull(6) ? (int?)null : reader.GetInt32(6)
                    });
                }
            }

            return options;
        }
        public async Task<int> AddOptionAsync(Option option)
        {
            using (var connection = new OracleConnection(_connectionString))
            {
                await connection.OpenAsync();


                if(option.Id != -1) {
                    var command = new OracleCommand("INSERT INTO OPTIONS (ID, CONTENT, QUESTIONID, IS_CORRECT, DATE_CREATED, result_id, points_to_result) " +
                                                    "VALUES (:Id, :Content, :QuestionnaireId, :IsCorrect, :DateCreated, :ResultId, :PointsToResult) ", connection);

                    command.Parameters.Add(new OracleParameter(":Id", option.Id));
                    command.Parameters.Add(new OracleParameter(":Content", option.Content));
                    command.Parameters.Add(new OracleParameter(":QuestionnaireId", option.QuestionId));
                    command.Parameters.Add(new OracleParameter(":IsCorrect", option.IsCorrect));
                    command.Parameters.Add(new OracleParameter(":DateCreated", DateTime.Now));

                    command.Parameters.Add(new OracleParameter(":ResultId",option.ResultId));
                    command.Parameters.Add(new OracleParameter(":PointsToResult",option.PointsToResults));



                    await command.ExecuteNonQueryAsync();
                    return option.Id;
                }
                else
                {
                    var command = new OracleCommand("INSERT INTO OPTIONS (CONTENT, QUESTIONID, IS_CORRECT, DATE_CREATED, result_id, points_to_result) " +
                                                                    "VALUES (:Content, :QuestionnaireId, :IsCorrect, :DateCreated, :ResultId, :PointsToResult) " +
                                                                    "RETURNING ID INTO :NewId", connection);

                    command.Parameters.Add(new OracleParameter(":Content", option.Content));
                    command.Parameters.Add(new OracleParameter(":QuestionnaireId", option.QuestionId));
                    command.Parameters.Add(new OracleParameter(":IsCorrect", option.IsCorrect));
                    command.Parameters.Add(new OracleParameter(":DateCreated", DateTime.Now));
                    command.Parameters.Add(new OracleParameter(":ResultId", option.ResultId));
                    command.Parameters.Add(new OracleParameter(":PointsToResult", option.PointsToResults));

                    var idParam = new OracleParameter(":NewId", OracleDbType.Int32);
                    idParam.Direction = ParameterDirection.Output;
                    command.Parameters.Add(idParam);

                    await command.ExecuteNonQueryAsync();
                    int newId = Convert.ToInt32(idParam.Value.ToString());
                    return newId;
                }
            }
        }
    }

}
