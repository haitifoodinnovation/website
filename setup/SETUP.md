# Switching on accounts, ordering and the admin dashboard

The pages are already in the site (Order, Account, admin.html). They stay in
"not switched on yet" mode until you connect the free Supabase backend:

1. Go to supabase.com -> Start your project -> sign up with haitifoodinnovationET@gmail.com (free plan).
2. Create a New Project. Name: haiti-website. Set a strong database password (record sheet!).
   Region: choose Europe (closest to Ethiopia). Wait ~2 minutes for it to build.
3. Left menu -> SQL Editor -> New query. Open the file setup/supabase-setup.sql from this ZIP,
   copy ALL of it, paste, press RUN. It should say "Success".
4. Left menu -> Authentication -> Sign In / Providers -> Email: turn OFF "Confirm email"
   (Supabase's built-in mailer is limited; customers sign in instantly instead).
   Then Authentication -> URL Configuration -> Site URL: https://haitifoodinnovationet.com
5. Left menu -> Project Settings -> API. Copy "Project URL" and the "anon public" key.
6. Open assets/js/supabase-config.js in the ZIP, paste the two values between the quotes, save.
7. Upload the changed/new files to GitHub (assets/js/, order.html, account.html, admin.html,
   all regenerated pages) exactly as before, commit.
8. On the live site: open Account -> Create account with haitifoodinnovationET@gmail.com.
9. Back in Supabase SQL Editor, run the single line at the bottom of supabase-setup.sql
   (section 6) to make that account the admin.
10. Sign in on the site -> Account -> Admin dashboard -> Payment settings:
    enter the real telebirr number and bank account details customers should pay to.
    Then set prices under Products & prices.

The anon public key is designed to be public (security is enforced by database rules),
so it is safe inside the website files. Never paste the "service_role" key anywhere.
