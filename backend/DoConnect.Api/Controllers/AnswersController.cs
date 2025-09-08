using Microsoft.AspNetCore.Mvc;
using DoConnect.Api.Data;
using DoConnect.Api.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.EntityFrameworkCore;
using System.Threading.Tasks;
using System.Linq;

namespace DoConnect.Api.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class AnswersController : ControllerBase
    {
        private readonly DoConnectDbContext _context;
        public AnswersController(DoConnectDbContext context) { _context = context; }

        [Authorize]
        [HttpPost]
        public async Task<IActionResult> Post([FromBody] Answer dto)
        {
            var userId = int.Parse(User.Claims.First(c => c.Type == System.Security.Claims.ClaimTypes.NameIdentifier).Value);
            dto.UserId = userId;
            dto.Status = "Pending";
            _context.Answers.Add(dto);
            await _context.SaveChangesAsync();
            return Ok(dto);
        }

        [Authorize(Roles = "Admin")]
        [HttpPut("{id}/status")]
        public async Task<IActionResult> SetStatus(int id, [FromQuery] string status)
        {
            var a = await _context.Answers.FindAsync(id);
            if (a == null) return NotFound();
            a.Status = status;
            await _context.SaveChangesAsync();
            return Ok(a);
        }
    }
}
