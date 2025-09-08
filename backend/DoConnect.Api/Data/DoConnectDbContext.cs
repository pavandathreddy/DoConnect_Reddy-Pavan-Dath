using Microsoft.EntityFrameworkCore;
using DoConnect.Api.Models;

namespace DoConnect.Api.Data
{
    public class DoConnectDbContext : DbContext
    {
        public DoConnectDbContext(DbContextOptions<DoConnectDbContext> options) : base(options) { }

        public DbSet<User> Users { get; set; }
        public DbSet<Question> Questions { get; set; }
        public DbSet<Answer> Answers { get; set; }
        public DbSet<Image> Images { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            modelBuilder.Entity<Answer>()
                .HasOne(a => a.User)
                .WithMany(u => u.Answers)
                .HasForeignKey(a => a.UserId)
                .OnDelete(DeleteBehavior.Restrict);

            modelBuilder.Entity<Answer>()
                .HasOne(a => a.Question)
                .WithMany(q => q.Answers)
                .HasForeignKey(a => a.QuestionId)
                .OnDelete(DeleteBehavior.Cascade); // keep cascade here

            modelBuilder.Entity<Image>()
                .HasOne(i => i.Question)
                .WithMany(q => q.Images)
                .HasForeignKey(i => i.QuestionId)
                .OnDelete(DeleteBehavior.Cascade); // keep cascade from question

            modelBuilder.Entity<Image>()
                .HasOne(i => i.Answer)
                .WithMany(a => a.Images)
                .HasForeignKey(i => i.AnswerId)
                .OnDelete(DeleteBehavior.Restrict); // ❌ change to Restrict/NoAction
        }

    }
}