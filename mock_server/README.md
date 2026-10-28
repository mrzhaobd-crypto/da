# NoteQuiz local mock server

Based on the course template, json-server 0.17.4. Run `npm ci` then `npm start`.
- Binds 127.0.0.1:3000.
- GET /topics, /questions, /results from db.json.
- GET / serves ../build/web if Flutter has built it.
- Writes are rejected with HTTP 405, including POST, PUT, PATCH and DELETE.
- No real user input or results are stored.
- api/server.js and vercel.json are retained from the template for reference; no deployment was performed. Local execution uses server.cjs.

The app's `DEMO_STATE` build switch allows loading/error/empty demonstrations. For a real retry, stop and restart the local server while using the normal app build.
