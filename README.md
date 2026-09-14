# RD Ledger

Vercel-ready recurring-deposit customer and payment tracker.

## Set up

1. Create a Supabase project and run `supabase/schema.sql` in its SQL Editor.
2. In Supabase Authentication, enable Email (magic link) sign-in and add your Vercel URL to Redirect URLs.
3. Copy `.env.example` to `.env.local` and add the Project URL and publishable key from Supabase Connect.
4. Run `npm install` then `npm run dev`. Push this folder to GitHub and import it in Vercel; add the same two environment variables there.

The SQL enables Row Level Security: every signed-in user sees only their own customers and payments. Do not use a Supabase service-role key in Vercel or the browser.
