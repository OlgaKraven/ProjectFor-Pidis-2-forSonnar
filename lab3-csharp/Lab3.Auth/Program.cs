// Lab3.Auth/Program.cs
using Lab3.Auth.Services;

var builder = WebApplication.CreateBuilder(args);
builder.Services.AddControllers();
builder.Services.AddSingleton<IAuthService, AuthService>();

var app = builder.Build();
app.MapControllers();
app.Run();

// Частичный класс нужен для доступа из тестов
public partial class Program { }