
# 🐄 LivestockCRM — Mobile-First Livestock Management System

A modern, mobile-first **Livestock CRM** built with **Next.js 15**, **Supabase (PostgreSQL)**, **Tailwind CSS v4**, and **shadcn/ui**. Manage your herd with ease — track animals, breeding events, wellness records, yield analytics, genealogy trees, and growth measurements — all from your phone or desktop.

---

## 📸 Features

- 🔐 **Authentication** — Email/password sign-up & login via Supabase Auth
- 🐮 **Animal Records** — Multi-species support (cattle, sheep, goats, pigs, etc.) with tag numbers, photos, and full profiles
- 📊 **Dashboard** — Herd overview stats, recent activity, wellness alerts, and yield charts
- 🌱 **Breeding Management** — Track breeding events, pregnancy checks, calving dates, and outcomes
- 💉 **Wellness Tracking** — Vaccination, treatment, and health check records with severity levels
- 📈 **Yield Analytics** — Milk/product yield records with fat %, protein %, and quality grades
- 🌳 **Genealogy Tree** — Visual sire/dam lineage tracking per animal
- 📏 **Measurements & Growth** — Weight, height, girth, body condition score, and ADG charts
- 🌐 **Bilingual UI** — Toggle between **English** and **Spanish** at any time
- 🌙 **Dark / Light Mode** — Follows system preference with manual override
- 📱 **Mobile-First Design** — Optimized for mobile with bottom navigation and responsive layouts

---

## 🛠 Tech Stack

| Layer | Technology |
|---|---|
| Framework | [Next.js 15](https://nextjs.org) (App Router) |
| Language | TypeScript |
| Styling | [Tailwind CSS v4](https://tailwindcss.com) |
| UI Components | [shadcn/ui](https://ui.shadcn.com) + [Radix UI](https://radix-ui.com) |
| Icons | [Lucide React](https://lucide.dev) |
| Animations | [Framer Motion](https://www.framer.com/motion/) |
| Charts | [Recharts](https://recharts.org) |
| Database | [Supabase](https://supabase.com) (PostgreSQL) |
| Auth | Supabase Auth (email/password) |
| State | React Context + Zustand |
| Forms | React Hook Form + Zod |
| Package Manager | [pnpm](https://pnpm.io) |
| Deployment | [Vercel](https://vercel.com) |

---

## 🚀 Getting Started

### Prerequisites

- [Node.js](https://nodejs.org) >= 18
- [pnpm](https://pnpm.io) >= 8
- A [Supabase](https://supabase.com) project

### 1. Clone the Repository

```bash
git clone https://github.com/YOUR_USERNAME/livestock-crm.git
cd livestock-crm
```

### 2. Install Dependencies

```bash
pnpm install
```

### 3. Configure Environment Variables

Create a `.env.local` file in the project root:

```env
NEXT_PUBLIC_SUPABASE_URL=your_supabase_project_url
NEXT_PUBLIC_SUPABASE_ANON_KEY=your_supabase_anon_key
SUPABASE_SERVICE_ROLE_KEY=your_supabase_service_role_key
```

> ⚠️ Never commit `.env.local` to version control. It is already listed in `.gitignore`.

### 4. Set Up the Database

Run the SQL schema in your Supabase SQL editor. The schema creates the following tables:

- `profiles` — User profile data
- `user_roles` — Role-based access control
- `animals` — Core animal records
- `breeding_events` — Breeding and calving records
- `wellness_records` — Health and treatment records
- `yield_records` — Milk/product yield data
- `measurements` — Growth and body measurements
- `genealogy` — Sire/dam lineage records

### 5. Run the Development Server

```bash
pnpm dev
```

Open [http://localhost:3000](http://localhost:3000) in your browser.

---

## 📁 Project Structure

```
livestock-crm/
├── src/
│   ├── app/                    # Next.js App Router pages
│   │   ├── animals/            # Animal list & detail pages
│   │   ├── breeding/           # Breeding management page
│   │   ├── dashboard/          # Main dashboard page
│   │   ├── genealogy/          # Genealogy tree page
│   │   ├── measurements/       # Growth measurements page
│   │   ├── wellness/           # Wellness records page
│   │   ├── yields/             # Yield analytics page
│   │   ├── api/                # API routes
│   │   ├── globals.css         # Global styles (Tailwind v4)
│   │   └── layout.tsx          # Root layout
│   ├── components/
│   │   ├── ui/                 # shadcn/ui base components
│   │   ├── animals/            # Animal-specific components
│   │   ├── breeding/           # Breeding components
│   │   ├── dashboard/          # Dashboard widgets
│   │   ├── genealogy/          # Genealogy tree components
│   │   ├── layout/             # App layout (header, sidebar, nav)
│   │   ├── livestock/          # Core livestock app components
│   │   ├── measurements/       # Measurement & chart components
│   │   ├── shared/             # Reusable shared components
│   │   ├── wellness/           # Wellness record components
│   │   └── yields/             # Yield analytics components
│   ├── context/                # React Context providers
│   ├── data/                   # Static mock data (JSON/TS)
│   ├── hooks/                  # Custom React hooks
│   ├── integrations/
│   │   └── supabase/           # Supabase client, server, types
│   ├── lib/                    # Utility functions
│   ├── store/                  # Zustand global state stores
│   └── types/                  # TypeScript type definitions
├── .gitignore
├── components.json             # shadcn/ui config
├── next.config.ts              # Next.js configuration
├── postcss.config.mjs          # PostCSS / Tailwind config
├── tsconfig.json               # TypeScript config
└── vercel.json                 # Vercel deployment config
```

---

## 🌐 Deployment on Vercel

This project is pre-configured for Vercel deployment via `vercel.json`.

### Deploy with Vercel CLI

```bash
pnpm add -g vercel
vercel login
vercel --prod
```

### Deploy via Vercel Dashboard

1. Push your code to GitHub
2. Go to [vercel.com/new](https://vercel.com/new)
3. Import your GitHub repository
4. Add the required environment variables:
   - `NEXT_PUBLIC_SUPABASE_URL`
   - `NEXT_PUBLIC_SUPABASE_ANON_KEY`
   - `SUPABASE_SERVICE_ROLE_KEY`
5. Click **Deploy**

---

## 🔧 Available Scripts

| Command | Description |
|---|---|
| `pnpm dev` | Start development server with Turbopack |
| `pnpm build` | Build for production |
| `pnpm start` | Start production server on port 3000 |
| `pnpm lint` | Run ESLint |

---

## 🌍 Internationalization

The app supports **English** and **Spanish** via a language toggle button in the UI. The language context is managed through `src/context/LanguageContext.tsx`.

To add a new language:
1. Add translations to the language context
2. Update the toggle button in `src/components/livestock/LanguageToggle.tsx`

---

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/your-feature-name`
3. Commit your changes: `git commit -m "feat: add your feature"`
4. Push to the branch: `git push origin feature/your-feature-name`
5. Open a Pull Request

Please follow the [Conventional Commits](https://www.conventionalcommits.org/) specification for commit messages.

---

## 📄 License

This project is licensed under the **MIT License**. See the [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgements

- [Next.js](https://nextjs.org) — The React framework for production
- [Supabase](https://supabase.com) — Open source Firebase alternative
- [shadcn/ui](https://ui.shadcn.com) — Beautifully designed components
- [Tailwind CSS](https://tailwindcss.com) — Utility-first CSS framework
- [Vercel](https://vercel.com) — Deployment platform

---

> Built with ❤️ for farmers and ranchers who deserve modern tools.
