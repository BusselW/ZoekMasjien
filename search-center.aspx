<%@ Page Language="C#" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Search Center</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f5f5f5;
            min-height: 100vh;
        }

        .search-container {
            width: 100%;
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }

        .search-header {
            text-align: center;
            padding: 40px 0;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            width: 100%;
            margin-bottom: 30px;
        }

        .search-header h1 {
            font-size: 2.5rem;
            margin-bottom: 10px;
            font-weight: 300;
        }

        .search-box-wrapper {
            max-width: 800px;
            margin: 0 auto;
            position: relative;
        }

        .search-box {
            width: 100%;
            padding: 15px 50px 15px 20px;
            font-size: 16px;
            border: none;
            border-radius: 50px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
            outline: none;
        }

        .search-box:focus {
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.25);
        }

        .search-button {
            position: absolute;
            right: 5px;
            top: 50%;
            transform: translateY(-50%);
            background: #667eea;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 50px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 600;
        }

        .search-button:hover {
            background: #5568d3;
        }

        .filters-container {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
        }

        .filters-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
        }

        .filters-header h2 {
            font-size: 1.2rem;
            color: #333;
            font-weight: 500;
        }

        .toggle-filters {
            background: none;
            border: none;
            color: #667eea;
            cursor: pointer;
            font-weight: 600;
        }

        .filters-content {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
        }

        .filter-group {
            display: flex;
            flex-direction: column;
        }

        .filter-group label {
            font-size: 14px;
            color: #666;
            margin-bottom: 5px;
            font-weight: 500;
        }

        .filter-group select,
        .filter-group input {
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
        }

        .results-container {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        }

        .results-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid #f0f0f0;
        }

        .results-count {
            font-size: 14px;
            color: #666;
        }

        .sort-options select {
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
        }

        .result-item {
            padding: 20px;
            border-bottom: 1px solid #f0f0f0;
            transition: background-color 0.2s;
        }

        .result-item:hover {
            background-color: #f9f9f9;
        }

        .result-item:last-child {
            border-bottom: none;
        }

        .result-badge {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            margin-bottom: 10px;
        }

        .badge-exact {
            background-color: #10b981;
            color: white;
        }

        .badge-almost {
            background-color: #f59e0b;
            color: white;
        }

        .badge-related {
            background-color: #6366f1;
            color: white;
        }

        .result-title {
            font-size: 1.3rem;
            color: #1a0dab;
            margin-bottom: 5px;
            text-decoration: none;
            display: block;
            font-weight: 400;
        }

        .result-title:hover {
            text-decoration: underline;
        }

        .result-url {
            font-size: 14px;
            color: #006621;
            margin-bottom: 5px;
        }

        .result-snippet {
            font-size: 14px;
            color: #545454;
            line-height: 1.6;
        }

        .result-meta {
            display: flex;
            gap: 15px;
            margin-top: 10px;
            font-size: 12px;
            color: #888;
        }

        .no-results {
            text-align: center;
            padding: 40px;
            color: #666;
        }

        .no-results h3 {
            font-size: 1.5rem;
            margin-bottom: 10px;
        }

        .loading {
            text-align: center;
            padding: 40px;
            color: #667eea;
        }

        .loading::after {
            content: '...';
            animation: dots 1.5s steps(4, end) infinite;
        }

        @keyframes dots {
            0%, 20% { content: '.'; }
            40% { content: '..'; }
            60%, 100% { content: '...'; }
        }

        .filters-collapsed .filters-content {
            display: none;
        }

        @media (max-width: 768px) {
            .search-header h1 {
                font-size: 1.8rem;
            }

            .filters-content {
                grid-template-columns: 1fr;
            }

            .results-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 10px;
            }
        }
    </style>
