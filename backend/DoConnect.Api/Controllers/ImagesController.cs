using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Http;
using System.IO;
using System.Threading.Tasks;
using DoConnect.Api.Data;
using DoConnect.Api.Models;
using Microsoft.AspNetCore.Hosting;

namespace DoConnect.Api.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class ImagesController : ControllerBase
    {
        private readonly DoConnectDbContext _context;
        private readonly IWebHostEnvironment _env;
        public ImagesController(DoConnectDbContext context, IWebHostEnvironment env) { _context = context; _env = env; }

        [HttpPost("upload")]
        public async Task<IActionResult> Upload([FromForm] IFormFile file, [FromForm] int? questionId, [FromForm] int? answerId)
        {
            if (file == null || file.Length == 0) return BadRequest("No file provided");

            var uploads = Path.Combine(_env.ContentRootPath, "uploads");
            if (!Directory.Exists(uploads)) Directory.CreateDirectory(uploads);

            var fileName = $"{Path.GetRandomFileName()}{Path.GetExtension(file.FileName)}";
            var filePath = Path.Combine(uploads, fileName);
            using (var stream = new FileStream(filePath, FileMode.Create))
            {
                await file.CopyToAsync(stream);
            }

            var image = new Image
            {
                FilePath = $"/uploads/{fileName}",
                QuestionId = questionId,
                AnswerId = answerId
            };
            _context.Images.Add(image);
            await _context.SaveChangesAsync();
            return Ok(image);
        }
    }
}
