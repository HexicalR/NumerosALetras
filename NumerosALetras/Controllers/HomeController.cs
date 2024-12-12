using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Identity; // Para PasswordHasher
using NumerosALetras.Models;
using DB; // Referencia a tu librería de datos

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
                        // Comparar contraseñas usando el PasswordHasher
                        var result = _passwordHasher.VerifyHashedPassword(null, user.password, model.Password);

                        if (result == PasswordVerificationResult.Success)
                        {
                            // Login exitoso
                            // Guardar el UserId en la sesión
                            HttpContext.Session.SetString("UserId", user.UserId.ToString());

                            TempData["SuccessMessage"] = "Inicio de sesión exitoso.";
                            return RedirectToAction("Index", "Dashboard");
                        }
                    }
                    ModelState.AddModelError(string.Empty, "Usuario o contraseña incorrectos.");
                }
                catch (Exception ex)
                {
                    ModelState.AddModelError(string.Empty, $"Ocurrió un error al intentar iniciar sesión.");
                }
            }
            return View(model);
        }
        [HttpPost]
        [ValidateAntiForgeryToken]
        public IActionResult Logout()
        {
            // Limpiar la sesión
            HttpContext.Session.Clear();

            // Redirigir al login
            TempData["SuccessMessage"] = "Has cerrado sesión exitosamente.";
            return RedirectToAction("Index", "Login");
        }
    }

}

