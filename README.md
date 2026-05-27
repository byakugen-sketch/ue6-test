# ue6-test — UE5 Game Server DevOps

A UE5 Third Person template project with a full CI/CD pipeline: Jenkins builds the dedicated server, containerizes it with Docker, and deploys it to Kubernetes.

---

## Prerequisites

- Unreal Engine 5.5 (via Epic Games Launcher)
- Linux cross-compilation toolchain v22 (see setup below)
- Docker Desktop
- Minikube
- Git LFS (`brew install git-lfs && git lfs install`)

---

## First-Time Setup

### 1. Install the Linux cross-compilation toolchain
Download **Toolchain v22** from Epic's developer portal:
https://dev.epicgames.com/documentation/en-us/unreal-engine/linux-development-requirements-for-unreal-engine

```bash
./Scripts/setup-toolchain.sh /path/to/UnrealToolchain-5.5-v22-*.tar.gz
source ~/.zshrc
```

### 2. Clone and set up LFS
```bash
git clone git@github.com:byakugen-sketch/ue6-test.git
cd ue6-test
git lfs pull
```

---

## Building

### Package the dedicated server
```bash
./Scripts/build-server.sh
```
Runs `RunUAT BuildCookRun` targeting Linux. Output goes to `Output/LinuxServer/`. Takes 30-90 minutes on first run (incremental builds are much faster).

### Build the Docker image
```bash
./Scripts/build-docker.sh latest
```
Packages the staged server into an `ubuntu:22.04` container image targeting `linux/amd64`.

---

## Deploying to Minikube

```bash
minikube start --driver=docker
kubectl apply -f docker/k8s/deployment.yaml
kubectl apply -f docker/k8s/service.yaml
kubectl get pods -w
```

---

## CI/CD Pipeline (Jenkins)

The `Jenkinsfile` defines five stages:

| Stage | What it does |
|-------|-------------|
| Checkout | Pulls latest code from GitHub |
| Build Server | Runs `RunUAT` to package the dedicated server for Linux |
| Build Image | Builds the Docker image from the staged artifact |
| Push | Pushes the image to Docker Hub |
| Deploy | Updates the Kubernetes deployment with the new image |

---

## Architecture

```
UE5 Editor (Mac)
      │
      ▼
RunUAT BuildCookRun (cross-compile to Linux)
      │
      ▼
LinuxServer/ (staged artifact)
      │
      ▼
Docker Image (ubuntu:22.04, linux/amd64)
      │
      ▼
Docker Hub (uzumaki420/ue5-gameserver)
      │
      ▼
Kubernetes (Minikube) — game server pod
      │ UDP:7777
      ▼
Players connect via NodePort
```

---

## Key Notes

- **Git LFS** is required — all `.uasset` and `.umap` files are stored via LFS
- **Build times**: first cook ~60-90 min, incremental ~10-20 min
- **Image size**: expect 2-5 GB for this project
- **UDP port 7777** is the game traffic port — standard UE5 default
- `Output/` and `docker/LinuxServer/` are gitignored (CI artifacts)
