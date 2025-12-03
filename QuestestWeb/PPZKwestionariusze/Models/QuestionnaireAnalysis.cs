namespace PPZKwestionariusze.Models
{
    public class QuestionnaireAnalysis
    {
        public int QuestionnaireId { get; set; }
        public int NumsFilled { get; set; }
        public int MaxScore { get; set; }
        public List<QuestionAnalysis> Questions { get; set; } = new List<QuestionAnalysis>();
    }
}
