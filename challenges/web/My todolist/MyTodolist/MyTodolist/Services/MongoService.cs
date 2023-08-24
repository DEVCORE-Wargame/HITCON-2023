using MongoDB.Driver;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;

namespace MyTodolist.Services
{
    public class MongoService
    {
        private static MongoClient client = null;

        public static IMongoDatabase GetDatabase()
        {
            string databaseName = ConfigurationManager.AppSettings["databaseName"];
            if (client != null)
            {
                return client.GetDatabase(databaseName);
            }
            string connectStr = ConfigurationManager.AppSettings["connectionString"];
            client = new MongoClient(connectStr);
            return client.GetDatabase(databaseName);
        }
    }
}