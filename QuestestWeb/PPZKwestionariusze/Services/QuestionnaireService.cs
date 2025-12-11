using System;
using System.Collections.Generic;
using System.Data;
using System.Security.Cryptography;
using System.Threading.Tasks;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Options;
using Oracle.ManagedDataAccess.Client;
using PPZKwestionariusze.Models;

namespace PPZKwestionariusze.Services
{
    public class QuestionnaireService
    {
        private readonly string _connectionString;

        public QuestionnaireService(IConfiguration configuration)
        {
            _connectionString = configuration.GetConnectionString("DefaultConnection");
        }

        public async Task<List<Questionnaire>> GetQuestionnairesAsync()
        {
            var questionnaires = new List<Questionnaire>();

            using (var connection = new OracleConnection(_connectionString))
            {
                await connection.OpenAsync();
                var command = new OracleCommand(
                    "SELECT ID, TITLE, CREATED_BY, DATE_CREATED, PRIVATE, CATEGORY " +
                    "FROM QUESTIONNAIRES ORDER BY ID",
                    connection);

                var reader = await command.ExecuteReaderAsync();
                while (await reader.ReadAsync())
                {
                    questionnaires.Add(new Questionnaire
                    {
                        Id = reader.GetInt32(0),
                        Title = reader.GetString(1),
                        CreatedBy = reader.GetInt32(2),
                        DateCreated = reader.GetDateTime(3),
                        IsPrivate = reader.GetString(4),
                        CategoryId = reader.IsDBNull(5) ? -1 : reader.GetInt32(5)
                    });
                }
            }

            return questionnaires;
        }

        // dodawanie - może być podane ID w przypadku aktualizacji/wstawiania na nowo
        public async Task<int> AddQuestionnaireAsync(Questionnaire questionnaire)
        {
            using (var connection = new OracleConnection(_connectionString))
            {
                await connection.OpenAsync();

                if (questionnaire.Id != -1)
                {
                    var deleteCommand = new OracleCommand("DELETE FROM QUESTIONNAIRES WHERE ID = :Id", connection);
                    deleteCommand.Parameters.Add(new OracleParameter(":Id", questionnaire.Id));
                    await deleteCommand.ExecuteNonQueryAsync();

                    var command = new OracleCommand(
                        "INSERT INTO QUESTIONNAIRES (ID, TITLE, CREATED_BY, PRIVATE, CATEGORY) " +
                        "VALUES (:Id, :Title, :CreatedBy, :Private, :CategoryId)",
                        connection);

                    command.Parameters.Add(new OracleParameter(":Id", questionnaire.Id));
                    command.Parameters.Add(new OracleParameter(":Title", questionnaire.Title));
                    command.Parameters.Add(new OracleParameter(":CreatedBy", questionnaire.CreatedBy));
                    command.Parameters.Add(new OracleParameter(":Private", questionnaire.IsPrivate));
                    command.Parameters.Add(new OracleParameter(":CategoryId", questionnaire.CategoryId));

                    await command.ExecuteNonQueryAsync();
                    return questionnaire.Id;
                }
                else
                {
                    var command = new OracleCommand(
                        "INSERT INTO QUESTIONNAIRES (TITLE, CREATED_BY, PRIVATE, CATEGORY) " +
                        "VALUES (:Title, :CreatedBy, :Private, :CategoryId) " +
                        "RETURNING ID INTO :NewId",
                        connection);

                    command.Parameters.Add(new OracleParameter(":Title", questionnaire.Title));
                    command.Parameters.Add(new OracleParameter(":CreatedBy", questionnaire.CreatedBy));
                    command.Parameters.Add(new OracleParameter(":Private", questionnaire.IsPrivate));
                    command.Parameters.Add(new OracleParameter(":CategoryId", questionnaire.CategoryId));

                    var idParam = new OracleParameter(":NewId", OracleDbType.Int32)
                    {
                        Direction = ParameterDirection.Output,
                        Size = 100
                    };
                    command.Parameters.Add(idParam);

                    await command.ExecuteNonQueryAsync();

                    int newId = Convert.ToInt32(idParam.Value.ToString());
                    return newId;
                }
            }
        }

