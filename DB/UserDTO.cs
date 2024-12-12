using Microsoft.Data.SqlClient;
using System.Data;

namespace DB
{
    public class UserDTO
    {
        public string UserId { get; set; }
        public string firstName { get; set; }
        public string lastName { get; set; }
        public string userName { get; set; }
        public string password { get; set; }
        public bool isActive { get; set; }
    }
}