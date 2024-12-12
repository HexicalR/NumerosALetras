using DB;
using Microsoft.AspNetCore.Mvc;
using NumerosALetras.Request;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace NumerosALetras.Controllers
{
    public class DashboardController : Controller
    {
        public IActionResult Index()
        {
            Guid userId = Guid.Parse(HttpContext.Session.GetString("UserId") ?? Guid.Empty.ToString());

           if (userId == Guid.Empty)
            {
                return RedirectToAction("Login", "Account");
            }

            ViewBag.UserId = userId;

            return View();
        }
        [HttpPost]
        public IActionResult LogEvent([FromBody] LogEventRequest request)
        {
            try
            {
                var dbService = new LogEvent();
                bool result = dbService.InsertLogEvent(request.ExecutionResult, request.UserId, request.Description);

                if (result)
                {
                    return Json(new { success = true, message = "Evento registrado correctamente." });
                }
                else
                {
                    return Json(new { success = false, message = "No se pudo registrar el evento." });
                }
            }
            catch (Exception ex)
            {
                return Json(new { success = false, message = $"Error: {ex.Message}" });
            }
        }

    }
}
