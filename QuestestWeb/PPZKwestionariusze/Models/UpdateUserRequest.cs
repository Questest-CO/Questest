namespace PPZKwestionariusze.Models
{
    public class UpdateUserRequest
    {
        public int Id { get; set; }
        public string NewUsername { get; set; }
        public string IsVisible { get; set; }
        public string NewPassword { get; set; } 
    }

}
