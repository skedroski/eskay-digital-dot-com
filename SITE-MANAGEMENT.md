# Site Management Guide

## How to Manage Your Eskay Digital Website

### Content Updates

Edit `content/english/_index.md` to update hero, about, and services sections.

### Navigation

Modify `config/_default/menus.en.toml` to change menu items and links.

### Site Settings

Update `config/_default/params.toml` for site-wide configuration including:
- Logo settings
- Navigation button
- SEO metadata
- Copyright information

### Styling

Adjust colors in `data/theme.json` to customize the site's visual theme.

## Running the Development Server

```bash
npm run dev
```

Site will be available at http://localhost:1313/

## Building for Production

```bash
npm run build
```\







Adding Your Branding
1. Logo Files
Replace these files in assets/images/:
logo.png - Your logo for light mode
logo-darkmode.png - Your logo for dark mode (or same logo if it works in both)
favicon.png - Your favicon (small icon for browser tabs)
2. Recommended Sizes
Logo: Around 160px wide × 32px tall (or maintain your brand proportions)
Favicon: 32×32px or 64×64px
3. Using SVG (Optional)
If you have SVG logos, you can use them instead:
# In config/_default/params.toml
logo = "images/logo.svg"
logo_darkmode = "images/logo-darkmode.svg"
4. Adjust Logo Dimensions
After adding your logo, update the dimensions in config/_default/params.toml:8-9:
logo_width = "160px"
logo_height = "32px"
5. Where to Place Files
Put your image files in: assets/images/ The site will automatically pick them up and Hugo will hot-reload