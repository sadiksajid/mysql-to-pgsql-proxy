# GitHub Container Registry Setup

This document explains how to use the GitHub Container Registry (GHCR) integration for this project.

## Overview

The project is configured to automatically build and push Docker images to GitHub Container Registry (ghcr.io) on every push to the `master` branch.

## Automatic Versioning

Every push to `master` will:
1. **Auto-increment the patch version** (e.g., v0.1.0 → v0.1.1 → v0.1.2)
2. **Create a Git tag** with the new version
3. **Push Docker images** with multiple tags:
   - `latest` - Always points to the most recent build
   - `vX.Y.Z` - Specific version tag (e.g., v0.1.5)
   - `master-<sha>` - Branch name with commit SHA

## First-Time Setup

### 1. Enable GitHub Container Registry

1. Go to your GitHub repository
2. Navigate to **Settings** → **Actions** → **General**
3. Scroll down to **Workflow permissions**
4. Select **"Read and write permissions"**
5. Check **"Allow GitHub Actions to create and approve pull requests"**
6. Click **Save**

### 2. Make Package Public (Optional but Recommended)

After the first successful build:
1. Go to your GitHub profile
2. Click on **Packages**
3. Find your package (mysql-to-psql-proxy)
4. Click on **Package settings**
5. Scroll down to **Danger Zone**
6. Click **Change visibility** → **Public**

### 3. Create Initial Tag (Optional)

If you want to start from a specific version:

```bash
git tag v0.1.0
git push origin v0.1.0
```

If you don't create an initial tag, the workflow will start from v0.0.1.

## Usage

### Pulling the Image

```bash
# Pull the latest version
docker pull ghcr.io/YOUR_USERNAME/mysql-to-psql-proxy:latest

# Pull a specific version
docker pull ghcr.io/YOUR_USERNAME/mysql-to-psql-proxy:v0.1.5
```

### Running the Container

```bash
docker run -d \
  --name mysql-psql-proxy \
  -p 5009:5009 \
  -v $(pwd)/data:/app/data \
  ghcr.io/YOUR_USERNAME/mysql-to-psql-proxy:latest
```

### Using with Docker Compose

Update your `docker-compose.yml`:

```yaml
version: '3.8'
services:
  mysql-psql-proxy:
    image: ghcr.io/YOUR_USERNAME/mysql-to-psql-proxy:latest
    ports:
      - "5009:5009"
    volumes:
      - ./data:/app/data
    environment:
      - DATABASE_URL=your_database_url
```

## Versioning Strategy

The project uses **semantic versioning** (SemVer):
- **Major.Minor.Patch** (e.g., v1.2.3)

Currently, the workflow auto-increments the **patch** version on every push to master.

### Manual Version Bumps

If you need to manually bump the major or minor version:

```bash
# For minor version bump (e.g., v0.1.5 → v0.2.0)
git tag v0.2.0
git push origin v0.2.0

# For major version bump (e.g., v0.2.0 → v1.0.0)
git tag v1.0.0
git push origin v1.0.0
```

The next automatic build will continue from your manually set version.

## Workflow Details

The GitHub Actions workflow (`.github/workflows/docker-publish.yml`) performs these steps:

1. **Checkout code** - Gets the latest code and full git history
2. **Calculate version** - Determines the next version number
3. **Build image** - Builds for multiple platforms (amd64, arm64)
4. **Push to GHCR** - Pushes with multiple tags
5. **Create Git tag** - Tags the commit with the new version
6. **Create release** - Creates a GitHub release with pull instructions

## Multi-Platform Support

Images are built for:
- `linux/amd64` (Intel/AMD processors)
- `linux/arm64` (ARM processors, including Apple Silicon M1/M2)

Docker will automatically pull the correct image for your platform.

## Caching

The workflow uses GitHub Actions cache to speed up builds:
- Dependencies are cached between builds
- Rust compilation artifacts are reused when possible

## Authentication

To pull private images, authenticate with GitHub:

```bash
# Login to GHCR
echo $GITHUB_TOKEN | docker login ghcr.io -u YOUR_USERNAME --password-stdin

# Or use a Personal Access Token (PAT)
echo $YOUR_PAT | docker login ghcr.io -u YOUR_USERNAME --password-stdin
```

### Creating a Personal Access Token

1. Go to GitHub **Settings** → **Developer settings** → **Personal access tokens** → **Tokens (classic)**
2. Click **Generate new token (classic)**
3. Select scopes:
   - `read:packages` - To pull images
   - `write:packages` - To push images (if needed)
4. Generate and save the token securely

## Troubleshooting

### Workflow Fails on First Run

**Issue**: Permission denied when pushing tags or creating releases.

**Solution**: 
- Check workflow permissions in repository settings
- Ensure "Read and write permissions" is enabled

### Image Not Found

**Issue**: `Error: manifest unknown`

**Solution**:
- Check if the workflow completed successfully
- Verify the image name matches your repository
- Ensure the package visibility is set correctly

### Version Conflicts

**Issue**: Tag already exists error

**Solution**:
```bash
# Delete the problematic tag locally and remotely
git tag -d v0.1.5
git push origin :refs/tags/v0.1.5

# Re-run the workflow
```

## Best Practices

1. **Always push to master through PRs** - Review changes before triggering builds
2. **Monitor workflow runs** - Check the Actions tab for build status
3. **Use specific version tags in production** - Don't rely on `latest` in production
4. **Keep tags clean** - Don't manually create tags that conflict with auto-versioning
5. **Review releases** - Check the releases page after each build

## Security Notes

- The `GITHUB_TOKEN` is automatically provided by GitHub Actions
- No secrets need to be manually configured for basic functionality
- Images are public by default - don't include sensitive data in the image
- Use multi-stage builds to minimize attack surface (already implemented)

## Monitoring Builds

Check build status:
1. Go to your repository on GitHub
2. Click on **Actions** tab
3. View the latest workflow runs
4. Click on a run to see detailed logs

## Additional Resources

- [GitHub Container Registry Documentation](https://docs.github.com/packages/working-with-a-github-packages-registry/working-with-the-container-registry)
- [GitHub Actions Documentation](https://docs.github.com/actions)
- [Docker BuildKit Documentation](https://docs.docker.com/build/buildkit/)

