@echo off
setlocal EnableExtensions

REM ==========================================================
REM Lab3 C# solution scaffold (folders + placeholder files)
REM Creates:
REM lab3-csharp/
REM   Lab3.Auth/
REM     Lab3.Auth.csproj
REM     Services/AuthService.cs
REM     Controllers/AuthController.cs
REM   Lab3.Auth.Tests/
REM     Lab3.Auth.Tests.csproj
REM     AuthServiceTests.cs
REM     AuthControllerTests.cs
REM   .github/workflows/ci.yml
REM   sonar-project.properties
REM ==========================================================

set "ROOT=lab3-csharp"

echo ==========================================
echo Creating %ROOT% structure...
echo ==========================================

REM --- folders
mkdir "%ROOT%\Lab3.Auth\Services" 2>nul
mkdir "%ROOT%\Lab3.Auth\Controllers" 2>nul
mkdir "%ROOT%\Lab3.Auth.Tests" 2>nul
mkdir "%ROOT%\.github\workflows" 2>nul

REM --- Lab3.Auth.csproj
(
echo ^<Project Sdk="Microsoft.NET.Sdk.Web"^>
echo   ^<PropertyGroup^>
echo     ^<TargetFramework^>net8.0^</TargetFramework^>
echo     ^<Nullable^>enable^</Nullable^>
echo     ^<ImplicitUsings^>enable^</ImplicitUsings^>
echo   ^</PropertyGroup^>
echo ^</Project^>
)>"%ROOT%\Lab3.Auth\Lab3.Auth.csproj"

REM --- AuthService.cs
(
echo namespace Lab3.Auth.Services;
echo.
echo public interface IAuthService
echo ^{
echo     bool Validate(string username, string password);
echo ^}
echo.
echo public sealed class AuthService : IAuthService
echo ^{
echo     public bool Validate(string username, string password)
echo     ^{
echo         // TODO: replace with real validation (hashing, DB, etc.)
echo         return username == "admin" ^&^& password == "admin";
echo     ^}
echo ^}
)>"%ROOT%\Lab3.Auth\Services\AuthService.cs"

REM --- AuthController.cs
(
echo using Lab3.Auth.Services;
echo using Microsoft.AspNetCore.Mvc;
echo.
echo namespace Lab3.Auth.Controllers;
echo.
echo [ApiController]
echo [Route("api/[controller]")]
echo public class AuthController : ControllerBase
echo ^{
echo     private readonly IAuthService _auth;
echo.
echo     public AuthController(IAuthService auth)
echo     ^{
echo         _auth = auth;
echo     ^}
echo.
echo     public sealed record LoginRequest(string Username, string Password);
echo.
echo     [HttpPost("login")]
echo     public IActionResult Login([FromBody] LoginRequest request)
echo     ^{
echo         if (request is null) return BadRequest("Missing body");
echo         var ok = _auth.Validate(request.Username, request.Password);
echo         if (!ok) return Unauthorized(new { message = "Invalid credentials" });
echo         return Ok(new { message = "OK" });
echo     ^}
echo ^}
)>"%ROOT%\Lab3.Auth\Controllers\AuthController.cs"

REM --- Lab3.Auth.Tests.csproj
(
echo ^<Project Sdk="Microsoft.NET.Sdk"^>
echo   ^<PropertyGroup^>
echo     ^<TargetFramework^>net8.0^</TargetFramework^>
echo     ^<IsPackable^>false^</IsPackable^>
echo     ^<Nullable^>enable^</Nullable^>
echo     ^<ImplicitUsings^>enable^</ImplicitUsings^>
echo   ^</PropertyGroup^>
echo.
echo   ^<ItemGroup^>
echo     ^<PackageReference Include="Microsoft.NET.Test.Sdk" Version="17.10.0" /^>
echo     ^<PackageReference Include="xunit" Version="2.9.0" /^>
echo     ^<PackageReference Include="xunit.runner.visualstudio" Version="2.8.2"^>
echo       ^<PrivateAssets^>all^</PrivateAssets^>
echo     ^</PackageReference^>
echo     ^<PackageReference Include="FluentAssertions" Version="6.12.0" /^>
echo     ^<PackageReference Include="Microsoft.AspNetCore.Mvc.Testing" Version="8.0.0" /^>
echo   ^</ItemGroup^>
echo.
echo   ^<ItemGroup^>
echo     ^<ProjectReference Include="..\Lab3.Auth\Lab3.Auth.csproj" /^>
echo   ^</ItemGroup^>
echo ^</Project^>
)>"%ROOT%\Lab3.Auth.Tests\Lab3.Auth.Tests.csproj"

