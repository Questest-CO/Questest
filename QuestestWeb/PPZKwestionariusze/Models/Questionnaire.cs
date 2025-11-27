namespace PPZKwestionariusze.Models {
    public class Questionnaire
    {
        public int Id { get; set; }
        public string Title { get; set; }
        public int CreatedBy { get; set; }
        public DateTime DateCreated { get; set; }
        public string IsPrivate { get; set; }
        public List<Question> Questions { get; set; } = new();
        public List<int> PermittedUsers { get; set; } = new();
        public int? CategoryId { get; set; }
    }

}
