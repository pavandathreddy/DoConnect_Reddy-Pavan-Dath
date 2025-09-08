using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using DoConnect.Api.Controllers;

// ... other using directives

namespace DoConnect.Api.Models
{
    public class Question
    {
        public int QuestionId { get; set; }
        public string Title { get; set; }
        public string Text { get; set; }
        public string Status { get; set; }

        // Foreign key
        public int UserId { get; set; }
        public User User { get; set; }

        // Navigation
        public ICollection<Answer> Answers { get; set; }
        public ICollection<Image> Images { get; set; }
    }
}
