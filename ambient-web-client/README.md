
# Ambient Recording Web Client (Demo)

A lightweight React + TypeScript web client that mirrors the basic workflow of the **AmbientRecordingApp** iOS prototype.

## Features

- List today's appointments with patient name & time
- Drill‑in to an appointment, display details & simple mic UI
- Record audio in‑browser via **MediaRecorder API** and upload using `/v1/recordings/create`
- Create / update / delete appointments through REST endpoints
- Axios abstraction with automatic status‑code handling
- Vite dev server – hot‑reload in ~50 ms

> ⚠️  This is demo‑ware – it favours clarity & traceability over production hardening (no auth, no retry queue, etc.).

## Quick start

```bash
git clone <repo-url>
cd ambient-web-client
cp .env.example .env       # point API base URL
npm install
npm run dev               # open http://localhost:5173
```

### `.env.example`

```
VITE_API_BASE=https://api.host.domain
```

## Project layout

```
ambient-web-client/
├── src/
│   ├── api/              # thin endpoint wrappers
│   ├── components/       # dumb UI widgets
│   ├── pages/            # route-level screens
│   ├── types/            # shared TS interfaces
│   ├── main.tsx          # router bootstrap
│   └── index.css         # Tailwind entry
├── index.html
└── ...
```

## Next steps

* Persist unsent recordings in IndexedDB for offline support  
* Hook up real user auth (e.g. OAuth PKCE) and send JWT in `Authorization` header  
* Add optimistic UI & background sync queue for mobile‑web reliability  
* Unit tests with Jest + React Testing Library  
* Cypress e2e covering full appointment ➜ record flow  

Made with ❤️ by an expert demo‑ware builder – feel free to tweak!
