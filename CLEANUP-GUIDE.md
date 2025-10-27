# Hugo Bloat Cleanup Guide
## Eskay Digital Single-Page Site

**Created:** 2025-10-26
**Total Bloat Identified:** 3.9+ MB
**Phases:** 4 (2 automated, 2 manual)

---

## Quick Start

### Automated Cleanup (Recommended)

```bash
# Phase 1: Remove files (automated, safe)
./cleanup-bloat.sh

# Test your site
npm run dev
# Visit http://localhost:1313

# Phase 2: Remove templates (automated, after testing)
./cleanup-phase2.sh

# Test again
npm run dev
```

### Manual Cleanup (Advanced)

After automated phases, manually edit configuration files for Phase 3 & 4.

---

## Phase Details

### ✅ Phase 1: File Removal (Automated - 3.9 MB)
**Script:** `cleanup-bloat.sh`
**Risk:** Low
**Requires Testing:** Yes

**What's removed:**
- exampleSite directory (1.8 MB)
- Gallery images (1.3 MB)
- Duplicate logo files (586 KB)
- Demo/placeholder images (250 KB)
- Unused plugins (maps)
- Blog content files (20 KB)

**Backup created:** `eskay-backup-YYYYMMDD-HHMMSS.tar.gz`

---

### ✅ Phase 2: Template Cleanup (Automated - 30 KB)
**Script:** `cleanup-phase2.sh`
**Risk:** Medium
**Requires Testing:** Yes

**What's removed:**
- Unused layout templates (17 files)
- Blog/author page layouts
- Unused partials (widgets, cards)

**Backup created:** `eskay-phase2-backup-YYYYMMDD-HHMMSS.tar.gz`

---

### ⚠️ Phase 3: Configuration Cleanup (Manual)
**Risk:** Medium
**Files to edit:** 3 configuration files

#### File 1: `config/_default/module.toml`

Remove these 13 module imports:

```toml
# DELETE:
[[imports]]
path = "github.com/gethugothemes/hugo-modules/search"

[[imports]]
path = "github.com/gethugothemes/hugo-modules/pwa"

[[imports]]
path = "github.com/gethugothemes/hugo-modules/videos"

[[imports]]
path = "github.com/gethugothemes/hugo-modules/accordion"

[[imports]]
path = "github.com/gethugothemes/hugo-modules/table-of-contents"

[[imports]]
path = "github.com/gethugothemes/hugo-modules/tab"

[[imports]]
path = "github.com/gethugothemes/hugo-modules/modal"

[[imports]]
path = "github.com/gethugothemes/hugo-modules/gallery-slider"

[[imports]]
path = "github.com/gethugothemes/hugo-modules/components/preloader"

[[imports]]
path = "github.com/gethugothemes/hugo-modules/components/social-share"

[[imports]]
path = "github.com/gethugothemes/hugo-modules/components/cookie-consent"

[[imports]]
path = "github.com/gethugothemes/hugo-modules/components/announcement"

[[imports]]
path = "github.com/hugomods/mermaid"
```

---

#### File 2: `hugo.toml`

**Changes needed:**

1. **Delete Disqus section** (around line 26):
```toml
# DELETE:
[services.disqus]
shortname = 'themefisher-template'
```

2. **Delete permalink rules** (around line 29):
```toml
# DELETE:
[permalinks.page]
"pages" = "/:slugorcontentbasename/"
```

3. **Delete pagination** (around line 34):
```toml
# DELETE:
[pagination]
disableAliases = false
pagerSize = 10
path = 'page'
```

4. **Delete table of contents** (around line 91):
```toml
# DELETE:
[markup.tableOfContents]
startLevel = 2
endLevel = 5
ordered = true
```

5. **Update mainSections** (around line 21):
```toml
# CHANGE FROM:
mainSections = ["blog"]

# TO:
mainSections = []
```

6. **Update outputs** (around line 61):
```toml
# CHANGE FROM:
[outputs]
home = ["HTML", "RSS", "WebAppManifest", "SearchIndex"]

# TO:
[outputs]
home = ["HTML", "RSS", "WebAppManifest"]
```

7. **Delete unused JS plugins** (around line 136-162):
```toml
# DELETE all these plugin entries:
[[params.plugins.js]]
link = "js/search.js"
lazy = false

[[params.plugins.js]]
link = "plugins/glightbox/glightbox.js"
lazy = true

[[params.plugins.js]]
link = "js/gallery-slider.js"
lazy = true

[[params.plugins.js]]
link = "js/accordion.js"
lazy = true

[[params.plugins.js]]
link = "js/tab.js"
lazy = true

[[params.plugins.js]]
link = "js/modal.js"
lazy = true

[[params.plugins.js]]
link = "plugins/youtube-lite.js"
lazy = true

[[params.plugins.js]]
link = "plugins/cookie.js"
lazy = false
```

