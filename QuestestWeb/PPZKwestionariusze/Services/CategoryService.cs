using System.Collections.Generic;
using System.Data;
using System.Threading.Tasks;
using Microsoft.Extensions.Configuration;
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
            var list = new List<Category>();

            using var conn = new OracleConnection(_connectionString);
            await conn.OpenAsync();

            var cmd = new OracleCommand(
                "SELECT ID, NAME FROM CATEGORIES ORDER BY ID",
                conn);

            var reader = await cmd.ExecuteReaderAsync();
            while (await reader.ReadAsync())
            {
                list.Add(new Category
                {
                    Id = reader.GetInt32(0),
                    Name = reader.GetString(1)
                });
            }

            return list;
        }

        public async Task<int> AddCategoryAsync(Category category)
        {
            using var conn = new OracleConnection(_connectionString);
            await conn.OpenAsync();

            var cmd = new OracleCommand(
                "INSERT INTO CATEGORIES (NAME) VALUES (:Name) RETURNING ID INTO :NewId",
                conn);

            cmd.Parameters.Add(new OracleParameter(":Name", category.Name));

            var idParam = new OracleParameter(":NewId", OracleDbType.Int32)
            {
                Direction = ParameterDirection.Output
            };
            cmd.Parameters.Add(idParam);

            await cmd.ExecuteNonQueryAsync();
            return Convert.ToInt32(idParam.Value);
        }

        public async Task DeleteCategoryAsync(int id)
        {
            using var conn = new OracleConnection(_connectionString);
            await conn.OpenAsync();

            var cmd = new OracleCommand(
                "DELETE FROM CATEGORIES WHERE ID = :Id",
                conn);

            cmd.Parameters.Add(new OracleParameter(":Id", id));
            await cmd.ExecuteNonQueryAsync();
        }
    }
}
