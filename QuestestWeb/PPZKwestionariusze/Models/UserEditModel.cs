using System.ComponentModel.DataAnnotations;

namespace PPZKwestionariusze.Models
{
    public class UserEditModel
    {
        [Required]
        public string Username { get; set; }

        public string IsVisible { get; set; }

        public string CurrentPassword { get; set; }

        public string NewPassword { get; set; }

        public string ConfirmNewPassword { get; set; }
    }

}
