using BCrypt.Net;
using Oracle.ManagedDataAccess.Client;
using PPZKwestionariusze.Models;

namespace PPZKwestionariusze.Services
{
    public class UserService
    {
        private readonly string _connectionString;

        public UserService(IConfiguration configuration)
        {
            _connectionString = configuration.GetConnectionString("DefaultConnection");
        }

        // do Storage'u
        public async Task<UserStorageModel> GetUserByUsernameAsync(string username)
        {
            using (var connection = new OracleConnection(_connectionString))
            {
                await connection.OpenAsync();
                var command = new OracleCommand("SELECT ID, USERNAME, VISIBLE, DATE_CREATED FROM USERS WHERE USERNAME = :UNAME", connection);
                command.Parameters.Add(new OracleParameter("UNAME", username));

                var reader = await command.ExecuteReaderAsync();
                while (await reader.ReadAsync())
                {
                    return new UserStorageModel {
                        Id = reader.GetInt32(0),
                        Username = reader.GetString(1),
                        IsVisible = reader.GetString(2),
                        DateCreated = reader.GetDateTime(3)
                    };
                }
                return null;
            }
        }

        // Rejestracja użytkownika
        public async Task<bool> RegisterUser(string username, string password)
        {
            var hashedPassword = BCrypt.Net.BCrypt.HashPassword(password);

            using (var connection = new OracleConnection(_connectionString))
            {
                await connection.OpenAsync();

                var command = new OracleCommand("INSERT INTO USERS (USERNAME, HASHED_PASSWORD, DATE_CREATED) VALUES (:username, :hashedPassword, :dateCreated)", connection);
                command.Parameters.Add(new OracleParameter("username", username));
                command.Parameters.Add(new OracleParameter("hashedPassword", hashedPassword));
                command.Parameters.Add(new OracleParameter("dateCreated", DateTime.Now));

                await command.ExecuteNonQueryAsync();
            }

            return true;
        }

        // Logowanie użytkownika
        public async Task<bool> LoginUser(string username, string password)
        {
            using (var connection = new OracleConnection(_connectionString))
            {
                await connection.OpenAsync();

                var command = new OracleCommand("SELECT HASHED_PASSWORD FROM USERS WHERE USERNAME = :username", connection);
                command.Parameters.Add(new OracleParameter("username", username));

                var reader = await command.ExecuteReaderAsync();
                if (await reader.ReadAsync())
                {
                    var storedHashedPassword = reader.GetString(0);

                    // Porównanie hasła wprowadzonego przez użytkownika z hasłem w bazie danych
                    if (BCrypt.Net.BCrypt.Verify(password, storedHashedPassword))
                    {
                        return true;  // Logowanie udane
                    }
                }
            }

            return false;  // Logowanie nieudane
        }

        // Update użytkownika - zmiana nazwy lub hasła. UUR ma ID zalogowanego użytkownika, przekazywane przed wywołaniem tej funkcji
        public async Task<bool> UpdateUser(UpdateUserRequest user)
        {
            var hashedPassword = user.NewPassword == null ? null : BCrypt.Net.BCrypt.HashPassword(user.NewPassword);

            using (var connection = new OracleConnection(_connectionString))
            {
                await connection.OpenAsync();

                

                var command = new OracleCommand("UPDATE USERS SET USERNAME = NVL(:NewUsername, USERNAME), HASHED_PASSWORD = NVL(:NewHashedPassword, HASHED_PASSWORD), VISIBLE = :NewVisible WHERE ID = :UserId", connection);
                command.Parameters.Add(new OracleParameter("NewUsername", user.NewUsername));
                command.Parameters.Add(new OracleParameter("NewHashedPassword", hashedPassword));
                command.Parameters.Add(new OracleParameter("NewVisible", user.IsVisible));
                command.Parameters.Add(new OracleParameter("UserId", user.Id));

                await command.ExecuteNonQueryAsync();
            }

            return true;
        }

        // dla przeglądarki
        public async Task<List<UserViewModel>> GetUsersBrowserAsync()
        {
            var users = new List<UserViewModel>();

            using (var connection = new OracleConnection(_connectionString))
            {
                await connection.OpenAsync();
                var command = new OracleCommand("SELECT U.ID, U.USERNAME, U.DATE_CREATED, U.VISIBLE, (SELECT COUNT(1) FROM QUESTIONNAIRES Q WHERE Q.CREATED_BY = U.ID) TMP, (SELECT COUNT(1) FROM QUESTIONNAIREFILLED Q WHERE Q.FILLED_BY = U.ID) TMP1 FROM USERS U ORDER BY U.ID", connection);

                var reader = await command.ExecuteReaderAsync();
                while (await reader.ReadAsync())
                {
                    users.Add(new UserViewModel
                    {
                        Id = reader.GetInt32(0),
                        Username = reader.GetString(1),
                        DateCreated = reader.GetDateTime(2),
                        IsVisible = reader.GetString(3),
                        QuestionnaireCount = reader.GetInt32(4),
                        FillCount = reader.GetInt32(5)
                    });
                }
            }

            return users;
        }

        public async Task<List<UserComboDto>> GetUsersForComboAsync()
        {
            var users = new List<UserComboDto>();

            using (var connection = new OracleConnection(_connectionString))
            {
                await connection.OpenAsync();
                var command = new OracleCommand("SELECT U.ID, U.USERNAME FROM USERS U", connection);

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
    }

}