8. **Delete unused CSS plugin** (around line 122):
```toml
# DELETE:
[[params.plugins.css]]
link = "plugins/glightbox/glightbox.css"
lazy = true
```

---

#### File 3: `config/_default/params.toml`

**Changes needed:**

1. **Disable search** (around line 44):
```toml
# CHANGE:
[search]
enable = false          # Was: true
primary_color = "#006826"
include_sections = []   # Was: ["blog"]
```

2. **Clear widgets** (around line 93):
```toml
# CHANGE:
[widgets]
sidebar = []            # Was: ["categories", "tags"]
```

---

#### After Phase 3:

```bash
# Test thoroughly:
npm run dev

# If broken, restore config files from backup
```

---

### ⚠️ Phase 4: Advanced Optimization (Manual, Optional)

#### Optimize Favicon (230 KB savings)

```bash
# Requires ImageMagick (install: brew install imagemagick)
convert assets/images/favicon.png -define icon:auto-resize=64,48,32,16 assets/images/favicon-optimized.ico
mv assets/images/favicon-optimized.ico assets/images/favicon.ico
```

#### Replace Swiper.js (340 KB savings)

**Current:** 340 KB Swiper library for testimonials
**Option:** Replace with CSS-only carousel or minimal JS slider

This requires custom development - not included in automated scripts.

---

## Testing Checklist

After EACH phase, test these:

- [ ] Homepage loads correctly
- [ ] Hero section displays
- [ ] About/Services sections visible
- [ ] Testimonials carousel works (Phase 1-2)
- [ ] Contact form appears
- [ ] Navigation menu functions
- [ ] Light/dark mode toggle works
- [ ] Mobile responsive (resize browser)
- [ ] All images load
- [ ] Green buttons display (#006826)

---

## Rollback Instructions

### If Phase 1 breaks something:

```bash
cd /Users/stevekedroski/Desktop/projects/eskay-digital-dot-com
tar -xzf ../eskay-backup-YYYYMMDD-HHMMSS.tar.gz
npm run dev
```

### If Phase 2 breaks something:

```bash
cd /Users/stevekedroski/Desktop/projects/eskay-digital-dot-com
tar -xzf ../eskay-phase2-backup-YYYYMMDD-HHMMSS.tar.gz
npm run dev
```

### If Phase 3 breaks something:

Restore individual config files from backup:

```bash
# Extract just config files from backup
tar -xzf ../eskay-phase2-backup-YYYYMMDD-HHMMSS.tar.gz config/ hugo.toml
```

---

## Expected Results

### Before Cleanup:
- **Project size:** 14 MB (excluding node_modules)
- **Content files:** 16 (only 3 used)
- **Layout templates:** 30 (only ~13 used)
- **Hugo modules:** 23 (only ~10 needed)

### After Full Cleanup:
- **Project size:** ~9.5 MB (excluding node_modules)
- **Content files:** 3 (all used)
- **Layout templates:** ~13 (all used)
- **Hugo modules:** ~10 (all needed)
- **Build time:** Reduced
- **Complexity:** Significantly simplified

**Total reduction:** 32% (4.5 MB)

---

## NPM Dependency Cleanup (Optional)

After all phases:

```bash
# Remove Tailwind Typography (blog-specific)
npm uninstall @tailwindcss/typography

# Clean up
npm install
```

**Savings:** ~2 MB in node_modules

---

## Logs

Each phase creates a detailed log:

- `cleanup-log-YYYYMMDD-HHMMSS.txt` (Phase 1)
- `cleanup-phase2-log-YYYYMMDD-HHMMSS.txt` (Phase 2)

Review these for complete details of what was removed.

---

## Support

If you encounter issues:

1. Check the logs for details
2. Restore from the most recent backup
3. Test incrementally (one phase at a time)
4. Verify critical files exist (see scripts)

---

## Files Created by This Cleanup

- `cleanup-bloat.sh` - Phase 1 automation
- `cleanup-phase2.sh` - Phase 2 automation
- `CLEANUP-GUIDE.md` - This guide
- Backups in parent directory
- Log files in project root

---

## Summary

**Safest approach:**
1. Run Phase 1 script → Test → Success?
2. Run Phase 2 script → Test → Success?
3. Manually do Phase 3 → Test → Success?
4. Consider Phase 4 (optional)

**Most thorough:**
- Backup before each phase
- Test after each phase
- Keep logs for reference

**Time estimate:**
- Phase 1: 2 minutes (automated)
- Phase 2: 2 minutes (automated)
- Phase 3: 15 minutes (manual editing)
- Phase 4: 30+ minutes (advanced)

Good luck! 🚀
