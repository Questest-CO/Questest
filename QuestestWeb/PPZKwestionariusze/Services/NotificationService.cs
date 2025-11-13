using System.Collections.Generic;
using System.Data;
using System.Threading.Tasks;
using Microsoft.Extensions.Configuration;
using Oracle.ManagedDataAccess.Client;

using PPZKwestionariusze.Models;

namespace PPZKwestionariusze.Services
{
    public class NotificationService
    {
        private readonly string _connectionString;

        public NotificationService(IConfiguration configuration)
        {
            _connectionString = configuration.GetConnectionString("DefaultConnection");
        }

        public async Task AddNotificationAsync(Notification notification)
        {
            using (var connection = new OracleConnection(_connectionString))
            {
                await connection.OpenAsync();

                var command = new OracleCommand("INSERT INTO NOTIFICATIONS (TEXT, USER_ID) " +
                                                "VALUES (:Text, :UserId)", connection);

                command.Parameters.Add(new OracleParameter(":Text", notification.Text));
                command.Parameters.Add(new OracleParameter(":UserId", notification.UserId));

                await command.ExecuteNonQueryAsync();
            }
        }
        public async Task<List<Notification>> GetUserNotifications(int ID) // ID usera
        {
            var notifications = new List<Notification>();

            using (var connection = new OracleConnection(_connectionString))
            {
                await connection.OpenAsync();
                var command = new OracleCommand("SELECT ID, TEXT, DATE_SENT, DATE_READ, USER_ID FROM NOTIFICATIONS WHERE USER_ID = :Id ORDER BY ID DESC", connection);
                command.Parameters.Add(new OracleParameter(":Id", ID));

                var reader = await command.ExecuteReaderAsync();
                while (await reader.ReadAsync())
                {
                    notifications.Add(new Notification
                    {
                        Id = reader.GetInt32(0),
                        Text = reader.GetString(1),
                        DateSent = reader.GetDateTime(2),
                        DateRead = reader.IsDBNull(3) ? (DateTime?)null : reader.GetDateTime(3),
                        UserId = reader.GetInt32(4)
                    });
                }
            }

            return notifications;
        }

        public async Task SetAllAsRead(int UserId)
        {
            using (var connection = new OracleConnection(_connectionString))
            {
                await connection.OpenAsync();

                var command = new OracleCommand("UPDATE NOTIFICATIONS SET DATE_READ = SYSDATE WHERE USER_ID = :UserId AND DATE_READ IS NULL", connection);
                command.Parameters.Add(new OracleParameter("UserId", UserId));

                await command.ExecuteNonQueryAsync();
            }
        }

        public async Task DeleteNotification(int ID) // ID powiadomienia
        {
            using (var connection = new OracleConnection(_connectionString))
            {
                await connection.OpenAsync();

                var command = new OracleCommand("DELETE FROM NOTIFICATIONS WHERE ID = :Id", connection);
                command.Parameters.Add(new OracleParameter("Id", ID));

                await command.ExecuteNonQueryAsync();
            }
        }
    }

   

}
