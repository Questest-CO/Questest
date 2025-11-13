namespace PPZKwestionariusze.Models
{
    // rekord w przeglądarce
    public class QuestionnaireViewModel
    {
        public int Id { get; set; }
        public string Title { get; set; }
        public int CreatedBy { get; set; }
        public DateTime DateCreated { get; set; }
        public string IsPrivate { get; set; }
        public string CreatedByUsername { get; set; }
        public int QuestionCount { get; set; }
        public int FillCount { get; set; }
        public List<int> PermittedUsers { get; set; } = new();
    }

}
