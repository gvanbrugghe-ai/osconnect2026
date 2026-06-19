# OS Connect · Gartner Review sign-up tool

A mobile web app for CSMs to track, during the event, which customers they've
contacted and which agreed to receive the Gartner review form.

- Static site → hosted on **GitHub Pages**
- Shared, live data → small **Supabase** database behind it
- Gated by a login/password and hidden from Google

---

## What it does

1. **Login gate** — shared credentials open the tool:
   - Login: `Onestock`
   - Password: `OSConnect31!2026`
2. **Full list** — after login you see every customer, grouped by **brand**.
   - Search by name, email, brand or CSM.
   - Filter by **brand** and by **CSM** (dropdowns).
   - Per customer, two toggles: **Contacted** (Yes/No) and **Subscribed** (Yes/No).
   - Everyone starts at **No / No**. **Subscribed stays locked** until Contacted = Yes.
     If Contacted is set back to No, Subscribed drops back to No automatically.
   - The **email** is editable (pencil icon) and the change is written to the database.

All changes to Contacted, Subscribed and Email are saved to Supabase and shared
across every device in real time.

3. **Export CSV** — the button top-right downloads the full list at any time, with the
   current Contacted/Subscribed statuses (UTF-8, dated filename). Use it at the end of
   the event to collect the sign-ups (filter `subscribed = Yes` in Excel).

> Security note: this is a client-side gate, fine for an internal event tool, but
> the login/password live in the page source (any published page's source is public).
> The Supabase *anon* key is also public by design — data access is controlled by the
> Row Level Security policies in `schema.sql`, not by hiding the key.

---

## Setup (≈10 min)

### 1. Database (Supabase)
1. supabase.com → create a free project (pick an **EU** region).
2. **SQL Editor → New query** → paste `schema.sql` → **Run**.
   This creates the empty `customers` table and the access policies (no data).
3. Load your customers from CSV: **Table Editor → customers → Insert → Import data from CSV**,
   then upload your file based on `customers_template.csv`.
   - Headers must be exactly: `brand,last_name,first_name,email,csm`
   - Leave `contacted` / `subscribed` out — they default to No.
   - `id` is generated automatically — don't include it.
   - Save the CSV as **UTF-8** (in Excel: "CSV UTF-8") so accents (é, è, ï…) import correctly.
4. **Project Settings → API**: copy the **Project URL** and the **anon public** key.

### 2. Connect the app
Open `index.html`, find the `CONFIG` block near the top of the `<script>`, and paste:
```js
const SUPABASE_URL  = "https://your-project.supabase.co";
const SUPABASE_ANON_KEY = "eyJhbGci...";
```
Leaving the placeholders runs the app in **demo mode** (preview only, nothing saved).

### 3. Deploy on GitHub Pages
1. Create a **public** repo (Pages needs public on the free plan).
2. Upload `index.html` and `robots.txt` (the others are optional).
3. **Settings → Pages →** Source: *Deploy from a branch* → `main` / `/(root)` → Save.
4. Open `https://<you>.github.io/<repo>/` on your phone.

The page is `noindex` and `robots.txt` blocks crawlers, so it won't appear in Google.

---

## Customising
- **Credentials**: edit `APP_LOGIN` / `APP_PASSWORD` in the `CONFIG` block of `index.html`.
- **Columns / policies**: see `schema.sql`.

## Files
- `index.html` — the whole app (UI + logic)
- `schema.sql` — database table + RLS policies (no data)
- `customers_template.csv` — fill with your customers, then import in Supabase
- `robots.txt` — keeps search engines out
- `README.md` — this file
