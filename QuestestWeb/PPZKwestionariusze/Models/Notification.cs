namespace PPZKwestionariusze.Models
{
    public class Notification
    {
        public int Id { get; set; }
        public string Text { get; set; }
        public DateTime DateSent { get; set; }
        public DateTime? DateRead { get; set; }
        public int UserId { get; set; }

    }
}
