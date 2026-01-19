<!-- Add this section to your main README.md -->

## 🐳 Docker Image

This project is automatically built and published to GitHub Container Registry.

### Quick Start with Docker

```bash
# Pull the latest image
docker pull ghcr.io/YOUR_USERNAME/mysql-to-psql-proxy:latest

# Run the container
docker run -d \
  --name mysql-psql-proxy \
  -p 5009:5009 \
  -v $(pwd)/data:/app/data \
  ghcr.io/YOUR_USERNAME/mysql-to-psql-proxy:latest
```

### Available Tags

- `latest` - Latest stable build from master branch
- `vX.Y.Z` - Specific version tags (e.g., `v0.1.5`)
- `master-<sha>` - Build from specific commit

### Multi-Platform Support

Images are available for:
- **linux/amd64** (Intel/AMD)
- **linux/arm64** (ARM, including Apple Silicon)

### More Information

- **Quick Setup Guide**: See [QUICK_START_GHCR.md](./QUICK_START_GHCR.md)
- **Full Documentation**: See [GITHUB_CONTAINER_REGISTRY.md](./GITHUB_CONTAINER_REGISTRY.md)
- **View Releases**: Check the [Releases](../../releases) page
- **Browse Packages**: Check the [Packages](../../packages) section

---