        public async Task<Questionnaire> GetQuestionnaireByIDAsync(int ID)
        {
            using (var connection = new OracleConnection(_connectionString))
            {
                await connection.OpenAsync();
                var command = new OracleCommand(
                    "SELECT ID, TITLE, CREATED_BY, DATE_CREATED, PRIVATE, CATEGORY " +
                    "FROM QUESTIONNAIRES WHERE ID = :Id",
                    connection);

                command.Parameters.Add(new OracleParameter(":Id", ID));

                var reader = await command.ExecuteReaderAsync();
                while (await reader.ReadAsync())
                {
                    return new Questionnaire
                    {
                        Id = reader.GetInt32(0),
                        Title = reader.GetString(1),
                        CreatedBy = reader.GetInt32(2),
                        DateCreated = reader.GetDateTime(3),
                        IsPrivate = reader.GetString(4),
                        CategoryId = reader.IsDBNull(5) ? -1 : reader.GetInt32(5)
                    };
                }
            }
            return null;
        }

        // dla przeglądarki
        public async Task<List<QuestionnaireViewModel>> GetQuestionnairesBrowserAsync()
        {
            var questionnaires = new List<QuestionnaireViewModel>();

            using (var connection = new OracleConnection(_connectionString))
            {
                await connection.OpenAsync();
                var command = new OracleCommand(
                    "SELECT Q.ID, Q.TITLE, U.ID AS IDU, U.USERNAME, Q.DATE_CREATED, Q.PRIVATE, " +
                    "(SELECT COUNT(1) FROM QUESTIONS QQ WHERE QQ.QUESTIONNAIREID = Q.ID) TMP, " +
                    "(SELECT COUNT(1) FROM QUESTIONNAIREFILLED QF WHERE QF.QUESTIONNAIREID = Q.ID) TMP1, " +
                    "Q.CATEGORY, C.NAME " +
                    "FROM QUESTIONNAIRES Q, USERS U, CATEGORIES C WHERE Q.CREATED_BY = U.ID AND Q.CATEGORY = C.ID ORDER BY Q.ID",
                    connection);

                var reader = await command.ExecuteReaderAsync();
                while (await reader.ReadAsync())
                {
                    questionnaires.Add(new QuestionnaireViewModel
                    {
                        Id = reader.GetInt32(0),
                        Title = reader.GetString(1),
                        CreatedBy = reader.GetInt32(2),
                        CreatedByUsername = reader.GetString(3),
                        DateCreated = reader.GetDateTime(4),
                        IsPrivate = reader.GetString(5),
                        QuestionCount = reader.GetInt32(6),
                        FillCount = reader.GetInt32(7),
                        CategoryId = reader.GetInt32(8),
                        Category = reader.GetString(9)
                    });
                }
            }

            return questionnaires;
        }

        public async Task DeleteQuestionnaire(int ID)
        {
            using (var connection = new OracleConnection(_connectionString))
            {
                await connection.OpenAsync();
                var command = new OracleCommand("DELETE FROM QUESTIONNAIRES WHERE ID = :Id", connection);
                command.Parameters.Add(new OracleParameter(":Id", ID));

                await command.ExecuteNonQueryAsync();
            }
        }

        public async Task<List<int>> GetPermittedUsers(int ID)
        {
            var userIds = new List<int>();

            using (var connection = new OracleConnection(_connectionString))
            {
                await connection.OpenAsync();
                var command = new OracleCommand(
                    "SELECT USER_ID FROM QUESTIONNAIRES_SHARED WHERE QUESTIONNAIRE_ID = :QuestId",
                    connection);

                command.Parameters.Add(new OracleParameter(":QuestId", ID));

                var reader = await command.ExecuteReaderAsync();
                while (await reader.ReadAsync())
                {
                    userIds.Add(reader.GetInt32(0));
                }
            }

            return userIds;
        }

        public async Task<List<UserComboDto>> GetPermittedUserDtos(int ID)
        {
            var users = new List<UserComboDto>();

            using (var connection = new OracleConnection(_connectionString))
            {
                await connection.OpenAsync();
                var command = new OracleCommand(
                    "SELECT U.ID, U.USERNAME FROM QUESTIONNAIRES_SHARED QS " +
                    "JOIN USERS U ON U.ID = QS.USER_ID WHERE QS.QUESTIONNAIRE_ID = :QuestId",
                    connection);

                command.Parameters.Add(new OracleParameter(":QuestId", ID));

                var reader = await command.ExecuteReaderAsync();
                while (await reader.ReadAsync())
                {
                    users.Add(new UserComboDto
                    {
                        Id = reader.GetInt32(0),
                        Username = reader.GetString(1)
                    });
                }
            }

            return users;
        }

