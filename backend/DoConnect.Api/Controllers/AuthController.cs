using Microsoft.AspNetCore.Mvc;
using DoConnect.Api.Data;
using DoConnect.Api.Models;
using DoConnect.Api.Services;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using System.Security.Cryptography;
using Microsoft.AspNetCore.Cryptography.KeyDerivation;

namespace DoConnect.Api.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class AuthController : ControllerBase
    {
        private readonly DoConnectDbContext _context;
        private readonly JwtService _jwt;

        public AuthController(DoConnectDbContext context, JwtService jwt)
        {
            _context = context;
            _jwt = jwt;
        }

        [HttpPost("register")]
        public async Task<IActionResult> Register([FromBody] RegisterDto dto)
        {
            if (await _context.Users.AnyAsync(u => u.Email == dto.Email))
                return BadRequest("Email already in use.");

            var user = new User
            {
                Username = dto.Username,
                Email = dto.Email,
                PasswordHash = HashPassword(dto.Password),
                Role = dto.Role ?? "User"
            };

            _context.Users.Add(user);
            await _context.SaveChangesAsync();
            return Ok(new { message = "Registered successfully" });
        }

        [HttpPost("login")]
        public async Task<IActionResult> Login([FromBody] LoginDto dto)
        {
            var user = await _context.Users.SingleOrDefaultAsync(u => u.Email == dto.Email);
            if (user == null) return Unauthorized("Invalid credentials");

            if (!VerifyHashedPassword(user.PasswordHash, dto.Password)) return Unauthorized("Invalid credentials");

            var token = _jwt.GenerateToken(user);
            return Ok(new { token, username = user.Username, role = user.Role });
        }

        // simple hashing for demo (PBKDF2)
        private static string HashPassword(string password)
        {
            byte[] salt = new byte[128 / 8];
            using (var rng = RandomNumberGenerator.Create()) rng.GetBytes(salt);
            string hashed = Convert.ToBase64String(KeyDerivation.Pbkdf2(
                password: password, salt: salt, prf: KeyDerivationPrf.HMACSHA256,
                iterationCount: 10000, numBytesRequested: 256 / 8));
            return $"{Convert.ToBase64String(salt)}.{hashed}";
        }
        private static bool VerifyHashedPassword(string stored, string provided)
        {
            var parts = stored.Split('.');
            if (parts.Length != 2) return false;
            var salt = Convert.FromBase64String(parts[0]);
            string hashedProvided = Convert.ToBase64String(KeyDerivation.Pbkdf2(
                password: provided, salt: salt, prf: KeyDerivationPrf.HMACSHA256,
                iterationCount: 10000, numBytesRequested: 256 / 8));
            return hashedProvided == parts[1];
        }
    }

    public class RegisterDto { public string Username { get; set; } public string Email { get; set; } public string Password { get; set; } public string Role { get; set; } }
    public class LoginDto { public string Email { get; set; } public string Password { get; set; } }
}
