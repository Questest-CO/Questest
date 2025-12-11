namespace PPZKwestionariusze.Models
{
    public class QuestionnaireFilled
    {
        public int Id { get; set; }
        public int QuestionnaireId { get; set; }
        public DateTime DateFilled { get; set; }
        public int FilledBy { get; set; }
        public string FilledByUsername { get; set; } = "";
        public List<QuestionAnswer> Answers { get; set; } = new List<QuestionAnswer>();
        public List<QuestionAnswerOpen> AnswersOpen { get; set; } = new List<QuestionAnswerOpen>();
        public  int ResultId { get; set; }
    }
}
