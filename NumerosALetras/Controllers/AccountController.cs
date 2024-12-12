using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Identity;
using NumerosALetras.Models;
using DB;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.Cookies;

namespace NumerosALetras.Controllers
{
    public class AccountController : Controller
    {
        private readonly PasswordHasher<string> _passwordHasher;

        public AccountController()
        {
            _passwordHasher = new PasswordHasher<string>();
        }

        // GET: Account/Register
        [HttpGet]
        public IActionResult Register()
        {
            return View();
        }

        // POST: Account/Register
        [HttpPost]
        public IActionResult Register(RegisterViewModel model)
        {
            if (ModelState.IsValid)
            {
                try
                {
                    var hashedPassword = _passwordHasher.HashPassword(null, model.Password);

                    var user = new UserDTO
                    {
                        firstName = model.FirstName,
                        lastName = model.LastName,
                        userName = model.Username,
                        password = hashedPassword,
                        isActive = true
                    };

                    var dbService = new User();
                    dbService.RegisterUser(user);

                    return RedirectToAction("Index", "Login");
                }
                catch (Exception ex)
                {
                    ModelState.AddModelError(string.Empty, $"Ocurrió un error al intentar registrarse.");
                }
            }
            return View(model);
        }
    }
}
