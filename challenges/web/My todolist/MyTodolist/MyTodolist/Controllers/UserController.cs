using MongoDB.Driver;
using System.Linq;
using System.Web.Mvc;
using MyTodolist.Models;
using MyTodolist.Services;

namespace MyTodolist.Controllers
{
    public class UserController : Controller
    {
        [HttpGet]
        public ActionResult Login()
        {
            ViewBag.Title = "Login";
            return View();
        }

        [HttpPost]
        public ActionResult DoLogin()
        {
            var username = Request.Form["username"];
            var password = Request.Form["password"];
            if (string.IsNullOrEmpty(username) || string.IsNullOrEmpty(password))
            {
                return Redirect("/User/Login");
            }

            var db = MongoService.GetDatabase();
            var users = db.GetCollection<User>("User").Find(u => u.Username == username).ToList();
            if (users.Count > 0)
            {
                var hash = HashService.HashPassword(password);
                if (HashService.VerifyHash(password, hash))
                {
                    AuthenticationService.SignIn(users[0]);
                    return Redirect("/Home/Index");
                }
            }
            TempData["Message"] = "Username not found or password incorrent.";
            return Redirect("/User/Login");
        }

        public ActionResult Logout()
        {
            AuthenticationService.SignOut();
            return Redirect("/User/Login");
        }

        public ActionResult DoRegister()
        {
            var username = Request.Form["username"];
            var password = Request.Form["password"];
            if (string.IsNullOrEmpty(username) || string.IsNullOrEmpty(password))
            {
                TempData["Message"] = "Please input username and password.";
                return Redirect("/User/Login");
            }
            var db = MongoService.GetDatabase();
            var collection = db.GetCollection<User>("User");
            var users = collection.Find(u => u.Username == username).ToList();
            if (users.Count > 0)
            {
                TempData["Message"] = "This username is already taken.";
                return Redirect("/User/Login");
            }
            var user = new User();
            user.Username = username;
            user.Password = HashService.HashPassword(password);
            collection.InsertOne(user);
            TempData["Message"] = "Successfully registered, please re-login again.";
            return Redirect("/User/Login");
        }
    }
}