namespace PPZKwestionariusze.Models
{
    public class QuestionAnswerOpen
    {
        public int QuestionnaireFilledId { get; set; }
        public int QuestionId { get; set; }
        public string Answer { get; set; } = string.Empty;
    }
}
