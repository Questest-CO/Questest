namespace PPZKwestionariusze.Models
{
    public class OptionAnalysis
    {
        public int OptionId { get; set; }
        public string OptionContent { get; set; } = "";
        public string OptionIsCorrect { get; set; } = "N";
        public int Count { get; set; }
    }
}