REM --- AuthServiceTests.cs (unit)
(
echo using FluentAssertions;
echo using Lab3.Auth.Services;
echo using Xunit;
echo.
echo namespace Lab3.Auth.Tests;
echo.
echo public class AuthServiceTests
echo ^{
echo     [Fact]
echo     public void Validate_ReturnsTrue_ForAdminAdmin()
echo     ^{
echo         var svc = new AuthService();
echo         svc.Validate("admin", "admin").Should().BeTrue();
echo     ^}
echo.
echo     [Fact]
echo     public void Validate_ReturnsFalse_ForWrongPassword()
echo     ^{
echo         var svc = new AuthService();
echo         svc.Validate("admin", "wrong").Should().BeFalse();
echo     ^}
echo ^}
)>"%ROOT%\Lab3.Auth.Tests\AuthServiceTests.cs"

REM --- AuthControllerTests.cs (integration skeleton)
(
echo using System.Net;
echo using System.Net.Http.Json;
echo using FluentAssertions;
echo using Microsoft.AspNetCore.Mvc.Testing;
echo using Xunit;
echo.
echo namespace Lab3.Auth.Tests;
echo.
echo public class AuthControllerTests : IClassFixture^<WebApplicationFactory^<Program^>^>
echo ^{
echo     private readonly HttpClient _client;
echo.
echo     public AuthControllerTests(WebApplicationFactory^<Program^> factory)
echo     ^{
echo         _client = factory.CreateClient();
echo     ^}
echo.
echo     [Fact]
echo     public async Task Login_Returns200_ForValidCredentials()
echo     ^{
echo         var res = await _client.PostAsJsonAsync("/api/auth/login", new { username = "admin", password = "admin" });
echo         res.StatusCode.Should().Be(HttpStatusCode.OK);
echo     ^}
echo.
echo     [Fact]
echo     public async Task Login_Returns401_ForInvalidCredentials()
echo     ^{
echo         var res = await _client.PostAsJsonAsync("/api/auth/login", new { username = "admin", password = "bad" });
echo         res.StatusCode.Should().Be(HttpStatusCode.Unauthorized);
echo     ^}
echo ^}
)>"%ROOT%\Lab3.Auth.Tests\AuthControllerTests.cs"

REM --- GitHub Actions CI
(
echo name: CI
echo on:
echo   push:
echo   pull_request:
echo jobs:
echo   build-test:
echo     runs-on: ubuntu-latest
echo     steps:
echo       - uses: actions/checkout@v4
echo       - name: Setup .NET
echo         uses: actions/setup-dotnet@v4
echo         with:
echo           dotnet-version: "8.0.x"
echo       - name: Restore
echo         run: dotnet restore
echo       - name: Build
echo         run: dotnet build --no-restore -c Release
echo       - name: Test
echo         run: dotnet test --no-build -c Release --collect:"XPlat Code Coverage"
)>"%ROOT%\.github\workflows\ci.yml"

REM --- Sonar properties (generic)
(
echo sonar.projectKey=lab3-csharp
echo sonar.projectName=lab3-csharp
echo sonar.sources=Lab3.Auth
echo sonar.tests=Lab3.Auth.Tests
echo sonar.sourceEncoding=UTF-8
echo sonar.cs.opencover.reportsPaths=**/coverage.opencover.xml
)>"%ROOT%\sonar-project.properties"

echo ==========================================
echo Done.
echo ==========================================
echo Next steps:
echo   1^) cd %ROOT%
echo   2^) dotnet new sln -n lab3-csharp
echo   3^) dotnet sln add .\Lab3.Auth\Lab3.Auth.csproj
echo   4^) dotnet sln add .\Lab3.Auth.Tests\Lab3.Auth.Tests.csproj
echo   5^) dotnet test
echo ==========================================
pause

endlocal