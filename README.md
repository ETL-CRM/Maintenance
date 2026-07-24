# Enam Trims Ltd — Maintenance ERP

A single-file web app (`index.html`) for tracking machines, preventive maintenance,
breakdowns, spare parts, repair costs, and risk — with role-based logins and
Admin-controlled permissions. Data is stored in Supabase; the site itself is
static, so it deploys to Vercel with no build step.

This guide takes you through all three services in order: **Supabase first**
(database), **GitHub second** (source control), **Vercel last** (hosting).

---

## 1. Supabase — create your database

1. Go to [supabase.com](https://supabase.com) → sign in → **New project**.
   - Pick any name (e.g. `enam-trims-maintenance`), a strong database password
     (save it somewhere safe — you likely won't need it again for this app),
     and the region closest to Bangladesh (e.g. Singapore).
   - Wait ~2 minutes for the project to finish provisioning.

2. Open **SQL Editor** (left sidebar) → **New query**. Paste the entire
   contents of [`supabase/schema.sql`](./supabase/schema.sql) from this repo
   and click **Run**. This creates one table, `erp_store`, that holds all the
   app's data.

3. Open **Settings → API** (left sidebar). You need two values from this page:
   - **Project URL** — looks like `https://abcdefgh.supabase.co`
   - **anon public** key — a long string under "Project API keys"

   Keep this tab open — you'll paste both into `index.html` in step 3 below.

> This app doesn't use Supabase Auth — it has its own simple username/password
> system built in (Admin creates every login). So you only need the table
> above; no auth configuration in Supabase itself.

---

## 2. Add your Supabase keys to the app

1. Open `index.html` in any text editor (or directly on GitHub once you've
   pushed it — see step 3).
2. Find these two lines near the top of the big `<script>` block (search for
   `SUPABASE_URL`):
   ```js
   const SUPABASE_URL = 'YOUR_SUPABASE_PROJECT_URL';
   const SUPABASE_ANON_KEY = 'YOUR_SUPABASE_ANON_PUBLIC_KEY';
   ```
3. Replace both placeholder strings with the **Project URL** and **anon
   public** key from Supabase step 1.3 above. Save the file.

That's the only edit needed anywhere in the project.

---

## 3. GitHub — push the code

If you're comfortable with git, this is the whole thing:

```bash
cd enam-trims-maintenance-erp
git init
git add .
git commit -m "Enam Trims Maintenance ERP"
git branch -M main
git remote add origin https://github.com/YOUR-USERNAME/enam-trims-maintenance-erp.git
git push -u origin main
```

If you'd rather not use the command line:

1. Go to [github.com/new](https://github.com/new), create a repository named
   e.g. `enam-trims-maintenance-erp` (private is fine).
2. On the empty repo page, click **uploading an existing file**, drag in
   `index.html` and the `supabase/` folder, and commit.

**Keep the folder flat** — `index.html` should sit at the **root** of the
repo, not inside a subfolder. Vercel looks for it there by default, and this
avoids the folder-structure issues that come up when a project is nested
one level too deep.

---

## 4. Vercel — deploy it

1. Go to [vercel.com](https://vercel.com) → sign in (GitHub login is easiest)
   → **Add New… → Project**.
2. **Import** the `enam-trims-maintenance-erp` repo you just pushed.
3. Framework Preset: leave it as **Other** (Vercel auto-detects a static
   site since there's no `package.json` — no build command, no output
   directory to configure).
4. Click **Deploy**. It finishes in under a minute.
5. Open the `.vercel.app` URL Vercel gives you — that's your live app.

**If you plan to use it on your phone or share the link before it's ready**,
check **Project → Settings → Deployment Protection** and make sure it's set
to **Off** (or add your team's emails to the bypass list) — otherwise Vercel's
login wall will block mobile access the same way it did on your CRM project.

---

## 5. First run

Open the live URL. Since no one has an account yet, you'll be asked to
create the **first Admin account** — pick a username and password for
yourself. From there:

- **Machines & Utilities** → click **Load Starter Machine List** to bring in
  your real 68-machine asset register (Offset, PFL, Woven, Thermal, Heat
  Seal, Prepress, Utility, ETP, Fire & Safety).
- **Users & Access** → add your team. Your 4 known maintenance staff show up
  as a **Prefill** shortcut so you're not retyping their names/roles/phones.
- **Users & Access → Access** button on anyone → fine-tune exactly what that
  one person can see or edit, beyond their role's default.
- **Help & Examples** in the sidebar walks through the whole system with
  real examples (reporting a breakdown, completing a PM task, requesting a
  spare part, setting a custom permission).

---

## Updating the app later

Whenever you want changes: edit `index.html`, commit, and push to GitHub —
Vercel redeploys automatically on every push to `main`. Your data stays put
in Supabase; nothing about redeploying touches it.

## A note on security

The anon key you pasted into `index.html` is visible to anyone who views the
page source — that's normal for Supabase apps that don't use a backend
server. The database policies (in `schema.sql`) allow that key to read and
write the app's data table. This is appropriate for an internal company tool
shared over a link you control, the same way your other internal apps work —
but don't treat the link as something safe to post publicly.
