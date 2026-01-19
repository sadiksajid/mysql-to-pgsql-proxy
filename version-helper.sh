#!/bin/bash
# Version Helper Script for MySQL to PostgreSQL Proxy

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

# Function to get the latest version tag
get_latest_version() {
    local latest_tag=$(git tag -l "v*" | sort -V | tail -n 1)
    if [ -z "$latest_tag" ]; then
        echo "v0.0.0"
    else
        echo "$latest_tag"
    fi
}

# Function to show current version
show_version() {
    local current_version=$(get_latest_version)
    print_info "Current version: ${GREEN}$current_version${NC}"
    
    # Show version from Cargo.toml
    if [ -f "Cargo.toml" ]; then
        local cargo_version=$(grep -E '^version\s*=' Cargo.toml | head -1 | sed -E 's/version\s*=\s*"([^"]+)"/\1/')
        print_info "Cargo.toml version: ${YELLOW}v$cargo_version${NC}"
    fi
}

# Function to show all tags
show_all_tags() {
    print_info "All version tags:"
    git tag -l "v*" | sort -V | while read tag; do
        local commit=$(git rev-list -n 1 "$tag")
        local date=$(git log -1 --format=%ai "$commit" | cut -d' ' -f1)
        echo "  $tag - $date"
    done
}

# Function to calculate next version
calc_next_version() {
    local bump_type=$1
    local current_version=$(get_latest_version)
    local version=${current_version#v}
    
    IFS='.' read -r major minor patch <<< "$version"
    
    case "$bump_type" in
        major)
            major=$((major + 1))
            minor=0
            patch=0
            ;;
        minor)
            minor=$((minor + 1))
            patch=0
            ;;
        patch)
            patch=$((patch + 1))
            ;;
        *)
            print_error "Invalid bump type: $bump_type"
            exit 1
            ;;
    esac
    
    echo "v${major}.${minor}.${patch}"
}

# Function to create a new tag
create_tag() {
    local new_version=$1
    local message=${2:-"Release $new_version"}
    
    # Check if tag already exists
    if git rev-parse "$new_version" >/dev/null 2>&1; then
        print_error "Tag $new_version already exists"
        exit 1
    fi
    
    print_info "Creating tag: $new_version"
    git tag -a "$new_version" -m "$message"
    print_success "Tag created locally"
    
    read -p "Push tag to remote? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        git push origin "$new_version"
        print_success "Tag pushed to remote"
        print_warning "This will trigger the Docker build workflow on GitHub Actions"
    fi
}

# Function to show Docker image info
show_docker_info() {
    print_info "Docker image information:"
    
    # Get repository name from git
    local repo_url=$(git config --get remote.origin.url)
    local repo_name=$(basename -s .git "$repo_url")
    local user_name=$(basename $(dirname "$repo_url"))
    
    if [[ "$user_name" == *":"* ]]; then
        user_name=$(echo "$user_name" | cut -d':' -f2)
    fi
    
    local current_version=$(get_latest_version)
    
    echo ""
    echo "  Image name: ${GREEN}ghcr.io/${user_name}/${repo_name}${NC}"
    echo ""
    echo "  Pull commands:"
    echo "    ${YELLOW}docker pull ghcr.io/${user_name}/${repo_name}:latest${NC}"
    echo "    ${YELLOW}docker pull ghcr.io/${user_name}/${repo_name}:${current_version}${NC}"
}

# Function to show usage
show_usage() {
    cat << EOF
${GREEN}Version Helper Script${NC}

Usage: $0 [command] [options]

Commands:
    show                Show current version
    list                List all version tags
    next [type]         Calculate next version (type: major, minor, patch)
    create [version]    Create a new version tag
    bump [type]         Bump version and create tag (type: major, minor, patch)
    docker              Show Docker image information
    help                Show this help message

Examples:
    $0 show                     # Show current version
    $0 next patch               # Show what the next patch version would be
    $0 bump minor               # Bump minor version and create tag
    $0 create v1.2.3            # Create specific version tag
    $0 docker                   # Show Docker pull commands

EOF
}

# Main script logic
case "${1:-show}" in
    show)
        show_version
        ;;
    list)
        show_all_tags
        ;;
    next)
        if [ -z "$2" ]; then
            print_error "Please specify version type: major, minor, or patch"
            exit 1
        fi
        next_version=$(calc_next_version "$2")
        print_info "Next $2 version would be: ${GREEN}$next_version${NC}"
        ;;
    create)
        if [ -z "$2" ]; then
            print_error "Please specify version to create (e.g., v1.2.3)"
            exit 1
        fi
        if [[ ! "$2" =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
            print_error "Version must be in format vX.Y.Z (e.g., v1.2.3)"
            exit 1
        fi
        create_tag "$2"
        ;;
    bump)
        if [ -z "$2" ]; then
            print_error "Please specify bump type: major, minor, or patch"
            exit 1
        fi
        next_version=$(calc_next_version "$2")
        current_version=$(get_latest_version)
        print_info "Bumping version from ${YELLOW}$current_version${NC} to ${GREEN}$next_version${NC}"
        create_tag "$next_version" "Release $next_version - $2 version bump"
        ;;
    docker)
        show_docker_info
        ;;
    help|--help|-h)
        show_usage
        ;;
    *)
        print_error "Unknown command: $1"
        echo ""
        show_usage
        exit 1
        ;;
esac

