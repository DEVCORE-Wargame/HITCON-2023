using Isopoh.Cryptography.Argon2;

namespace MyTodolist.Services
{
    public class HashService
    {
        public static string HashPassword(string password)
        {
            var passwordHash = Argon2.Hash(password);
            return passwordHash;
        }

        public static bool VerifyHash(string password, string passwordHash)
        {
            return Argon2.Verify(passwordHash, password);
        }
    }
}