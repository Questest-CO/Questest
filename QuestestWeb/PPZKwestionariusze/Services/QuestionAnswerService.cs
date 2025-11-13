using System.Collections.Generic;
using System.Data;
using System.Threading.Tasks;
using Microsoft.Extensions.Configuration;
using Oracle.ManagedDataAccess.Client;

using PPZKwestionariusze.Models;

namespace PPZKwestionariusze.Services
{
    public class QuestionAnswerService
    {
        private readonly string _connectionString;

        public QuestionAnswerService(IConfiguration configuration)
        {
            _connectionString = configuration.GetConnectionString("DefaultConnection");
        }

        // zaznaczone odpowiedzi w kwestionariuszu (podane ID wypełnienia/nagłówka). Pominięty "nagłówek" pytania - optionid jest unikalne w ramach kwestionariusza
        public async Task<List<QuestionAnswer>> GetAnswersForQuestionnaireFilled(int ID)
        {
            var answers = new List<QuestionAnswer>();

            using (var connection = new OracleConnection(_connectionString))
            {
                await connection.OpenAsync();
                var command = new OracleCommand("SELECT OPTIONID, IS_CHOSEN FROM QUESTIONSANSWERS WHERE QUESTIONNAIREFILLEDID = :Id ORDER BY OPTIONID", connection);
                command.Parameters.Add(new OracleParameter(":Id", ID));

                var reader = await command.ExecuteReaderAsync();
                while (await reader.ReadAsync())
                {
                    answers.Add(new QuestionAnswer
                    {
                        QuestionnaireFilledId = ID,
                        OptionId = reader.GetInt32(0),
                        IsChosen = reader.GetString(1)
                    });
                }
            }

            return answers;
        }

        public async Task<List<QuestionAnswerOpen>> GetAnswersOpenForQuestionnaireFilled(int ID)
        {
            var answers = new List<QuestionAnswerOpen>();

            using (var connection = new OracleConnection(_connectionString))
            {
                await connection.OpenAsync();
                var command = new OracleCommand("SELECT QUESTIONID, ANSWER FROM QUESTIONSANSWERS_OPEN WHERE QUESTIONNAIREFILLEDID = :Id ORDER BY QUESTIONID", connection);
                command.Parameters.Add(new OracleParameter(":Id", ID));

                var reader = await command.ExecuteReaderAsync();
                while (await reader.ReadAsync())
                {
                    answers.Add(new QuestionAnswerOpen
                    {
                        QuestionnaireFilledId = ID,
                        QuestionId = reader.GetInt32(0),
                        Answer = reader.GetString(1)
                    });
                }
            }

            return answers;
        }
        public async Task AddAnswerAsync(QuestionAnswer answer)
        {
            using (var connection = new OracleConnection(_connectionString))
            {
                await connection.OpenAsync();

                var command = new OracleCommand("INSERT INTO QUESTIONSANSWERS (QUESTIONNAIREFILLEDID, OPTIONID, IS_CHOSEN) " +
                                                "VALUES (:QuestionnaireFilledId, :OptionId, :IsChosen)", connection);

                command.Parameters.Add(new OracleParameter(":QuestionnaireFilledId", answer.QuestionnaireFilledId));
                command.Parameters.Add(new OracleParameter(":OptionId", answer.OptionId));
                command.Parameters.Add(new OracleParameter(":IsChosen", answer.IsChosen));

                await command.ExecuteNonQueryAsync();
            }
        }
        public async Task AddAnswerOpenAsync(QuestionAnswerOpen answer)
        {
            using (var connection = new OracleConnection(_connectionString))
            {
                await connection.OpenAsync();

                var command = new OracleCommand("INSERT INTO QUESTIONSANSWERS_OPEN (QUESTIONNAIREFILLEDID, QUESTIONID, ANSWER) " +
                                                "VALUES (:QuestionnaireFilledId, :QuestionId, :Answer)", connection);

                command.Parameters.Add(new OracleParameter(":QuestionnaireFilledId", answer.QuestionnaireFilledId));
                command.Parameters.Add(new OracleParameter(":OptionId", answer.QuestionId));
                command.Parameters.Add(new OracleParameter(":IsChosen", answer.Answer));

                await command.ExecuteNonQueryAsync();
            }
        }
    }

}
