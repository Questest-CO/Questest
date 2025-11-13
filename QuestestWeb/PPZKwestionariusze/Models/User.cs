namespace PPZKwestionariusze.Models
{
    public class User
    {
        public int Id { get; set; }
        public string Username { get; set; }
        public string HashedPassword { get; set; }  // Zaszyfrowane hasło
        public DateTime DateCreated { get; set; }
        public string IsVisible { get; set; }
    }

}
