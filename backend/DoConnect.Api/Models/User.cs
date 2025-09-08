using System.ComponentModel.DataAnnotations;
using System.Collections.Generic;

namespace DoConnect.Api.Models
{
    public class User
    {
         public int UserId { get; set; }
        public string Username { get; set; }
        public string Email { get; set; }
        public string PasswordHash { get; set; }
        public string Role { get; set; }

        // Navigation
        public ICollection<Question> Questions { get; set; }
        public ICollection<Answer> Answers { get; set; }
    }
}
