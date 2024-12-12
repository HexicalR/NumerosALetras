using Microsoft.Data.SqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data.SqlClient;
namespace DB
{
    public class LogEvent
    {
        public bool InsertLogEvent(bool executionResult, Guid executedBy, string description)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection("Server=Hexical;Database=NumerosALetras;Trusted_Connection=True;TrustServerCertificate=True;"))
                {
                    using (SqlCommand cmd = new SqlCommand("InsertEventLog", conn))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("@ExecutionResult", executionResult);
                        cmd.Parameters.AddWithValue("@ExecutedBy", executedBy);
                        cmd.Parameters.AddWithValue("@Description", description);
                        conn.Open();
                        cmd.ExecuteNonQuery();
                        return true;
                    }
                }
            }
            catch (SqlException ex)
            {
                Console.WriteLine($"Error al insertar en EventLogs: {ex.Message}");
                return false; // Fallo
            }
        }
    }
}
