using System.Collections.Generic;
using System.Data;
using System.Threading.Tasks;
using Microsoft.Extensions.Configuration;
using Oracle.ManagedDataAccess.Client;

using PPZKwestionariusze.Models;

namespace PPZKwestionariusze.Services
{
    public class QuestionService
    {
        private readonly string _connectionString;

        public QuestionService(IConfiguration configuration)
        {
            _connectionString = configuration.GetConnectionString("DefaultConnection");
        }

        public async Task<List<Question>> GetQuestionsAsync()
        {
            var questions = new List<Question>();

            using (var connection = new OracleConnection(_connectionString))
            {
                await connection.OpenAsync();
                var command = new OracleCommand("SELECT ID, CONTENT, DATE_CREATED, QUESTIONNAIREID FROM QUESTIONS", connection);

                var reader = await command.ExecuteReaderAsync();
                while (await reader.ReadAsync())
                {
                    questions.Add(new Question
                    {
                        Id = reader.GetInt32(0),
                        Content = reader.GetString(2),
                        DateCreated = reader.GetDateTime(3),
                        QuestionnaireId = reader.GetInt32(4)
                    });
                }
            }

            return questions;
        }
        public async Task<int> AddQuestionAsync(Question question)
        {
            using (var connection = new OracleConnection(_connectionString))
            {
                await connection.OpenAsync();

                if(question.Id != -1)
                {
                    var command = new OracleCommand("INSERT INTO QUESTIONS (ID, CONTENT, QUESTIONNAIREID) " +
                                                "VALUES (:Id, :Content, :QuestionnaireId) ", connection);

                    command.Parameters.Add(new OracleParameter(":Id", question.Id));
                    command.Parameters.Add(new OracleParameter(":Content", question.Content));
                    command.Parameters.Add(new OracleParameter(":QuestionnaireId", question.QuestionnaireId));

                    await command.ExecuteNonQueryAsync();
                    return question.Id;
                }
                else
                {
                    var command = new OracleCommand("INSERT INTO QUESTIONS (CONTENT, QUESTIONNAIREID) " +
                                                "VALUES (:Content, :QuestionnaireId) " +
                                                "RETURNING ID INTO :NewId", connection);

                    command.Parameters.Add(new OracleParameter(":Content", question.Content));
                    command.Parameters.Add(new OracleParameter(":QuestionnaireId", question.QuestionnaireId));


                    var idParam = new OracleParameter(":NewId", OracleDbType.Int32);
                    idParam.Direction = ParameterDirection.Output;
                    command.Parameters.Add(idParam);

                    await command.ExecuteNonQueryAsync();

                    int newId = Convert.ToInt32(idParam.Value.ToString());
                    return newId;
                }
                
            }
        }

        public async Task<List<Question>> GetQuestionsForQuestionnaire(int ID)
        {
            var questions = new List<Question>();
            using (var connection = new OracleConnection(_connectionString))
            {
                await connection.OpenAsync();
                var command = new OracleCommand("SELECT ID, CONTENT, DATE_CREATED, QUESTIONNAIREID FROM QUESTIONS WHERE QUESTIONNAIREID = :Id ORDER BY ID", connection);
                command.Parameters.Add(new OracleParameter(":Id", ID));

                var reader = await command.ExecuteReaderAsync();
                while (await reader.ReadAsync())
                {
                    questions.Add(new Question
                    {
                        Id = reader.GetInt32(0),
                        Content = reader.GetString(1),
                        DateCreated = reader.GetDateTime(2),
                        QuestionnaireId = reader.GetInt32(3)
                    });
                }
            }
            return questions;

        }
    }



}
