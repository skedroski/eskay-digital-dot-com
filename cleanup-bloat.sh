#!/bin/bash

# Hugo Website Bloat Cleanup Script - Phase 1
# Safely removes unused assets, templates, and content
# Created: 2025-10-26
# Project: Eskay Digital Single-Page Site

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
PROJECT_DIR="/Users/stevekedroski/Desktop/projects/eskay-digital-dot-com"
BACKUP_DIR="/Users/stevekedroski/Desktop/projects"
BACKUP_NAME="eskay-backup-$(date +%Y%m%d-%H%M%S).tar.gz"
LOG_FILE="$PROJECT_DIR/cleanup-log-$(date +%Y%m%d-%H%M%S).txt"

# Initialize log
echo "=== Hugo Bloat Cleanup Log ===" > "$LOG_FILE"
echo "Started: $(date)" >> "$LOG_FILE"
echo "" >> "$LOG_FILE"

# Functions
print_header() {
    echo -e "\n${BLUE}========================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}========================================${NC}\n"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
    echo "✓ $1" >> "$LOG_FILE"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
    echo "⚠ $1" >> "$LOG_FILE"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
    echo "✗ $1" >> "$LOG_FILE"
}

print_info() {
    echo -e "${BLUE}ℹ $1${NC}"
    echo "ℹ $1" >> "$LOG_FILE"
}

calculate_size() {
    if [ -e "$1" ]; then
        du -sh "$1" 2>/dev/null | cut -f1
    else
        echo "0K"
    fi
}

# Main Script
clear
print_header "HUGO WEBSITE BLOAT CLEANUP - PHASE 1"

echo "This script will:"
echo "  1. Create a complete backup of your project"
echo "  2. Remove unused files and directories (3.9+ MB)"
echo "  3. Generate a detailed log of all changes"
echo ""
echo -e "${YELLOW}Backup will be saved to: $BACKUP_DIR/$BACKUP_NAME${NC}"
echo ""
read -p "Continue? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    print_error "Cleanup cancelled by user"
    exit 1
fi

# Change to project directory
cd "$PROJECT_DIR"

# ============================================
# STEP 1: CREATE BACKUP
# ============================================
print_header "STEP 1: Creating Backup"

print_info "Calculating current project size..."
INITIAL_SIZE=$(du -sh . 2>/dev/null | cut -f1)
print_info "Current project size: $INITIAL_SIZE"

print_info "Creating backup archive..."
if tar -czf "$BACKUP_DIR/$BACKUP_NAME" . 2>/dev/null; then
    BACKUP_SIZE=$(du -sh "$BACKUP_DIR/$BACKUP_NAME" | cut -f1)
    print_success "Backup created: $BACKUP_NAME ($BACKUP_SIZE)"
    echo "Backup location: $BACKUP_DIR/$BACKUP_NAME" >> "$LOG_FILE"
else
    print_error "Backup failed! Aborting cleanup."
    exit 1
fi

# ============================================
# STEP 2: REMOVE EXAMPLESITE DIRECTORY
# ============================================
print_header "STEP 2: Removing exampleSite Directory"

if [ -d "exampleSite" ]; then
    EXAMPLESITE_SIZE=$(calculate_size "exampleSite")
    print_info "exampleSite size: $EXAMPLESITE_SIZE"

    rm -rf exampleSite
    print_success "Removed exampleSite/ ($EXAMPLESITE_SIZE saved)"
else
    print_warning "exampleSite directory not found (may have been removed already)"
fi

# ============================================
# STEP 3: REMOVE GALLERY IMAGES
# ============================================
print_header "STEP 3: Removing Gallery Images"

if [ -d "assets/images/gallery" ]; then
    GALLERY_SIZE=$(calculate_size "assets/images/gallery")
    print_info "Gallery size: $GALLERY_SIZE"

    # List files being removed
    echo "Removing gallery images:" >> "$LOG_FILE"
    ls -lh assets/images/gallery/ >> "$LOG_FILE" 2>/dev/null

    rm -rf assets/images/gallery
    print_success "Removed gallery/ ($GALLERY_SIZE saved)"
else
    print_warning "Gallery directory not found"
fi

# ============================================
# STEP 4: REMOVE DUPLICATE LOGO FILES
# ============================================
print_header "STEP 4: Removing Duplicate Logo Files"

LOGO_REMOVED=0
LOGO_SIZE=0

# Remove logo.jpg
if [ -f "assets/images/logo.jpg" ]; then
    SIZE=$(calculate_size "assets/images/logo.jpg")
    rm assets/images/logo.jpg
    print_success "Removed logo.jpg ($SIZE)"
    LOGO_REMOVED=$((LOGO_REMOVED + 1))
fi

# Remove logo-darkmode.jpg
if [ -f "assets/images/logo-darkmode.jpg" ]; then
    SIZE=$(calculate_size "assets/images/logo-darkmode.jpg")
    rm assets/images/logo-darkmode.jpg
    print_success "Removed logo-darkmode.jpg ($SIZE)"
    LOGO_REMOVED=$((LOGO_REMOVED + 1))
fi

if [ $LOGO_REMOVED -eq 0 ]; then
    print_warning "No duplicate logo files found"
