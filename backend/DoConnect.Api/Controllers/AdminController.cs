using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;
using Microsoft.EntityFrameworkCore;
using DoConnect.Api.Data;
using DoConnect.Api.Models;
using System.Threading.Tasks;

namespace DoConnect.Api.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    [Authorize(Roles = "Admin")]
    public class AdminController : ControllerBase
    {
        private readonly DoConnectDbContext _context;
        public AdminController(DoConnectDbContext context)
        {
            _context = context;
        }

        // ✅ Get pending questions
        [HttpGet("questions/pending")]
        public async Task<IActionResult> GetPendingQuestions()
        {
            var questions = await _context.Questions
                .Include(q => q.User)
                .Where(q => q.Status == "Pending")
                .ToListAsync();

            return Ok(questions);
        }

        // ✅ Get pending answers
        [HttpGet("answers/pending")]
        public async Task<IActionResult> GetPendingAnswers()
        {
            var answers = await _context.Answers
                .Include(a => a.User)
                .Where(a => a.Status == "Pending")
                .ToListAsync();

            return Ok(answers);
        }

        // ✅ Approve question
        [HttpPut("questions/{id}/approve")]
        public async Task<IActionResult> ApproveQuestion(int id)
        {
            var q = await _context.Questions.FindAsync(id);
            if (q == null) return NotFound();

            q.Status = "Approved";
            await _context.SaveChangesAsync();
            return Ok(q);
        }

        // ✅ Reject question
        [HttpPut("questions/{id}/reject")]
        public async Task<IActionResult> RejectQuestion(int id)
        {
            var q = await _context.Questions.FindAsync(id);
            if (q == null) return NotFound();

            q.Status = "Rejected";
            await _context.SaveChangesAsync();
            return Ok(q);
        }

        // ✅ Approve answer
        [HttpPut("answers/{id}/approve")]
        public async Task<IActionResult> ApproveAnswer(int id)
        {
            var a = await _context.Answers.FindAsync(id);
            if (a == null) return NotFound();

            a.Status = "Approved";
            await _context.SaveChangesAsync();
            return Ok(a);
        }

        // ✅ Reject answer
        [HttpPut("answers/{id}/reject")]
        public async Task<IActionResult> RejectAnswer(int id)
        {
            var a = await _context.Answers.FindAsync(id);
            if (a == null) return NotFound();

            a.Status = "Rejected";
            await _context.SaveChangesAsync();
            return Ok(a);
        }

        // ✅ Delete question
        [HttpDelete("questions/{id}")]
        public async Task<IActionResult> DeleteQuestion(int id)
        {
            var q = await _context.Questions.FindAsync(id);
            if (q == null) return NotFound();

            _context.Questions.Remove(q);
            await _context.SaveChangesAsync();
            return NoContent();
        }

        // ✅ Delete answer
        [HttpDelete("answers/{id}")]
        public async Task<IActionResult> DeleteAnswer(int id)
        {
            var a = await _context.Answers.FindAsync(id);
            if (a == null) return NotFound();

            _context.Answers.Remove(a);
            await _context.SaveChangesAsync();
            return NoContent();
        }
    }
}
