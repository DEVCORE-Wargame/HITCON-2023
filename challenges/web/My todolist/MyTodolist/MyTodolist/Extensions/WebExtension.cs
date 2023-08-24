using Newtonsoft.Json;

namespace MyTodolist.Extensions
{
    public static class WebExtension
    {
        public static T Clone<T>(this T source)
        {

            if (source != null)
            {
                var s = new JsonSerializerSettings
                {
                    PreserveReferencesHandling = PreserveReferencesHandling.Objects,
                    ObjectCreationHandling = ObjectCreationHandling.Replace,
                    MetadataPropertyHandling = MetadataPropertyHandling.ReadAhead,
                    NullValueHandling = NullValueHandling.Include,
                    TypeNameHandling = TypeNameHandling.All
                };
                return (T)JsonConvert.DeserializeObject(JsonConvert.SerializeObject(source, s), s);
            }
            else
            {
                return default(T);
            }
        }
    }
}