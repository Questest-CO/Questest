
using Microsoft.AspNetCore.Authentication.Cookies;
using PPZKwestionariusze.Components;
using PPZKwestionariusze.Services;
using PPZKwestionariusze.StateStore;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddRazorComponents()
	.AddInteractiveServerComponents();

builder.Services.AddScoped<QuestionnaireService>();
builder.Services.AddScoped<UserService>();
builder.Services.AddTransient<SessionStorage>();
builder.Services.AddScoped<OptionsService>();
builder.Services.AddScoped<QuestionService>();
builder.Services.AddScoped<QuestionnaireFilledService>();
builder.Services.AddScoped<QuestionAnswerService>();
builder.Services.AddScoped<NotificationService>();
builder.Services.AddScoped<CategoryService>();


builder.Services.AddScoped<QuestionnaireAnalysisService>();

builder.Services.AddRazorPages();
builder.Services.AddServerSideBlazor();

var app = builder.Build();


// Configure the HTTP request pipeline.
if (!app.Environment.IsDevelopment())
{
	app.UseExceptionHandler("/Error", createScopeForErrors: true);
	// The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
	app.UseHsts();
}


app.UseStaticFiles();
app.UseAntiforgery();

app.MapRazorComponents<App>()
	.AddInteractiveServerRenderMode();


app.Run();
