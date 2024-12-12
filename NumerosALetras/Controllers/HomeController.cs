using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Identity; // Para PasswordHasher
using NumerosALetras.Models;
using DB; // Referencia a tu librer�a de datos

namespace NumerosALetras.Controllers
{
    public class LoginController : Controller
    {
        private readonly PasswordHasher<string> _passwordHasher;

        public LoginController()
        {
            _passwordHasher = new PasswordHasher<string>();
        }

        // GET: Login
        [HttpGet]
        public IActionResult Index()
        {
            return View();
        }

        // POST: Login
        [HttpPost]
        public IActionResult Index(LoginViewModel model)
        {
            if (ModelState.IsValid)
            {
                try
                {
                    var dbService = new User();
                    var user = dbService.GetUserByUsername(model.Username);

                    if (user != null)
                    {
                        // Comparar contrase�as usando el PasswordHasher
                        var result = _passwordHasher.VerifyHashedPassword(null, user.password, model.Password);

                        if (result == PasswordVerificationResult.Success)
                        {
                            // Login exitoso
                            // Guardar el UserId en la sesi�n
                            HttpContext.Session.SetString("UserId", user.UserId.ToString());

                            TempData["SuccessMessage"] = "Inicio de sesi�n exitoso.";
                            return RedirectToAction("Index", "Dashboard");
                        }
                    }
                    ModelState.AddModelError(string.Empty, "Usuario o contrase�a incorrectos.");
                }
                catch (Exception ex)
                {
                    ModelState.AddModelError(string.Empty, $"Ocurri� un error al intentar iniciar sesi�n.");
                }
            }
            return View(model);
        }
        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult Logout()
        {
            // Limpiar la sesi�n
            HttpContext.Session.Clear();

            // Redirigir al login
            TempData["SuccessMessage"] = "Has cerrado sesi�n exitosamente.";
            return RedirectToAction("Index", "Login");
        }
    }

}

