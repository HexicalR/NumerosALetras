using Microsoft.Data.SqlClient;
using System.Data;

namespace DB
{
    public class User
    {
        public void RegisterUser(UserDTO user)
        {
            using (SqlConnection conn = new SqlConnection("Server=Hexical;Database=NumerosALetras;Trusted_Connection=True;TrustServerCertificate=True;"))
            {
                using (SqlCommand cmd = new SqlCommand("CreateUser", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@FirstName", user.firstName);
                    cmd.Parameters.AddWithValue("@LastName", user.lastName);
                    cmd.Parameters.AddWithValue("@Username", user.userName);
                    cmd.Parameters.AddWithValue("@Password", user.password);
                    cmd.Parameters.AddWithValue("@IsActive", user.isActive);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
            }
        }

        public UserDTO GetUserByUsername(string username)
        {
            using (SqlConnection conn = new SqlConnection("Server=Hexical;Database=NumerosALetras;Trusted_Connection=True;TrustServerCertificate=True;"))
            {
                using (var command = new SqlCommand("sp_GetUserByUsername", conn))
                {
                    command.CommandType = System.Data.CommandType.StoredProcedure;
                    command.Parameters.AddWithValue("@Username", username);

                    conn.Open();
                    using (var reader = command.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            return new UserDTO
                            {
                                UserId = reader["UserId"].ToString(),
                                firstName = reader["FirstName"].ToString(),
                                lastName = reader["LastName"].ToString(),
                                userName = reader["Username"].ToString(),
                                password = reader["PasswordHash"].ToString(),
                                isActive = (bool)reader["IsActive"]
                            };
                        }
                    }
                }
            }
            return null; // Usuario no encontrado
        }
    }
}
