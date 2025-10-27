#!/bin/bash

# Hugo Website Bloat Cleanup Script - Phase 2
# Removes unused layout templates
# Run this AFTER Phase 1 and testing
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
BACKUP_NAME="eskay-phase2-backup-$(date +%Y%m%d-%H%M%S).tar.gz"
LOG_FILE="$PROJECT_DIR/cleanup-phase2-log-$(date +%Y%m%d-%H%M%S).txt"

# Initialize log
echo "=== Hugo Bloat Cleanup Phase 2 Log ===" > "$LOG_FILE"
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

# Main Script
clear
print_header "HUGO WEBSITE BLOAT CLEANUP - PHASE 2"
print_warning "TEMPLATE CLEANUP - More Advanced"

echo "This script will:"
echo "  1. Create a backup before making changes"
echo "  2. Remove unused layout templates"
echo "  3. Simplify your site structure"
echo ""
echo -e "${YELLOW}IMPORTANT: Only run this after:${NC}"
echo "  - Phase 1 completed successfully"
echo "  - You tested your site with: npm run dev"
echo "  - Everything works correctly"
echo ""
echo -e "${YELLOW}Backup will be saved to: $BACKUP_DIR/$BACKUP_NAME${NC}"
echo ""
read -p "Have you tested Phase 1 successfully? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    print_error "Please test Phase 1 first, then run this script"
    exit 1
fi

# Change to project directory
cd "$PROJECT_DIR"

# ============================================
# STEP 1: CREATE BACKUP
# ============================================
print_header "STEP 1: Creating Backup"

print_info "Creating Phase 2 backup..."
if tar -czf "$BACKUP_DIR/$BACKUP_NAME" . 2>/dev/null; then
    BACKUP_SIZE=$(du -sh "$BACKUP_DIR/$BACKUP_NAME" | cut -f1)
    print_success "Backup created: $BACKUP_NAME ($BACKUP_SIZE)"
else
    print_error "Backup failed! Aborting cleanup."
    exit 1
fi

# ============================================
# STEP 2: REMOVE UNUSED _DEFAULT LAYOUTS
# ============================================
print_header "STEP 2: Removing Unused Default Layouts"

DEFAULT_LAYOUTS=(
    "layouts/_default/list.html"
    "layouts/_default/single.html"
    "layouts/_default/taxonomy.html"
    "layouts/_default/terms.html"
)

REMOVED=0
for layout in "${DEFAULT_LAYOUTS[@]}"; do
    if [ -f "$layout" ]; then
        echo "Removing: $layout" >> "$LOG_FILE"
        rm "$layout"
        print_success "Removed $(basename $layout)"
        REMOVED=$((REMOVED + 1))
    fi
done

print_info "Removed $REMOVED default layout(s)"

# ============================================
# STEP 3: REMOVE SECTION LAYOUTS
# ============================================
print_header "STEP 3: Removing Unused Section Layouts"

SECTION_DIRS=(
    "layouts/about"
    "layouts/authors"
    "layouts/blog"
    "layouts/contact"
)

for dir in "${SECTION_DIRS[@]}"; do
    if [ -d "$dir" ]; then
        echo "Removing directory: $dir" >> "$LOG_FILE"
        ls -la "$dir" >> "$LOG_FILE" 2>/dev/null
        rm -rf "$dir"
        print_success "Removed $(basename $dir)/"
    fi
done

# ============================================
# STEP 4: REMOVE UNUSED PARTIALS
# ============================================
print_header "STEP 4: Removing Unused Partial Templates"

UNUSED_PARTIALS=(
    "layouts/partials/page-header.html"
    "layouts/partials/components/author-card.html"
    "layouts/partials/components/blog-card.html"
    "layouts/partials/components/breadcrumb.html"
    "layouts/partials/widgets/categories.html"
    "layouts/partials/widgets/tags.html"
)

REMOVED=0
for partial in "${UNUSED_PARTIALS[@]}"; do
    if [ -f "$partial" ]; then
        echo "Removing: $partial" >> "$LOG_FILE"
        rm "$partial"
        print_success "Removed $(basename $partial)"
        REMOVED=$((REMOVED + 1))
    fi
done

print_info "Removed $REMOVED partial template(s)"

# ============================================
# STEP 5: VERIFY ESSENTIAL LAYOUTS
# ============================================
print_header "STEP 5: Verifying Essential Layouts"

ESSENTIAL_LAYOUTS=(
    "layouts/index.html"
    "layouts/_default/baseof.html"
    "layouts/partials/essentials/head.html"
    "layouts/partials/essentials/header.html"
    "layouts/partials/essentials/footer.html"
    "layouts/partials/essentials/style.html"
    "layouts/partials/essentials/script.html"
)

ALL_GOOD=true
for layout in "${ESSENTIAL_LAYOUTS[@]}"; do
    if [ -f "$layout" ]; then
        echo -e "${GREEN}✓${NC} $layout"
    else
        echo -e "${RED}✗${NC} $layout ${RED}(MISSING!)${NC}"
        ALL_GOOD=false
    fi
done

echo ""
if [ "$ALL_GOOD" = true ]; then
    print_success "All essential layouts intact!"
else
    print_error "Some essential layouts are missing!"
    print_warning "Restore from backup immediately!"
    exit 1
fi

# ============================================
# COMPLETION
# ============================================
print_header "PHASE 2 COMPLETE!"

echo -e "${GREEN}Template cleanup successful!${NC}\n"
echo "Next steps:"
echo "  1. Test your site: npm run dev"
echo "  2. Visit: http://localhost:1313"
echo "  3. Verify all sections still work"
echo ""
echo -e "${YELLOW}If anything is broken, restore from backup:${NC}"
echo -e "  cd $PROJECT_DIR"
echo -e "  tar -xzf $BACKUP_DIR/$BACKUP_NAME"
echo ""
echo -e "${BLUE}Ready for Phase 3 (Configuration Cleanup)?${NC}"
echo "  This requires manual editing of config files"
echo "  See the audit report for specific changes"
echo ""

print_success "Log saved to: $LOG_FILE"
