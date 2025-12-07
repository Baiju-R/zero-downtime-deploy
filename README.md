# Zero-Downtime Deployment System (DevOps Mini Project)

A simple **DevOps-style deployment pipeline** that demonstrates how to:

- Containerize a Node.js application with Docker  
- Serve it behind **Nginx** as a reverse proxy  
- Version and push images to **Docker Hub**  
- Deploy new versions via a **Bash deploy script with health checks**  
- Automate image builds and pushes using **GitHub Actions CI/CD**

---

## 🚀 Tech Stack

- **Application**: Node.js + Express
- **Containerization**: Docker
- **Web Server / Reverse Proxy**: Nginx
- **Registry**: Docker Hub (`b41ju/zero-downtime-app`)
- **CI/CD**: GitHub Actions
- **Environment**: Ubuntu (WSL2 on Windows)

---

## 🧩 High-Level Architecture

1. **Node.js App**  
   - Simple Express server with:
     - `/` → returns app version
     - `/health` → used for health checks

2. **Docker Image**  
   - App is containerized with a `Dockerfile`
   - Images are tagged as `v1`, `v2`, or `build-*`
   - Pushed to Docker Hub: `b41ju/zero-downtime-app`

3. **Nginx Reverse Proxy**  
   - Listens on port `80`
   - Proxies traffic to the container on `localhost:3000`
   - Exposes `/health` endpoint via Nginx

4. **Deployment Script (`deploy.sh`)**  
   - Pulls the requested image tag from Docker Hub  
   - Stops/removes the old container (if any)  
   - Starts a new container with the given tag  
   - Waits a few seconds  
   - Hits `/health` via Nginx  
   - Marks deployment **successful only if health check passes**

5. **CI/CD (GitHub Actions)**  
   - On every push to `main`:
     - Checks out repo
     - Installs Node dependencies
     - Does a basic startup test
     - Builds Docker image
     - Pushes to Docker Hub with:
       - `build-<run-number>`
       - `latest` tag

---

## 📁 Project Structure

```text
zero-downtime-deploy/
├─ app/
│  ├─ server.js          # Express app (with / and /health routes)
│  ├─ package.json
│  ├─ package-lock.json
│  ├─ Dockerfile         # Node app Dockerfile
│  └─ node_modules/      # Dependencies (ignored in git)
├─ deploy.sh             # Deployment script (pull + run + health check)
└─ .github/
   └─ workflows/
      └─ ci-cd.yml       # GitHub Actions workflow (build & push to Docker Hub)
