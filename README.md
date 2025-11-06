# ZoekMasjien

**ZoekMasjien** (Dutch for "Search Machine") is a modern, full-width search center designed for SharePoint Server 2019. It features an advanced ranking algorithm that prioritizes search results based on match quality: Exact > Almost Exact > Related.

## Features

- ✨ **Clean, Modern Design**: Full-width layout with responsive design
- 🎯 **Advanced Ranking Algorithm**: Prioritizes exact matches, then almost exact, then related results
- 🔍 **Comprehensive Filters**: Filter by file type, author, date range, and site
- 📊 **Visual Match Indicators**: Color-coded badges show match quality at a glance
- ⚡ **Fast & Responsive**: Optimized for quick searches and smooth user experience
- 🔌 **SharePoint Integration**: Works seamlessly with SharePoint 2019 REST API

## Quick Start

### Demo Version (No SharePoint Required)
Open `demo.html` in any web browser to see the search center in action with mock data.

### SharePoint Deployment
1. Upload `search-center.aspx` to your SharePoint site (e.g., `/SitePages/`)
2. Navigate to the page URL
3. Start searching!

## Files

- **search-center.aspx**: Full SharePoint 2019 ASPX page with REST API integration
- **demo.html**: Standalone HTML demo version with mock data
- **IMPLEMENTATION.md**: Detailed implementation guide and documentation

## Ranking Algorithm

The search engine uses a three-tier system:

1. **Exact Match** (🟢 Green Badge): Title or content exactly matches the search query
2. **Almost Exact** (🟠 Orange Badge): All search terms present in title or content
3. **Related** (🔵 Blue Badge): Partial matches and fuzzy term matching

## Documentation

See [IMPLEMENTATION.md](IMPLEMENTATION.md) for:
- Detailed feature descriptions
- Installation instructions
- Usage guide
- Technical documentation
- Customization options
- Troubleshooting tips

## Screenshots

Try these test queries in the demo:
- "SharePoint Server 2019" - See exact match ranking
- "SharePoint 2019" - See almost exact matching
- "search" - See related results

## Requirements

- SharePoint Server 2019 (for production use)
- Modern web browser (Edge, Chrome, Firefox, Safari)
- SharePoint Search Service must be configured and running

## License

This project is provided as-is for use with SharePoint Server 2019 environments.
