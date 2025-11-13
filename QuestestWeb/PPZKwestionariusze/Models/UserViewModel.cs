namespace PPZKwestionariusze.Models
{
    public class UserViewModel
    {
        public int Id { get; set; }
        public string Username { get; set; }
        public DateTime DateCreated { get; set; }
        public int QuestionnaireCount { get; set; }
        public int FillCount { get; set; }
        public string IsVisible { get; set; }
    }

}
