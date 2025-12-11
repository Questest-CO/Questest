namespace PPZKwestionariusze.Models
{
    public class QuizResult
    {
        public int Id { get; set; }
        public int QuestionnaireId { get; set; }
        public string Title { get; set; } = "";
        public string Description { get; set; } = "";
    }
}
