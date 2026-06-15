# KADO — AI Life Secretary

Your private, personalised AI secretary: work tracker, expenses, reminders/alarms,
AI chat & idea lab, all in your brand colours (navy, orange, black, white), with
dark/light mode and English / Kiswahili / Français support.

This guide gets you fully deployed — live on the internet, installable on your
phone and PC as an app, with your data privately stored and synced via Supabase.

---

## What you need before starting

1. A free **Netlify** account (netlify.com) — you already have one.
2. Your **Supabase** project (already created): `https://lrtjuqryoklhgarrfrpx.supabase.co`
3. An **Anthropic API key** — get one at https://console.anthropic.com → API Keys
   → "Create Key". This powers your AI Secretary chat and Idea Lab.
   (Note: this is a paid API — usage is billed per request, but very cheap for
   personal use — a few thousand TZS per month for daily chatting.)

---

## STEP 1 — Set up your Supabase database

1. Go to https://supabase.com → open your project (`lrtjuqryoklhgarrfrpx`)
2. Click **SQL Editor** (left sidebar) → **New query**
3. Open the file `supabase-schema.sql` from this folder, copy ALL of it
4. Paste into the SQL editor → click **Run**
5. You should see "Success. No rows returned" — your tables are created.

This creates 5 tables (tasks, expenses, reminders, chat_history, settings),
each locked with Row Level Security so ONLY your logged-in account can ever
read or write your data. Not Anthropic, not Supabase staff, not anyone else.

### Enable email sign-in (it's on by default, but double check)
1. In Supabase: **Authentication** → **Providers** → make sure **Email** is enabled
2. **Authentication** → **Settings** → for a personal app, you can turn OFF
   "Confirm email" so you can sign in immediately after creating your account
   (Settings → Auth → "Email Auth" → toggle off "Confirm email")

---

## STEP 2 — Deploy to Netlify

### Option A — Drag and drop (fastest)
1. Go to https://app.netlify.com → **Add new site** → **Deploy manually**
2. Drag this entire `kado-secretary` folder onto the upload area
3. Wait ~30 seconds — you'll get a live URL like `https://random-name-123.netlify.app`

### Option B — Connect to GitHub (better for future updates)
1. Create a new GitHub repo, push this folder's contents to it
2. Netlify → **Add new site** → **Import an existing project** → connect GitHub
   → select your repo
3. Build settings: leave as default (netlify.toml handles it)
4. Deploy

### Add your Anthropic API key (REQUIRED for AI features)
1. In Netlify: your site → **Site configuration** → **Environment variables**
2. Click **Add a variable**
   - Key: `ANTHROPIC_API_KEY`
   - Value: paste your key from console.anthropic.com (starts with `sk-ant-...`)
3. Click **Save**
4. Go to **Deploys** → **Trigger deploy** → **Deploy site** (so the function picks up the key)

Without this step, the AI Secretary chat and Idea Lab will show an error —
everything else (tasks, expenses, reminders) will still work fine.

---

## STEP 3 — Create your account

1. Open your live Netlify URL
2. Click **Create account**, enter your email + a password (6+ characters)
3. Sign in — your dashboard loads

Your data now lives in Supabase under your account. Sign in from any device
(phone, laptop, new PC) with the same email/password and everything is there.

---

## STEP 4 — Install as an app (no browser needed)

### On your phone
- **Android (Chrome)**: open the site → tap the **⋮** menu → **"Add to Home
  screen"** / **"Install app"**. It now opens full-screen with its own icon,
  exactly like WhatsApp.
- **iPhone (Safari)**: open the site → tap **Share** → **"Add to Home
  Screen"**.

### On your PC
- **Chrome / Edge**: open the site → look for the **install icon (⊕)** in the
  address bar → click **Install**. It opens as its own desktop window/app,
  pinned to your taskbar/start menu — no browser tabs or address bar.

The app works offline for tasks/reminders you've already loaded (service
worker caching), and reconnects automatically for AI chat and sync.

---

## Your custom domain (optional)

If you own a domain (e.g. `kado.app` or similar):
Netlify → your site → **Domain management** → **Add a custom domain** →
follow the DNS instructions. Takes about 10–30 minutes to go live.

---

## Moving to a new phone or PC

Nothing to export/import — just open your installed app (or the URL) on the
new device and sign in with the same email/password. All your tasks,
expenses, reminders, and chat history are pulled from Supabase automatically.

---

## File structure

```
kado-secretary/
├── index.html              Everything: app, styling, and logic in one file
├── manifest.json           PWA config (app name, icons, colours)
├── sw.js                    Service worker (offline support)
├── netlify.toml             Netlify config + security headers
├── supabase-schema.sql      Run once in Supabase SQL editor
├── icons/
│   ├── icon-192.png
│   └── icon-512.png
└── netlify/functions/
    └── chat.js               Secure serverless proxy to Claude API
```

Everything is bundled into a single `index.html` (HTML + CSS + JavaScript) —
this avoids any broken-path issues when deploying via drag-and-drop.

---

## Troubleshooting: "page loads but unstyled / broken layout"

This almost always means a file (like a stylesheet) returned 404 because the
folder structure got nested one level too deep during upload (e.g. Netlify
created `/kado-secretary/index.html` instead of `/index.html`).

**Fix:** make sure when you drag files into Netlify, you drag the *contents*
of the `kado-secretary` folder (index.html, manifest.json, icons/, etc. all
visible at once) — not the folder itself, and not a zip file.

With the current version, this is much less likely since everything (HTML,
CSS, JS) is bundled into one `index.html` file — only `manifest.json`,
`sw.js`, and `icons/` are separate, and those degrade gracefully if missing.


---

## What's next (future phases)

- **Gmail integration** — read/reply to emails with AI drafts (needs Google
  OAuth setup — separate guide when ready)
- **Electron desktop app** — fully native Windows/Mac app, no browser at all
- **Smart home control** — once you get smart plugs/bulbs (Tuya-compatible)
- **WhatsApp/Telegram bot** — chat with your secretary from WhatsApp directly

Just say the word when you're ready for the next phase!
