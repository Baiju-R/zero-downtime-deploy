// app/server.js
const express = require("express");
const app = express();

const PORT = process.env.PORT || 3000;
const VERSION = process.env.APP_VERSION || "v1";

app.get("/", (req, res) => {
  res.send(`🚀 Zero-Downtime App - Version: ${VERSION} — Now running v2!`);
});

app.get("/health", (req, res) => {
  res.status(200).json({ status: "ok", version: VERSION });
});

app.listen(PORT, () => {
  console.log(`App running on port ${PORT} (version: ${VERSION})`);
});

