using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using Microsoft.OpenApi.Models;
using System.Text;
using DoConnect.Api.Data;

var builder = WebApplication.CreateBuilder(args);

// Configuration
var config = builder.Configuration;

// Add DbContext
builder.Services.AddDbContext<DoConnectDbContext>(options =>
    options.UseSqlServer(config.GetConnectionString("DefaultConnection")));

// Add services
builder.Services.AddScoped<DoConnect.Api.Services.JwtService>();

// Add Authentication
var jwt = config.GetSection("Jwt");
#pragma warning disable CS8604 // Possible null reference argument.
var key = Encoding.UTF8.GetBytes(jwt["Key"]);
#pragma warning restore CS8604 // Possible null reference argument.
builder.Services.AddAuthentication(options =>
{
    options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
    options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
})
.AddJwtBearer(options =>
{
    options.RequireHttpsMetadata = false;
    options.SaveToken = true;
    options.TokenValidationParameters = new TokenValidationParameters
    {
        ValidateIssuer = true,
        ValidateAudience = true,
        ValidateIssuerSigningKey = true,
        ValidIssuer = jwt["Issuer"],
        ValidAudience = jwt["Audience"],
        IssuerSigningKey = new SymmetricSecurityKey(key),
        ValidateLifetime = true
    };
});

builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(c =>
{
    c.AddSecurityDefinition("Bearer", new OpenApiSecurityScheme
    {
        Description = "JWT Authorization header using the Bearer scheme (Example: 'Bearer {token}')",
        Name = "Authorization",
        In = ParameterLocation.Header,
        Type = SecuritySchemeType.ApiKey
    });
    c.AddSecurityRequirement(new OpenApiSecurityRequirement{
       {
         new OpenApiSecurityScheme{
           Reference = new OpenApiReference { Type = ReferenceType.SecurityScheme, Id = "Bearer" }
         },
         new string[]{}
       }
    });
});

// ✅ Allow Angular frontend (both ports 4000 & 4200)
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowFrontend",
        b => b.WithOrigins("http://localhost:4000", "http://localhost:4200")
              .AllowAnyHeader()
              .AllowAnyMethod());
});

var app = builder.Build();

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseCors("AllowFrontend");

app.UseStaticFiles(); // to serve uploaded images

app.UseRouting();
app.UseAuthentication();
app.UseAuthorization();

app.MapControllers();

app.Run();
