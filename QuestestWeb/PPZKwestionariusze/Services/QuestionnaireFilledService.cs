using System.Collections.Generic;
using System.Data;
using System.Threading.Tasks;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Options;
using Oracle.ManagedDataAccess.Client;
using PPZKwestionariusze.Models;

namespace PPZKwestionariusze.Services
{
    public class QuestionnaireFilledService
    {
        private readonly string _connectionString;

        public QuestionnaireFilledService(IConfiguration configuration)
        {
            _connectionString = configuration.GetConnectionString("DefaultConnection");
        }

        // wszystkie wypełnienia
        public async Task<List<QuestionnaireFilled>> GetFillsForQuestionnaire(int ID)
        {
            var questionnaires = new List<QuestionnaireFilled>();

            using (var connection = new OracleConnection(_connectionString))
            {
                await connection.OpenAsync();
                var command = new OracleCommand("SELECT QF.ID, QF.QUESTIONNAIREID, QF.DATE_FILLED, U.ID, U.USERNAME, QF.RESULT_ID FROM QUESTIONNAIREFILLED QF, USERS U WHERE  QF.FILLED_BY = U.ID AND QF.QUESTIONNAIREID = :Id ORDER BY QF.ID DESC", connection);
                command.Parameters.Add(new OracleParameter(":Id", ID));

                var reader = await command.ExecuteReaderAsync();
                while (await reader.ReadAsync())
                {
                    questionnaires.Add(new QuestionnaireFilled
                    {
                        Id = reader.GetInt32(0),
                        QuestionnaireId = reader.GetInt32(1),
                        DateFilled = reader.GetDateTime(2),
                        FilledBy = reader.GetInt32(3),
                        FilledByUsername = reader.GetString(4),
                        ResultId = reader.GetInt32(5)
                    });
                }
            }

            return questionnaires;
        }

        // wypełnienia danego użytkownika
        public async Task<List<QuestionnaireFilled>> GetFillsByUser(int ID)
        {
            var questionnaires = new List<QuestionnaireFilled>();

            using (var connection = new OracleConnection(_connectionString))
            {
                await connection.OpenAsync();
                var command = new OracleCommand("SELECT QF.ID, QF.QUESTIONNAIREID, QF.DATE_FILLED, U.ID, U.USERNAME, QF.RESULT_ID FROM QUESTIONNAIREFILLED QF, USERS U WHERE  QF.FILLED_BY = U.ID AND U.ID = :Id ORDER BY QF.ID DESC", connection);
                command.Parameters.Add(new OracleParameter(":Id", ID));

                var reader = await command.ExecuteReaderAsync();
                while (await reader.ReadAsync())
                {
                    questionnaires.Add(new QuestionnaireFilled
                    {
                        Id = reader.GetInt32(0),
                        QuestionnaireId = reader.GetInt32(1),
                        DateFilled = reader.GetDateTime(2),
                        FilledBy = reader.GetInt32(3),
                        FilledByUsername = reader.GetString(4),
                        ResultId= reader.GetInt32(5)    
                    });
                }
            }

            return questionnaires;
        }

        // dodanie wypełnienia - nagłówka
        public async Task<int> AddQuestionnaireFilledAsync(QuestionnaireFilled questionnaire)
        {
            using (var connection = new OracleConnection(_connectionString))
            {
                await connection.OpenAsync();
                    var command = new OracleCommand("INSERT INTO QUESTIONNAIREFILLED (QUESTIONNAIREID, FILLED_BY, RESULT_ID) " +
                                                "VALUES (:QuestionnaireId, :FilledBy, :ResultId) " +
                                                "RETURNING ID INTO :NewId", connection);

                    command.Parameters.Add(new OracleParameter(":QuestionnaireId", questionnaire.QuestionnaireId));
                    command.Parameters.Add(new OracleParameter(":FilledBy", questionnaire.FilledBy));
                    command.Parameters.Add(new OracleParameter(":ResultId", questionnaire.ResultId));


                var idParam = new OracleParameter(":NewId", OracleDbType.Int32)
                    {
                        Direction = ParameterDirection.Output,
                        Size = 100
                    };
                    idParam.Direction = ParameterDirection.Output;
                    command.Parameters.Add(idParam);

                    await command.ExecuteNonQueryAsync();

                    int newId = Convert.ToInt32(idParam.Value.ToString());
                    return newId;
               
            }
        }


