namespace PPZKwestionariusze.Models
{
    public class QuestionAnalysis
    {
        public int QuestionId { get; set; }
        public string QuestionContent { get; set; } = "";
        public bool QuestionIsOpen { get; set; }
        public List<OptionAnalysis> Options { get; set; } = new List<OptionAnalysis>();
    }
}
