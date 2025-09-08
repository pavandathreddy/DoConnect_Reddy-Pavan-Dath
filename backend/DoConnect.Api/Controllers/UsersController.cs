using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using DoConnect.Api.Data;
using Microsoft.EntityFrameworkCore;
using System.Threading.Tasks;
using DoConnect.Api.Models;

namespace DoConnect.Api.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    [Authorize(Roles = "Admin")]
    public class UsersController : ControllerBase
    {
        private readonly DoConnectDbContext _context;
        public UsersController(DoConnectDbContext context) { _context = context; }

        [HttpGet]
        public async Task<IActionResult> GetAll() => Ok(await _context.Users.AsNoTracking().ToListAsync());

        [HttpGet("{id}")]
        public async Task<IActionResult> Get(int id)
        {
            var u = await _context.Users.FindAsync(id);
            if (u == null) return NotFound();
            return Ok(u);
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> Update(int id, User update)
        {
            var u = await _context.Users.FindAsync(id);
            if (u == null) return NotFound();
            u.Username = update.Username ?? u.Username;
            u.Role = update.Role ?? u.Role;
            await _context.SaveChangesAsync();
            return Ok(u);
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(int id)
        {
            var u = await _context.Users.FindAsync(id);
            if (u == null) return NotFound();
            _context.Users.Remove(u);
            await _context.SaveChangesAsync();
            return NoContent();
        }
    }
}