        // jedno wypełnienie - po jego ID
        public async Task<QuestionnaireFilled> GetQuestionnaireFilledByIDAsync(int ID)
        {
            using (var connection = new OracleConnection(_connectionString))
            {
                await connection.OpenAsync();
                var command = new OracleCommand("SELECT QF.ID, QF.QUESTIONNAIREID, QF.FILLED_BY, U.USERNAME, QF.DATE_FILLED, QF.RESULT_ID FROM QUESTIONNAIREFILLED QF, USERS U WHERE QF.FILLED_BY = U.ID AND QF.ID = :Id", connection);
                command.Parameters.Add(new OracleParameter(":Id", ID));

                var reader = await command.ExecuteReaderAsync();
                while (await reader.ReadAsync())
                {
                    return new QuestionnaireFilled
                    {
                        Id = reader.GetInt32(0),
                        QuestionnaireId = reader.GetInt32(1),
                        FilledBy = reader.GetInt32(2),
                        FilledByUsername = reader.GetString(3),
                        DateFilled = reader.GetDateTime(4),
                    ResultId = reader.GetInt32(5)};
                }
            }
            return null;

        }

        public async Task<int> GetUserScore(int ID)
        {
            using (var connection = new OracleConnection(_connectionString))
            {
                await connection.OpenAsync();
                var command = new OracleCommand(
                    "select count(1) from questionsanswers qa, options o where o.id = qa.optionid and o.is_correct = 'T' and qa.is_chosen = 'T' and qa.questionnairefilledid = :ID",
                    connection);

                command.Parameters.Add(new OracleParameter(":ID", ID));

                var reader = await command.ExecuteReaderAsync();
                while (await reader.ReadAsync())
                {
                    return (int)reader.GetInt32(0);
                }
            }

            return 0;
        }

        public async Task<List<UserResults>> GetResults(int ID) // typu quiz. Przyjmuje questionnairefilledid. zwraca listę obiektów z result id i punktami dla tego wyniku
        {
            List<UserResults> ret = new();
            using (var connection = new OracleConnection(_connectionString))
            {
                await connection.OpenAsync();
                var command = new OracleCommand(
                    "select sum(o.points_to_result) result_points, o.result_id " +
                    "from options o, " +
                    "questionsanswers qa, " +
                    "questionnairefilled qf " +
                    "where qa.optionid = o.id " +
                    "and qa.questionnairefilledid = qf.id " +
                    "and qf.id = :ID " +
                    "group by o.result_id order by o.result_id",
                    connection);

                command.Parameters.Add(new OracleParameter(":ID", ID));

                var reader = await command.ExecuteReaderAsync();
                while (await reader.ReadAsync())
                {
                    ret.Add(new UserResults { Points = (int)reader.GetInt32(0), ResultId = (int)reader.GetInt32(1)});
                }
            }

            return ret;
        }


        public async Task UpdateResult(int quest_id, int result_id)
        {
            using (var connection = new OracleConnection(_connectionString))
            {
                await connection.OpenAsync();
                var command = new OracleCommand("UPDATE QUESTIONNAIREFILLED set result_id =  " +
                                            ":ResultId " +
                                            "WHERE id = :ID", connection);

                command.Parameters.Add(new OracleParameter(":ID", quest_id));
                command.Parameters.Add(new OracleParameter(":ResultId", result_id));


                await command.ExecuteNonQueryAsync();

            }
        }

    }


}


