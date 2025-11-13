namespace PPZKwestionariusze.Models
{
    public class Question
    {
        public int Id { get; set; }
        public string Content { get; set; }
        public int QuestionnaireId { get; set; }
        public DateTime DateCreated { get; set; }
        public List<Option> Options { get; set; } = new();
    }

}
