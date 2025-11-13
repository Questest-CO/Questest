namespace PPZKwestionariusze.Models
{
    public class QuestionAnswer
    {
        public int QuestionnaireFilledId { get; set; }
        public int OptionId { get; set; }
        public string IsChosen { get; set; }
    }
}
