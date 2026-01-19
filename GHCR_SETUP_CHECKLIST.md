# 📝 GitHub Container Registry Setup Checklist

Use this checklist to ensure everything is configured correctly.

## Pre-Push Checklist

- [ ] All files have been reviewed and look correct
- [ ] `.github/workflows/docker-publish.yml` exists
- [ ] `.github/workflows/version-tag.yml` exists
- [ ] `.dockerignore` is configured
- [ ] `version-helper.sh` is executable (`chmod +x`)

## Git Operations

- [ ] Add all new files to git
  ```bash
  git add .
  ```

- [ ] Commit the changes
  ```bash
  git commit -m "Add GitHub Container Registry integration with auto-versioning"
  ```

- [ ] Push to master/main branch
  ```bash
  git push origin master
  ```

## GitHub Repository Configuration

- [ ] Go to your repository on GitHub
- [ ] Navigate to: **Settings** → **Actions** → **General**
- [ ] Under **Workflow permissions**:
  - [ ] Select "Read and write permissions"
  - [ ] Check "Allow GitHub Actions to create and approve pull requests"
- [ ] Click **Save**

## Verify First Build

- [ ] Go to **Actions** tab in your repository
- [ ] Workflow "Build and Push Docker Image to GHCR" should be running
- [ ] Wait for workflow to complete successfully (green checkmark)
- [ ] Check for any errors in workflow logs

## Verify Release

- [ ] Go to **Releases** page in your repository
- [ ] New release should appear (e.g., `v0.0.1`)
- [ ] Release should contain:
  - [ ] Version tag
  - [ ] Docker pull commands in description
  - [ ] Commit information

## Verify Package

- [ ] Go to your GitHub profile
- [ ] Click on **Packages** tab
- [ ] Package `mysql-to-psql-proxy` should appear
- [ ] Click on the package to see details

## Make Package Public (Optional)

- [ ] In the package view, click **Package settings**
- [ ] Scroll to **Danger Zone**
- [ ] Click **Change visibility** → **Public**
- [ ] Confirm the change

## Test Docker Pull

- [ ] Open terminal
- [ ] Run (replace `YOUR_USERNAME`):
  ```bash
  docker pull ghcr.io/YOUR_USERNAME/mysql-to-psql-proxy:latest
  ```
- [ ] Pull should succeed without errors
- [ ] Image should download successfully

## Test Docker Run

- [ ] Run the container:
  ```bash
  docker run -d \
    --name mysql-psql-proxy-test \
    -p 5009:5009 \
    -v $(pwd)/data:/app/data \
    ghcr.io/YOUR_USERNAME/mysql-to-psql-proxy:latest
  ```
- [ ] Container should start successfully
- [ ] Check container logs:
  ```bash
  docker logs mysql-psql-proxy-test
  ```
- [ ] Test the web UI:
  ```bash
  curl http://localhost:5009
  ```
- [ ] Clean up:
  ```bash
  docker stop mysql-psql-proxy-test
  docker rm mysql-psql-proxy-test
  ```

## Test Version Helper Script

- [ ] Check current version:
  ```bash
  ./version-helper.sh show
  ```
- [ ] List all tags:
  ```bash
  ./version-helper.sh list
  ```
- [ ] Show Docker info:
  ```bash
  ./version-helper.sh docker
  ```

## Test Manual Version Workflow (Optional)

- [ ] Go to **Actions** tab
- [ ] Click on **Manual Version Tag** workflow
- [ ] Click **Run workflow**
- [ ] Select a version bump type (e.g., "patch")
- [ ] Click **Run workflow** button
- [ ] Workflow should complete successfully
- [ ] New tag should appear
- [ ] Docker build workflow should be triggered

## Verify Multi-Platform Build

- [ ] Check workflow logs in Actions tab
- [ ] Look for "Build and push Docker image" step
- [ ] Should show builds for:
  - [ ] `linux/amd64`
  - [ ] `linux/arm64`

## Documentation Review

- [ ] Read `QUICK_START_GHCR.md` - ensure it's clear
- [ ] Read `GITHUB_CONTAINER_REGISTRY.md` - comprehensive guide
- [ ] Read `SETUP_COMPLETE.md` - post-setup guide
- [ ] Consider adding content from `README_GHCR_SECTION.md` to main README

## Post-Setup Tasks

- [ ] Update main `README.md` with Docker instructions
- [ ] Share Docker image URL with team
- [ ] Update deployment scripts to use ghcr.io image
- [ ] Update `docker-compose.yml` if needed
- [ ] Add badge to README (optional):
  ```markdown
  ![Docker Image](https://ghcr-badge.egpl.dev/YOUR_USERNAME/mysql-to-psql-proxy/latest_tag?label=ghcr.io)
  ```

## Ongoing Operations

- [ ] Monitor Actions tab for build failures
- [ ] Review releases page after each push
- [ ] Use semantic versioning for major/minor updates
- [ ] Keep track of deployed versions in production
- [ ] Update documentation as needed

## Troubleshooting Checklist

If something goes wrong:

- [ ] Check Actions tab for error logs
- [ ] Verify workflow permissions are set correctly
- [ ] Ensure GitHub token has necessary scopes
- [ ] Check if package visibility is correct
- [ ] Verify Docker credentials if pulling fails
- [ ] Check git tags for duplicates
- [ ] Review `.dockerignore` for missing files
- [ ] Verify Dockerfile builds locally first

## Success Criteria

You'll know the setup is complete when:

- ✅ Workflow runs successfully on push to master
- ✅ New version tag is created automatically
- ✅ GitHub release is published
- ✅ Docker image is available on ghcr.io
- ✅ You can pull and run the image
- ✅ Version helper script works correctly
- ✅ Manual version workflow is available

---

## Quick Reference Commands

```bash
# Show current version
./version-helper.sh show

# Pull latest image (replace YOUR_USERNAME)
docker pull ghcr.io/YOUR_USERNAME/mysql-to-psql-proxy:latest

# Run container
docker run -d --name mysql-psql-proxy -p 5009:5009 \
  ghcr.io/YOUR_USERNAME/mysql-to-psql-proxy:latest

# Check workflow status
# Go to: https://github.com/YOUR_USERNAME/mysql-to-psql-proxy/actions

# View packages
# Go to: https://github.com/YOUR_USERNAME?tab=packages

# View releases
# Go to: https://github.com/YOUR_USERNAME/mysql-to-psql-proxy/releases
```

---

**Completed Date**: _______________

**Completed By**: _______________

**Notes**: _______________________________________________

