using Microsoft.AspNetCore.Components.Server.ProtectedBrowserStorage;
using PPZKwestionariusze.Models;


namespace PPZKwestionariusze.StateStore
{
    public class SessionStorage
    {
        private readonly ProtectedSessionStorage protectedSessionStorage;
        public SessionStorage(ProtectedSessionStorage pss)
        {
            this.protectedSessionStorage = pss; 
        }
        public async Task<UserStorageModel?> GetUserAsync()
        {
            var res = await this.protectedSessionStorage.GetAsync<UserStorageModel>("user");
            if (res.Success)
            {
                return res.Value;
            }
            return null;
        }

        public async Task SetUserAsync(UserStorageModel usr)
        {
            await this.protectedSessionStorage.SetAsync("user", usr);
        }
    }
}
