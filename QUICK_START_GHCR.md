# Quick Start: GitHub Container Registry

## 🚀 5-Minute Setup

### Step 1: Push to GitHub (if not already done)

```bash
git add .
git commit -m "Add GitHub Container Registry integration"
git push origin master
```

### Step 2: Enable Workflow Permissions

1. Go to your repository on GitHub
2. Click **Settings** → **Actions** → **General**
3. Under **Workflow permissions**, select:
   - ✅ **Read and write permissions**
4. Click **Save**

### Step 3: That's it! 🎉

The workflow will automatically:
- ✅ Build your Docker image
- ✅ Push to `ghcr.io/YOUR_USERNAME/mysql-to-psql-proxy`
- ✅ Tag with version (auto-incrementing)
- ✅ Tag with `latest`
- ✅ Create a GitHub release

## 📦 Using Your Image

After the workflow completes (check the **Actions** tab):

```bash
# Pull the latest image
docker pull ghcr.io/YOUR_USERNAME/mysql-to-psql-proxy:latest

# Run it
docker run -d \
  --name mysql-psql-proxy \
  -p 5009:5009 \
  -v $(pwd)/data:/app/data \
  ghcr.io/YOUR_USERNAME/mysql-to-psql-proxy:latest
```

## 🏷️ Version Management

### Automatic (Recommended)
- Every push to `master` auto-increments the patch version
- `v0.1.0` → `v0.1.1` → `v0.1.2` → ...

### Manual Version Bump
Use the helper script:

```bash
# See current version
./version-helper.sh show

# Bump patch version (0.1.0 → 0.1.1)
./version-helper.sh bump patch

# Bump minor version (0.1.5 → 0.2.0)
./version-helper.sh bump minor

# Bump major version (0.2.0 → 1.0.0)
./version-helper.sh bump major

# Create specific version
./version-helper.sh create v2.0.0
```

### Using GitHub UI
1. Go to **Actions** tab
2. Click **Manual Version Tag** workflow
3. Click **Run workflow**
4. Select version bump type or enter custom version
5. Click **Run workflow**

## 🔍 Verify Deployment

Check if your image is available:

```bash
# Replace YOUR_USERNAME with your GitHub username
docker pull ghcr.io/YOUR_USERNAME/mysql-to-psql-proxy:latest
```

## 🐛 Troubleshooting

### "Permission denied" error
- Check workflow permissions in Settings → Actions → General
- Ensure "Read and write permissions" is selected

### "Image not found" error  
- Wait for the workflow to complete (check Actions tab)
- Make package public: Profile → Packages → Package Settings → Change visibility

### Workflow doesn't trigger
- Ensure you pushed to `master` or `main` branch
- Check if `.github/workflows/docker-publish.yml` exists in your repo

## 📚 More Information

See [GITHUB_CONTAINER_REGISTRY.md](./GITHUB_CONTAINER_REGISTRY.md) for detailed documentation.

## 🔐 Making Package Public

First build creates a private package. To make it public:

1. Go to your GitHub profile
2. Click **Packages**
3. Select your package
4. **Package settings** → **Change visibility** → **Public**

---

**Need help?** Check the workflow logs in the Actions tab for detailed error messages.

