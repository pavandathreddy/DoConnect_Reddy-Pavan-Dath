using System.ComponentModel.DataAnnotations;

namespace DoConnect.Api.Models
{
    public class Answer
    {
        public int AnswerId { get; set; }
        public string Text { get; set; }
        public string Status { get; set; }

        // Foreign keys
        public int UserId { get; set; }
        public User User { get; set; }

        public int QuestionId { get; set; }
        public Question Question { get; set; }

        // Navigation
        public ICollection<Image> Images { get; set; }
    }
}