        public async Task RevokeAccessFromUser(int QID, int UID)
        {
            using (var connection = new OracleConnection(_connectionString))
            {
                await connection.OpenAsync();
                var command = new OracleCommand(
                    "DELETE FROM QUESTIONNAIRES_SHARED WHERE QUESTIONNAIRE_ID = :QuestId AND USER_ID = :UserId",
                    connection);

                command.Parameters.Add(new OracleParameter(":QuestId", QID));
                command.Parameters.Add(new OracleParameter(":UserId", UID));

                await command.ExecuteNonQueryAsync();
            }
        }

        public async Task ShareWithUser(int QID, int UID)
        {
            using (var connection = new OracleConnection(_connectionString))
            {
                await connection.OpenAsync();
                var command = new OracleCommand(
                    "INSERT INTO QUESTIONNAIRES_SHARED VALUES (:QuestId, :UserId)",
                    connection);

                command.Parameters.Add(new OracleParameter(":QuestId", QID));
                command.Parameters.Add(new OracleParameter(":UserId", UID));

                await command.ExecuteNonQueryAsync();
            }
        }

        public async Task<int> GetMaxScore(int ID)
        {
            using (var connection = new OracleConnection(_connectionString))
            {
                await connection.OpenAsync();
                var command = new OracleCommand(
                    "select count(1) from options o, questions q where q.id = o.questionid and q.questionnaireid = :ID and o.is_correct = 'T'",
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

        public async Task<List<QuizResult>> GetResultsForQuestionnaire(int ID)
        {
            List<QuizResult> ret = new();
            using (var connection = new OracleConnection(_connectionString))
            {
                await connection.OpenAsync();
                var command = new OracleCommand(
                    "select id, title, description from quiz_results where questionnaireid = :ID",
                    connection);

                command.Parameters.Add(new OracleParameter(":ID", ID));

                var reader = await command.ExecuteReaderAsync();
                while (await reader.ReadAsync())
                {
                    ret.Add(new QuizResult { Id = (int)reader.GetInt32(0), Title = reader.GetString(1), Description = reader.GetString(2) });
                }
            }

            return ret;
        }

        public async Task<QuizResult> GetResult(int ID)
        {
            using (var connection = new OracleConnection(_connectionString))
            {
                await connection.OpenAsync();
                var command = new OracleCommand(
                    "select id, title, description from quiz_results where id = :ID",
                    connection);

                command.Parameters.Add(new OracleParameter(":ID", ID));

                var reader = await command.ExecuteReaderAsync();
                while (await reader.ReadAsync())
                {
                    return new QuizResult { Id = (int)reader.GetInt32(0), Title = reader.GetString(1), Description = reader.GetString(2) };
                }
            }

            return null;
        }

        public async Task<int> AddResultAsync(QuizResult result)
        {
            using (var connection = new OracleConnection(_connectionString))
            {
                await connection.OpenAsync();

                if (result.Id != -1)
                {
                    var command = new OracleCommand("INSERT INTO quiz_results (ID, title,description, QUESTIONNAIREID) " +
                                                "VALUES (:Id, :Title,  :Description, :QuestionnaireId) ", connection);

                    command.Parameters.Add(new OracleParameter(":Id", result.Id));
                    command.Parameters.Add(new OracleParameter(":Title", result.Title));
                    command.Parameters.Add(new OracleParameter(":Description", result.Description));
                    command.Parameters.Add(new OracleParameter(":QuestionnaireId", result.QuestionnaireId));

                    await command.ExecuteNonQueryAsync();
                    return result.Id;
                }
                else
                {
                    var command = new OracleCommand("INSERT INTO quiz_results (title, description, questionnaireid) " +
                                                "VALUES (:Title, :Description, :QuestionnaireId) " +
                                                "RETURNING ID INTO :NewId", connection);

                    command.Parameters.Add(new OracleParameter(":Title", result.Title));
                    command.Parameters.Add(new OracleParameter(":Description", result.Description));
                    command.Parameters.Add(new OracleParameter(":QuestionnaireId", result.QuestionnaireId));


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