else
    print_success "Removed $LOGO_REMOVED duplicate logo file(s)"
fi

# ============================================
# STEP 5: REMOVE DEMO/PLACEHOLDER IMAGES
# ============================================
print_header "STEP 5: Removing Demo & Placeholder Images"

DEMO_IMAGES=(
    "assets/images/avatar.png"
    "assets/images/avatar-sm.png"
    "assets/images/banner.png"
    "assets/images/call-to-action.png"
    "assets/images/image-placeholder.png"
    "assets/images/no-search-found.png"
)

DEMO_REMOVED=0
for img in "${DEMO_IMAGES[@]}"; do
    if [ -f "$img" ]; then
        SIZE=$(calculate_size "$img")
        rm "$img"
        print_success "Removed $(basename $img) ($SIZE)"
        DEMO_REMOVED=$((DEMO_REMOVED + 1))
    fi
done

if [ $DEMO_REMOVED -eq 0 ]; then
    print_warning "No demo images found"
else
    print_success "Removed $DEMO_REMOVED demo image(s)"
fi

# ============================================
# STEP 6: REMOVE UNUSED PLUGINS
# ============================================
print_header "STEP 6: Removing Unused Plugins"

if [ -d "assets/plugins/maps" ]; then
    MAPS_SIZE=$(calculate_size "assets/plugins/maps")
    rm -rf assets/plugins/maps
    print_success "Removed Google Maps plugin ($MAPS_SIZE)"
else
    print_warning "Maps plugin not found"
fi

# ============================================
# STEP 7: REMOVE BLOG CONTENT
# ============================================
print_header "STEP 7: Removing Blog Content"

BLOG_DIRS=(
    "content/english/blog"
    "content/english/authors"
    "content/english/about"
    "content/english/contact"
    "content/english/pages"
)

BLOG_REMOVED=0
for dir in "${BLOG_DIRS[@]}"; do
    if [ -d "$dir" ]; then
        SIZE=$(calculate_size "$dir")

        # Log contents before removal
        echo "Removing: $dir" >> "$LOG_FILE"
        find "$dir" -type f >> "$LOG_FILE" 2>/dev/null

        rm -rf "$dir"
        print_success "Removed $(basename $dir)/ ($SIZE)"
        BLOG_REMOVED=$((BLOG_REMOVED + 1))
    fi
done

if [ $BLOG_REMOVED -eq 0 ]; then
    print_warning "No blog directories found"
else
    print_success "Removed $BLOG_REMOVED blog/content directory(ies)"
fi

# ============================================
# STEP 8: CALCULATE RESULTS
# ============================================
print_header "CLEANUP SUMMARY"

FINAL_SIZE=$(du -sh . 2>/dev/null | cut -f1)

print_info "Initial size: $INITIAL_SIZE"
print_info "Final size:   $FINAL_SIZE"
print_success "Backup saved: $BACKUP_DIR/$BACKUP_NAME"

echo "" >> "$LOG_FILE"
echo "=== Summary ===" >> "$LOG_FILE"
echo "Initial size: $INITIAL_SIZE" >> "$LOG_FILE"
echo "Final size: $FINAL_SIZE" >> "$LOG_FILE"
echo "Completed: $(date)" >> "$LOG_FILE"

# ============================================
# STEP 9: VERIFICATION
# ============================================
print_header "VERIFICATION"

print_info "Checking critical files still exist..."

CRITICAL_FILES=(
    "hugo.toml"
    "content/english/_index.md"
    "content/english/sections/call-to-action.md"
    "content/english/sections/testimonial.md"
    "layouts/index.html"
    "assets/images/logo.svg"
    "assets/images/logo-darkmode.svg"
    "assets/images/favicon.png"
    "data/theme.json"
)

ALL_GOOD=true
for file in "${CRITICAL_FILES[@]}"; do
    if [ -f "$file" ]; then
        echo -e "${GREEN}✓${NC} $file"
    else
        echo -e "${RED}✗${NC} $file ${RED}(MISSING!)${NC}"
        ALL_GOOD=false
    fi
done

echo ""
if [ "$ALL_GOOD" = true ]; then
    print_success "All critical files intact!"
else
    print_error "Some critical files are missing!"
    print_warning "Restore from backup: tar -xzf $BACKUP_DIR/$BACKUP_NAME"
    exit 1
fi

# ============================================
# STEP 10: NEXT STEPS
# ============================================
print_header "CLEANUP COMPLETE!"

echo -e "${GREEN}Phase 1 cleanup successful!${NC}\n"
echo "Next steps:"
echo "  1. Test your site: npm run dev"
echo "  2. Visit: http://localhost:1313"
echo "  3. Verify all sections work correctly"
echo "  4. Check cleanup log: $LOG_FILE"
echo ""
echo -e "${YELLOW}If anything is broken, restore from backup:${NC}"
echo -e "  cd $PROJECT_DIR"
echo -e "  tar -xzf $BACKUP_DIR/$BACKUP_NAME"
echo ""
echo -e "${BLUE}Ready for Phase 2?${NC}"
echo "  Run: ./cleanup-phase2.sh (coming next)"
echo ""

print_success "Log saved to: $LOG_FILE"
