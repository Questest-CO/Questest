namespace PPZKwestionariusze.Models
{
    public class Option
    {
        public int Id { get; set; }
        public string Content { get; set; }
        public string IsCorrect { get; set; }
        public int OrderNum { get; set; }
        public int QuestionId { get; set; }
        public DateTime DateCreated { get; set; }
    }

}
