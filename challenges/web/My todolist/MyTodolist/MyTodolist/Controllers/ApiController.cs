using MongoDB.Driver;
using System;
using System.Collections.Generic;
using System.Web.Mvc;
using MyTodolist.Extensions;
using MyTodolist.Models;
using MyTodolist.Services;

namespace MyTodolist.Controllers
{
    public class ApiController : Controller
    {
        [HttpPost]
        public JsonResult AddTodo()
        {
            var user = AuthenticationService.GetUser();
            var uuid = Guid.NewGuid().ToString();
            var content = Request.Form["content"];
            if (string.IsNullOrEmpty(content))
            {
                return Json(new { error = "no parameter provided" });
            }
            var todo = new Dictionary<string, object>
            {
                { "content", content }
            };
            user.Todos[uuid] = todo;
            var db = MongoService.GetDatabase();
            db.GetCollection<User>("User").ReplaceOne(u => u.Id == user.Id, user);
            return Json(new { error = false, result = "ok" });
        }

        [HttpPost]
        public JsonResult UpdateTodo()
        {
            var user = AuthenticationService.GetUser();
            var uuid = Request.Form["uuid"];
            if (string.IsNullOrEmpty(uuid) || !user.Todos.ContainsKey(uuid))
            {
                return Json(new { error = "todo is not found" });
            }
            var field = Request.Form["field"];
            var value = Request.Form["value"];
            if (string.IsNullOrEmpty(field) || string.IsNullOrEmpty(value))
            {
                return Json(new { error = "no parameter provided" });
            }
            var todo = user.Todos[uuid] as Dictionary<string, object>;
            todo[field] = value;
            var db = MongoService.GetDatabase();
            db.GetCollection<User>("User").ReplaceOne(u => u.Id == user.Id, user);
            return Json(new { error = false, result = "ok" });
        }

        [HttpPost]
        public JsonResult DeleteTodo()
        {
            var user = AuthenticationService.GetUser();
            var uuid = Request.Form["uuid"];
            if (string.IsNullOrEmpty(uuid) || !user.Todos.ContainsKey(uuid))
            {
                return Json(new { error = "todo is not found" });
            }
            user.Todos.Remove(uuid);
            var db = MongoService.GetDatabase();
            db.GetCollection<User>("User").ReplaceOne(u => u.Id == user.Id, user);
            return Json(new { error = false, result = "ok" });
        }

        [HttpPost]
        public JsonResult MyProfile()
        {
            var user = AuthenticationService.GetUser();
            if (user == null)
            {
                return Json(new { error = "not login" });
            }
            var user2 = user.Clone();
            user2.Password = "******";
            return Json(user2);
        }
    }
}