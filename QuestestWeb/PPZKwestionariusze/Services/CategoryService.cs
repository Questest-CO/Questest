using Oracle.ManagedDataAccess.Client;
using PPZKwestionariusze.Models;

namespace PPZKwestionariusze.Services
{
    public class CategoryService
    {
        private readonly string _connectionString;

        public CategoryService(IConfiguration configuration)
        {
            _connectionString = configuration.GetConnectionString("DefaultConnection");
        }

        public async Task<List<Category>> GetCategoriesAsync()
        {
            var categories = new List<Category>();

            using (var connection = new OracleConnection(_connectionString))
            {
                await connection.OpenAsync();

                var command = new OracleCommand("SELECT ID, NAME FROM CATEGORIES", connection);

                var reader = await command.ExecuteReaderAsync();
                while (await reader.ReadAsync())
                {
                    categories.Add(new Category
                    {
                        CategoryId = reader.GetInt32(0),
                        CategoryName = reader.GetString(1)
                    });
                }
            }

            return categories;
        }
    }
}
