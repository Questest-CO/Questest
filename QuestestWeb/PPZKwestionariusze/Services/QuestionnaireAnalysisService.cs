using System.Collections.Generic;
using System.Data;
using System.Threading.Tasks;
using Microsoft.Extensions.Configuration;
using Oracle.ManagedDataAccess.Client;
using PPZKwestionariusze.Models;
namespace PPZKwestionariusze.Services
{
    public class QuestionnaireAnalysisService
    {
        private readonly string _connectionString;

        public QuestionnaireAnalysisService(IConfiguration configuration)
        {
            _connectionString = configuration.GetConnectionString("DefaultConnection");
        }

        public async Task<int> GetNumFills(int ID)
        {
            using (var connection = new OracleConnection(_connectionString))
            {
                await connection.OpenAsync();
                var command = new OracleCommand("select count(1) from questionnairefilled where questionnaireid = :ID", connection);
                command.Parameters.Add(new OracleParameter(":ID", ID));

                var reader = await command.ExecuteReaderAsync();
                while (await reader.ReadAsync())
                {
                    return reader.GetInt32(0);

                }
            }
            return 0;
        }

        public async Task<OptionAnalysis> GetOptionAnalysis(int ID)
        {
            using (var connection = new OracleConnection(_connectionString))
            {
                await connection.OpenAsync();
                var command = new OracleCommand("select count(1) from questionsanswers where optionid = :ID and is_chosen = 'T'", connection);
                command.Parameters.Add(new OracleParameter(":ID", ID));

                var reader = await command.ExecuteReaderAsync();
                while (await reader.ReadAsync())
                {
                    return new OptionAnalysis
                    {
                        OptionId = ID,
                        Count = reader.GetInt32(0)
                    };
                }
            }
            return null;
        }

    }
}

