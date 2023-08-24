using MongoDB.Driver;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using MyTodolist.Models;

namespace MyTodolist.Services
{
    public class AuthenticationService
    {
        public static void SignIn(User user)
        {
            var ticket = new FormsAuthenticationTicket(
                1,
                user.Username,
                DateTime.Now,
                DateTime.Now.AddMinutes(60),
                false,
                user.Id,
                FormsAuthentication.FormsCookiePath);

            var encTicket = FormsAuthentication.Encrypt(ticket);
            HttpContext.Current.Response.Cookies.Add(
                new HttpCookie(FormsAuthentication.FormsCookieName, encTicket));
        }

        public static void SignOut()
        {
            FormsAuthentication.SignOut();
        }

        public static User GetUser()
        {
            var user = HttpContext.Current.User;

            if (user?.Identity?.IsAuthenticated == true)
            {
                var identity = (FormsIdentity)user.Identity;
                var userId = identity.Ticket.UserData;
                var users = MongoService.GetDatabase().GetCollection<User>("User").Find(u => u.Id == userId).ToList();
                if (users.Count == 0)
                {
                    return null;
                }
                if (users[0].Todos == null)
                {
                    users[0].Todos = new Dictionary<string, object>();
                }
                return users[0];

            }
            return null;
        }
    }
}