</head>
<body>
    <div class="search-header">
        <h1>Search Center</h1>
        <div class="search-box-wrapper">
            <input type="text" id="searchBox" class="search-box" placeholder="Search for documents, pages, people..." />
            <button class="search-button" onclick="performSearch()">Search</button>
        </div>
    </div>

    <div class="search-container">
        <div class="filters-container" id="filtersContainer">
            <div class="filters-header">
                <h2>Filters</h2>
                <button class="toggle-filters" onclick="toggleFilters()">Hide Filters</button>
            </div>
            <div class="filters-content">
                <div class="filter-group">
                    <label for="fileTypeFilter">File Type</label>
                    <select id="fileTypeFilter" onchange="performSearch()">
                        <option value="">All Types</option>
                        <option value="docx">Word Documents</option>
                        <option value="xlsx">Excel Spreadsheets</option>
                        <option value="pptx">PowerPoint</option>
                        <option value="pdf">PDF</option>
                        <option value="aspx">Web Pages</option>
                    </select>
                </div>
                <div class="filter-group">
                    <label for="authorFilter">Author</label>
                    <input type="text" id="authorFilter" placeholder="Filter by author..." onchange="performSearch()" />
                </div>
                <div class="filter-group">
                    <label for="dateFilter">Date Range</label>
                    <select id="dateFilter" onchange="performSearch()">
                        <option value="">Any Time</option>
                        <option value="today">Today</option>
                        <option value="week">Past Week</option>
                        <option value="month">Past Month</option>
                        <option value="year">Past Year</option>
                    </select>
                </div>
                <div class="filter-group">
                    <label for="siteFilter">Site</label>
                    <select id="siteFilter" onchange="performSearch()">
                        <option value="">All Sites</option>
                        <option value="site1">Team Site</option>
                        <option value="site2">Document Center</option>
                        <option value="site3">Project Site</option>
                    </select>
                </div>
            </div>
        </div>

        <div class="results-container">
            <div class="results-header">
                <div class="results-count" id="resultsCount">Enter a search term to begin</div>
                <div class="sort-options">
                    <select id="sortOptions" onchange="performSearch()">
                        <option value="relevance">Sort by Relevance</option>
                        <option value="date">Sort by Date</option>
                        <option value="title">Sort by Title</option>
                    </select>
                </div>
            </div>
            <div id="resultsContent">
                <!-- Search results will be dynamically inserted here -->
            </div>
        </div>
    </div>

    <script type="text/javascript">
        // Search state
        let searchCache = {};
        let currentQuery = '';

        // Initialize on page load
        document.addEventListener('DOMContentLoaded', function() {
            // Enable search on Enter key
            document.getElementById('searchBox').addEventListener('keypress', function(e) {
                if (e.key === 'Enter') {
                    performSearch();
                }
            });
        });

        // Toggle filters visibility
        function toggleFilters() {
            const container = document.getElementById('filtersContainer');
            const button = container.querySelector('.toggle-filters');
            
            if (container.classList.contains('filters-collapsed')) {
                container.classList.remove('filters-collapsed');
                button.textContent = 'Hide Filters';
            } else {
                container.classList.add('filters-collapsed');
                button.textContent = 'Show Filters';
            }
        }

        // Main search function
        function performSearch() {
            const query = document.getElementById('searchBox').value.trim();
            
            if (!query) {
                document.getElementById('resultsCount').textContent = 'Enter a search term to begin';
                document.getElementById('resultsContent').innerHTML = '';
                return;
            }

            currentQuery = query;
            
            // Show loading state
            document.getElementById('resultsContent').innerHTML = '<div class="loading">Searching</div>';
            
            // Get filter values
            const filters = {
                fileType: document.getElementById('fileTypeFilter').value,
                author: document.getElementById('authorFilter').value,
                dateRange: document.getElementById('dateFilter').value,
                site: document.getElementById('siteFilter').value
            };

            // Execute search with SharePoint REST API
            executeSharePointSearch(query, filters);
        }

        // Execute SharePoint REST API search
        function executeSharePointSearch(query, filters) {
            // Build the search query URL
            const siteUrl = _spPageContextInfo ? _spPageContextInfo.webAbsoluteUrl : window.location.origin;
            let searchQuery = query;

            // Apply filters to the query
            if (filters.fileType) {
                searchQuery += ' FileExtension:' + filters.fileType;
            }
            if (filters.author) {
                searchQuery += ' Author:"' + filters.author + '"';
            }
            if (filters.site) {
                searchQuery += ' Path:' + filters.site;
            }

            // Build REST API URL
            const apiUrl = siteUrl + "/_api/search/query?querytext='" + encodeURIComponent(searchQuery) + 
                          "'&rowlimit=50&selectproperties='Title,Path,Author,Write,FileExtension,HitHighlightedSummary'";

            // Make the API call
            fetch(apiUrl, {
                method: 'GET',
                headers: {
                    'Accept': 'application/json;odata=verbose',
                    'Content-Type': 'application/json;odata=verbose'
                }
            })
            .then(response => response.json())
            .then(data => {
                if (data.d && data.d.query && data.d.query.PrimaryQueryResult) {
                    const results = data.d.query.PrimaryQueryResult.RelevantResults.Table.Rows.results;
                    processAndDisplayResults(results, query, filters);
                } else {
                    displayNoResults();
                }
            })
            .catch(error => {
                console.error('Search error:', error);
                // Fallback to mock data for demonstration
                useMockData(query, filters);
            });
        }

        // Process results with advanced ranking algorithm
        function processAndDisplayResults(rawResults, query, filters) {
            const queryLower = query.toLowerCase();
            const queryTerms = queryLower.split(/\s+/).filter(term => term.length > 0);

            // Transform SharePoint results to our format
            const results = rawResults.map(item => {
                const cells = item.Cells.results;
                const result = {};
                
                cells.forEach(cell => {
                    result[cell.Key] = cell.Value;
                });

                return {
                    title: result.Title || 'Untitled',
                    url: result.Path || '#',
                    snippet: result.HitHighlightedSummary || '',
                    author: result.Author || 'Unknown',
                    modified: result.Write || '',
                    fileType: result.FileExtension || 'aspx'
                };
            });

            // Apply ranking algorithm
            const rankedResults = rankResults(results, queryTerms, queryLower);

            // Apply date filter if specified
            const filteredResults = applyDateFilter(rankedResults, filters.dateRange);

            // Display results
            displayResults(filteredResults, query);
        }

        // Advanced ranking algorithm: Exact > Almost Exact > Related
        function rankResults(results, queryTerms, fullQuery) {
            return results.map(result => {
                const titleLower = result.title.toLowerCase();
                const snippetLower = result.snippet.toLowerCase();
                const combinedText = titleLower + ' ' + snippetLower;

                let score = 0;
                let matchType = 'related';

                // 1. EXACT MATCH - Highest priority (1000+ points)
                if (titleLower === fullQuery) {
                    score = 1000;
                    matchType = 'exact';
                } else if (titleLower.includes(fullQuery)) {
                    score = 900;
                    matchType = 'exact';
                } else if (combinedText.includes(fullQuery)) {
                    score = 800;
                    matchType = 'exact';
                }

                // 2. ALMOST EXACT MATCH - Medium priority (500-799 points)
                if (matchType === 'related') {
                    // Check if all query terms appear in title
                    const allTermsInTitle = queryTerms.every(term => titleLower.includes(term));
                    if (allTermsInTitle) {
                        score = 700;
                        matchType = 'almost';
                    } else {
                        // Check if all query terms appear in combined text
                        const allTermsInText = queryTerms.every(term => combinedText.includes(term));
                        if (allTermsInText) {
                            score = 600;
                            matchType = 'almost';
                        }
                        // Check for partial term matches (fuzzy)
                        else {
                            let termMatchCount = 0;
                            queryTerms.forEach(term => {
                                if (titleLower.includes(term)) {
                                    termMatchCount += 2; // Title matches worth more
                                } else if (combinedText.includes(term)) {
                                    termMatchCount += 1;
                                }
                            });
                            
                            if (termMatchCount >= queryTerms.length) {
                                score = 500 + (termMatchCount * 10);
                                matchType = 'almost';
                            }
                        }
                    }
                }

                // 3. RELATED MATCH - Lowest priority (0-499 points)
                if (matchType === 'related') {
                    // Calculate relevance based on term frequency
                    let relatedScore = 0;
                    queryTerms.forEach(term => {
                        // Count occurrences in title (higher weight)
                        const titleMatches = (titleLower.match(new RegExp(term, 'g')) || []).length;
                        relatedScore += titleMatches * 50;

                        // Count occurrences in snippet
                        const snippetMatches = (snippetLower.match(new RegExp(term, 'g')) || []).length;
                        relatedScore += snippetMatches * 10;

                        // Fuzzy matching - check for similar terms
                        if (term.length >= 4) {
                            const fuzzyRegex = new RegExp(term.substring(0, term.length - 1), 'g');
                            const fuzzyMatches = (combinedText.match(fuzzyRegex) || []).length;
                            relatedScore += fuzzyMatches * 5;
                        }
                    });

                    score = Math.min(relatedScore, 499);
                }

                return {
                    ...result,
                    score: score,
                    matchType: matchType
                };
            }).sort((a, b) => b.score - a.score); // Sort by score descending
        }

        // Apply date filter
        function applyDateFilter(results, dateRange) {
            if (!dateRange) return results;

            const now = new Date();
            const filterDate = new Date();

            switch(dateRange) {
                case 'today':
                    filterDate.setHours(0, 0, 0, 0);
                    break;
                case 'week':
                    filterDate.setDate(now.getDate() - 7);
                    break;
                case 'month':
                    filterDate.setMonth(now.getMonth() - 1);
                    break;
                case 'year':
                    filterDate.setFullYear(now.getFullYear() - 1);
                    break;
                default:
                    return results;
            }

            return results.filter(result => {
                if (!result.modified) return true;
                const modifiedDate = new Date(result.modified);
                return modifiedDate >= filterDate;
            });
        }

        // Display search results
        function displayResults(results, query) {
            const resultsContent = document.getElementById('resultsContent');
            const resultsCount = document.getElementById('resultsCount');

            if (results.length === 0) {
                displayNoResults();
                return;
            }

            resultsCount.textContent = `Found ${results.length} result${results.length !== 1 ? 's' : ''} for "${query}"`;

            let html = '';
            results.forEach(result => {
                const badgeClass = result.matchType === 'exact' ? 'badge-exact' : 
                                 result.matchType === 'almost' ? 'badge-almost' : 'badge-related';
                const badgeText = result.matchType === 'exact' ? 'EXACT MATCH' : 
                                result.matchType === 'almost' ? 'ALMOST EXACT' : 'RELATED';

                html += `
                    <div class="result-item">
                        <span class="result-badge ${badgeClass}">${badgeText}</span>
                        <a href="${result.url}" class="result-title">${highlightText(result.title, query)}</a>
                        <div class="result-url">${result.url}</div>
                        <div class="result-snippet">${highlightText(result.snippet, query)}</div>
                        <div class="result-meta">
                            <span>📄 ${result.fileType.toUpperCase()}</span>
                            <span>👤 ${result.author}</span>
                            <span>📅 ${formatDate(result.modified)}</span>
                        </div>
                    </div>
                `;
            });

            resultsContent.innerHTML = html;
        }

        // Display no results message
        function displayNoResults() {
            document.getElementById('resultsCount').textContent = 'No results found';
            document.getElementById('resultsContent').innerHTML = `
                <div class="no-results">
                    <h3>No results found</h3>
                    <p>Try different keywords or remove some filters</p>
                </div>
            `;
        }

        // Highlight search terms in text
        function highlightText(text, query) {
            if (!text || !query) return text;

            const terms = query.split(/\s+/).filter(term => term.length > 0);
            let highlighted = text;

            terms.forEach(term => {
                const regex = new RegExp(`(${escapeRegex(term)})`, 'gi');
                highlighted = highlighted.replace(regex, '<strong>$1</strong>');
            });

            return highlighted;
        }

        // Escape special regex characters
        function escapeRegex(str) {
            return str.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
        }

        // Format date
        function formatDate(dateString) {
            if (!dateString) return 'Unknown date';

            const date = new Date(dateString);
            const now = new Date();
            const diffTime = Math.abs(now - date);
            const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));

            if (diffDays === 0) return 'Today';
            if (diffDays === 1) return 'Yesterday';
            if (diffDays < 7) return `${diffDays} days ago`;
            if (diffDays < 30) return `${Math.floor(diffDays / 7)} weeks ago`;
            if (diffDays < 365) return `${Math.floor(diffDays / 30)} months ago`;

            return date.toLocaleDateString();
        }

        // Mock data for demonstration (fallback when SharePoint API is not available)
        function useMockData(query, filters) {
            const mockResults = [
                {
                    title: 'SharePoint Server 2019 Installation Guide',
                    url: '/sites/docs/installation-guide.aspx',
                    snippet: 'Complete guide for installing and configuring SharePoint Server 2019 in your environment.',
                    author: 'John Smith',
                    modified: '2025-11-01T10:30:00Z',
                    fileType: 'aspx'
                },
                {
                    title: 'SharePoint 2019 Best Practices',
                    url: '/sites/docs/best-practices.docx',
                    snippet: 'Learn the best practices for SharePoint Server 2019 deployment and management.',
                    author: 'Jane Doe',
                    modified: '2025-10-28T14:20:00Z',
                    fileType: 'docx'
                },
                {
                    title: 'Search Configuration in SharePoint',
                    url: '/sites/docs/search-config.pdf',
                    snippet: 'How to configure and optimize search functionality in SharePoint Server 2019.',
                    author: 'Bob Johnson',
                    modified: '2025-10-25T09:15:00Z',
                    fileType: 'pdf'
                },
                {
                    title: 'Project Status Report',
                    url: '/sites/projects/status-report.xlsx',
                    snippet: 'Monthly project status report containing metrics and updates for all ongoing projects.',
                    author: 'Alice Brown',
                    modified: '2025-11-05T16:45:00Z',
                    fileType: 'xlsx'
                },
                {
                    title: 'Team Meeting Notes - SharePoint Migration',
                    url: '/sites/team/meeting-notes.aspx',
                    snippet: 'Notes from the team meeting discussing SharePoint migration strategies and timelines.',
                    author: 'John Smith',
                    modified: '2025-11-03T11:00:00Z',
                    fileType: 'aspx'
                }
            ];

            // Filter by file type
            let filteredMockResults = mockResults;
            if (filters.fileType) {
                filteredMockResults = filteredMockResults.filter(r => r.fileType === filters.fileType);
            }
            if (filters.author) {
                filteredMockResults = filteredMockResults.filter(r => 
                    r.author.toLowerCase().includes(filters.author.toLowerCase())
                );
            }

            // Process with ranking algorithm
            const queryTerms = query.toLowerCase().split(/\s+/).filter(term => term.length > 0);
            const rankedResults = rankResults(filteredMockResults, queryTerms, query.toLowerCase());

            // Apply date filter
            const finalResults = applyDateFilter(rankedResults, filters.dateRange);

            displayResults(finalResults, query);
        }
    </script>
</body>
</html>
