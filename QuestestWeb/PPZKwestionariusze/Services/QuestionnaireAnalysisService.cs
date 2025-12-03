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
        public async Task<List<ScoreData>> GetUserScores(int ID) // questionnaire id
        {
            List<ScoreData> ret = new List<ScoreData>();
            using (var connection = new OracleConnection(_connectionString))
            {
                await connection.OpenAsync();
                var command = new OracleCommand(
                    "select y.wynik, count(distinct y.id) ilosc from("
                    + " select qa.id, nvl(x.c, 0) wynik from (select count(1) c,"
                    + " qa.questionnairefilledid from questionsanswers qa, options o"
                    + " where o.id = qa.optionid and o.is_correct = 'T' and qa.is_chosen = 'T'"
                    + " group by qa.questionnairefilledid)x ,questionnairefilled qa where "
                    + " x.questionnairefilledid(+) = qa.id and qa.questionnaireid = 61) y "
                    + " group by y.wynik order by y.wynik",
                    connection);

                command.Parameters.Add(new OracleParameter(":ID", ID));

                var reader = await command.ExecuteReaderAsync();
                while (await reader.ReadAsync())
                {
                    ret.Add(new ScoreData { Score = (int)reader.GetInt32(0), Count = (int)reader.GetInt32(1) });
                }
            }

            return ret;
        }
    }
}

