using Microsoft.AspNetCore.Mvc;
using DoConnect.Api.Data;
using DoConnect.Api.Models;
using Microsoft.EntityFrameworkCore;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using System.Linq;
using System.ComponentModel.DataAnnotations;

namespace DoConnect.Api.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class QuestionsController : ControllerBase
    {
        private readonly DoConnectDbContext _context;
        public QuestionsController(DoConnectDbContext context) { _context = context; }

        // ✅ GET /api/questions/approved
        [HttpGet("approved")]
        public async Task<IActionResult> GetApproved()
        {
            var list = await _context.Questions
                .Include(x => x.Images)
                .Include(x => x.Answers)
                .Where(x => x.Status == "Approved")
                .ToListAsync();

            return Ok(list);
        }

        // ✅ GET /api/questions/search?q={query}
        [HttpGet("search")]
        public async Task<IActionResult> Search([FromQuery] string q)
        {
            if (string.IsNullOrWhiteSpace(q))
                return BadRequest("Query cannot be empty.");

            var results = await _context.Questions
                .Include(x => x.Images)
                .Include(x => x.Answers)
                .Where(x =>
                    x.Status == "Approved" &&
                    ((x.Title != null && x.Title.Contains(q)) ||
                     (x.Text != null && x.Text.Contains(q))))
                .ToListAsync();

            return Ok(results);
        }

        // ✅ GET /api/questions/{id}
        [HttpGet("{id}")]
        public async Task<IActionResult> GetById(int id)
        {
#pragma warning disable CS8620 // Argument cannot be used for parameter due to differences in the nullability of reference types.
            var q = await _context.Questions
                .Include(x => x.Answers).ThenInclude(a => a.User)
                .Include(x => x.Images)
                .SingleOrDefaultAsync(x => x.QuestionId == id && x.Status == "Approved");
#pragma warning restore CS8620 // Argument cannot be used for parameter due to differences in the nullability of reference types.

            if (q == null) return NotFound();
            return Ok(q);
        }

        // ✅ POST /api/questions
        [Authorize]
        [HttpPost]
        public async Task<IActionResult> Create([FromBody] QuestionDto dto)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            var userId = int.Parse(User.Claims
                .First(c => c.Type == System.Security.Claims.ClaimTypes.NameIdentifier).Value);

            var question = new Question
            {
                Title = dto.Title,
                Text = dto.Text,
                UserId = userId,
                Status = "Pending" // requires admin approval
            };

            _context.Questions.Add(question);
            await _context.SaveChangesAsync();

            return Ok(question);
        }
    }

    // DTO for creating questions
    public class QuestionDto
    {
        [Required] public string Title { get; set; }
        [Required] public string Text { get; set; }
    }
}
