<%@ Page Language="C#" %>
<!--
    ZoekMasjien - SharePoint 2019 Zoekcentrum
    
    CONFIGURATIE INSTRUCTIES:
    =========================
    
    1. ZOEK BEREIK INSTELLEN:
       Bewerk de SEARCH_CONFIG variabele in de JavaScript sectie:
       
    2. OPTIES VOOR searchScope:
       - 'auto': Automatische detectie (aanbevolen)
       - 'current-site': Zoek alleen in huidige site
       - 'web-application': Zoek in alle site collections
       - 'custom': Gebruik aangepaste URL
       
    3. DEPLOYMENT:
       - Voor centrale zoekfunctie: plaats in root web application
       - Voor site-specifieke zoekfunctie: plaats in gewenste site
       
    4. MACHTIGINGEN:
       - Gebruikers hebben 'Read' rechten nodig op zoekbare content
       - SharePoint Search Service moet draaien en geconfigureerd zijn
-->
<!DOCTYPE html>
<html lang="nl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Zoekcentrum</title>
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

        .search-scope-info {
            font-size: 0.9rem;
            opacity: 0.8;
            margin-bottom: 20px;
            background: rgba(255, 255, 255, 0.1);
            padding: 5px 15px;
            border-radius: 15px;
            display: inline-block;
        }

        .search-scope-info span {
            font-weight: 500;
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
        <h1>Zoekcentrum</h1>
        <div id="searchScope" class="search-scope-info">Zoekt in: <span id="scopeText">Laden...</span></div>
        <div class="search-box-wrapper">
            <input type="text" id="searchBox" class="search-box" placeholder="Zoek naar documenten, pagina's, personen..." />
            <button class="search-button" onclick="performSearch()">Zoeken</button>
        </div>
    </div>

    <div class="search-container">
        <div class="filters-container" id="filtersContainer">
            <div class="filters-header">
                <h2>Filters</h2>
                <button class="toggle-filters" onclick="toggleFilters()">Filters Verbergen</button>
            </div>
            <div class="filters-content">
                <div class="filter-group">
                    <label for="contentTypeFilter">Zoek in</label>
                    <select id="contentTypeFilter" onchange="toggleWeekmailCategorie()">
                        <option value="documenten">Documenten</option>
                        <option value="schouwrapporten">Schouwrapporten</option>
                        <option value="pleeglocaties">Bijzondere Pleeglocaties</option>
                        <option value="weekmail">Weekmail</option>
                        <option value="alle">Alles</option>
                    </select>
                </div>
                <div class="filter-group" id="weekmailCategorieGroep" style="display: none;">
                    <label for="weekmailCategorieFilter">Weekmail Categorie</label>
                    <select id="weekmailCategorieFilter" onchange="performSearch()">
                        <option value="">Alle Categorieën</option>
                        <option value="beoordelen">Beoordelen (hoofdmap)</option>
                        <option value="Verkeersborden">Verkeersborden</option>
                        <option value="Rijgedrag">Rijgedrag</option>
                        <option value="ZVZichtPlicht">ZV Zicht & Plicht</option>
                        <option value="Parkeren">Parkeren</option>
                        <option value="FlitsSV">ZV Flits</option>
                        <option value="Flex">Flex</option>
                    </select>
                </div>
                <div class="filter-group">
                    <label for="fileTypeFilter">Bestandstype</label>
                    <select id="fileTypeFilter" onchange="performSearch()">
                        <option value="">Alle Typen</option>
                        <option value="docx">Word Documenten</option>
                        <option value="xlsx">Excel Werkbladen</option>
                        <option value="pptx">PowerPoint</option>
                        <option value="pdf">PDF</option>
                    </select>
                </div>
                <div class="filter-group">
                    <label for="authorFilter">Auteur</label>
                    <input type="text" id="authorFilter" placeholder="Filter op auteur..." onchange="performSearch()" />
                </div>
                <div class="filter-group">
                    <label for="dateFilter">Datumbereik</label>
                    <select id="dateFilter" onchange="performSearch()">
                        <option value="">Alle Tijden</option>
                        <option value="today">Vandaag</option>
                        <option value="week">Afgelopen Week</option>
                        <option value="month">Afgelopen Maand</option>
                        <option value="year">Afgelopen Jaar</option>
                    </select>
                </div>
                <div class="filter-group">
                    <label for="siteFilter">Subsite</label>
                    <select id="siteFilter" onchange="performSearch()">
                        <option value="">Alle Subsites</option>
                        <option value="/sites/MulderT">Hoofdsite (MulderT)</option>
                        <!-- Subsites worden automatisch geladen via JavaScript -->
                    </select>
                </div>
            </div>
        </div>

        <div class="results-container">
            <div class="results-header">
                <div class="results-count" id="resultsCount">Voer een zoekterm in om te beginnen</div>
                <div class="sort-options">
                    <select id="sortOptions" onchange="performSearch()">
                        <option value="relevance">Sorteer op Relevantie</option>
                        <option value="date">Sorteer op Datum</option>
                        <option value="title">Sorteer op Titel</option>
                    </select>
                </div>
            </div>
            <div id="resultsContent">
                <!-- Zoekresultaten worden hier dynamisch ingevoegd -->
            </div>
        </div>
    </div>

    <script type="text/javascript">
        // ============================================================================
        // CONFIGURATIE INSTELLINGEN
        // ============================================================================
        
        // BELANGRIJK: Configureer deze instellingen voor jouw SharePoint omgeving
        const SEARCH_CONFIG = {
            // Aangepast voor MulderT site en alle subsites
            searchScope: 'custom',
            
            // BELANGRIJK: Gebruik ALTIJD de huidige site context indien beschikbaar!
            customSearchUrl: (typeof _spPageContextInfo !== 'undefined' && _spPageContextInfo.webAbsoluteUrl) 
                ? _spPageContextInfo.webAbsoluteUrl 
                : 'https://som.org.om.local/sites/MulderT',
            
            // Path filter voor site scope
            basePath: '/sites/MulderT',
            
            // Zoek bronnen
            searchSources: {
                // Enterprise zoekresultaten (doorzoekt alle sites)
                enterprise: '8413cd39-2156-4e00-b54d-11efd9abdb89',
                // Lokale SharePoint resultaten (huidige site collectie)
                local: 'b09a7990-05ea-4af9-81ef-edfab16c4e31',
                // Personen zoeken
                people: 'b09a7990-05ea-4af9-81ef-edfab16c4e32'
            }
        };
        
        // Log de configuratie direct
        console.log('[Config] _spPageContextInfo beschikbaar:', typeof _spPageContextInfo !== 'undefined');
        if (typeof _spPageContextInfo !== 'undefined') {
            console.log('[Config] Huidige site URL:', _spPageContextInfo.webAbsoluteUrl);
        }
        console.log('[Config] Gebruikte search URL:', SEARCH_CONFIG.customSearchUrl);
        
        // Search state
        let currentQuery = '';

        // ============================================================================
        // ZOEK CONFIGURATIE FUNCTIES
        // ============================================================================
        
        // Toon configuratie info aan gebruiker
        function showSearchConfig() {
            const searchUrl = SEARCH_CONFIG.customSearchUrl;
            
            // Update UI met scope informatie
            const scopeElement = document.getElementById('scopeText');
            if (scopeElement) {
                scopeElement.textContent = `MulderT site + alle subsites (som.org.om.local)`;
            }
            
            // Log voor debugging
            console.log('ZoekMasjien Configuratie:', {
                searchScope: SEARCH_CONFIG.searchScope,
                searchUrl: searchUrl,
                basePath: SEARCH_CONFIG.basePath
            });
        }

        // Laad beschikbare subsites (vereenvoudigd met werkende API)
        function loadAvailableSubsites() {
            const zoekApiUrl = `${SEARCH_CONFIG.customSearchUrl}/_api/search/query`;
            const kqlQuery = `ContentClass:STS_Web Path:"${SEARCH_CONFIG.basePath}*"`;
            const apiUrl = `${zoekApiUrl}?querytext='${encodeURIComponent(kqlQuery)}'&rowlimit=50&selectproperties='Title,Path'`;

            fetch(apiUrl, {
                method: 'GET',
                headers: {
                    'Accept': 'application/json;odata=verbose'
                }
            })
            .then(response => response.json())
            .then(data => {
                if (data.d && data.d.query && data.d.query.PrimaryQueryResult) {
                    const results = data.d.query.PrimaryQueryResult.RelevantResults.Table.Rows.results;
                    populateSubsiteFilter(results);
                }
            })
            .catch(error => {
                console.log('Kan subsites niet laden:', error);
                addDefaultSubsiteOptions();
            });
        }

        // Vul subsite filter met gevonden subsites
        function populateSubsiteFilter(subsites) {
            const siteFilter = document.getElementById('siteFilter');
            if (!siteFilter) return;

            // Bewaar de huidige selectie
            const currentValue = siteFilter.value;

            // Verwijder alle behalve de eerste twee opties
            while (siteFilter.children.length > 2) {
                siteFilter.removeChild(siteFilter.lastChild);
            }

            // Voeg gevonden subsites toe
            const addedPaths = new Set();
            subsites.forEach(subsite => {
                const cells = subsite.Cells.results;
                const title = getCelWaarde(cells, 'Title');
                const path = getCelWaarde(cells, 'Path');

                if (path && !addedPaths.has(path)) {
                    addedPaths.add(path);
                    
                    // Maak leesbare naam van pad
                    const relativePath = path.replace('https://som.org.om.local', '');
                    const displayName = title || relativePath.split('/').filter(p => p).pop() || 'Onbekende Site';
                    
                    const option = document.createElement('option');
                    option.value = relativePath;
                    option.textContent = displayName;
                    siteFilter.appendChild(option);
                }
            });

            // Herstel selectie als mogelijk
            if (currentValue) {
                siteFilter.value = currentValue;
            }

            console.log(`${addedPaths.size} subsites geladen`);
        }

        // Voeg standaard subsite opties toe als automatisch laden mislukt
        function addDefaultSubsiteOptions() {
            const siteFilter = document.getElementById('siteFilter');
            if (!siteFilter) return;

            const defaultOptions = [
                { value: '/sites/MulderT/Kennis', text: 'Kennis' },
                { value: '/sites/MulderT/Documents', text: 'Documenten' }
            ];

            defaultOptions.forEach(option => {
                const optionElement = document.createElement('option');
                optionElement.value = option.value;
                optionElement.textContent = option.text;
                siteFilter.appendChild(optionElement);
            });
        }

        // Initialize on page load
        document.addEventListener('DOMContentLoaded', function() {
            // Toon configuratie info
            showSearchConfig();
            
            // Laad beschikbare subsites
            setTimeout(loadAvailableSubsites, 1000); // Kort uitstel voor SharePoint initialisatie
            
            // Enable search on Enter key
            document.getElementById('searchBox').addEventListener('keypress', function(e) {
                if (e.key === 'Enter') {
                    performSearch();
                }
            });
        });

        // Toggle weekmail categorie dropdown en subsite filter
        function toggleWeekmailCategorie() {
            const contentType = document.getElementById('contentTypeFilter').value;
            const weekmailGroep = document.getElementById('weekmailCategorieGroep');
            const subsiteFilterGroep = document.querySelector('.filter-group:has(#siteFilter)');
            
            if (contentType === 'weekmail') {
                weekmailGroep.style.display = 'flex'; // Toon de categorie dropdown
                if (subsiteFilterGroep) subsiteFilterGroep.style.display = 'none'; // Verberg subsite filter
                console.log('[UI] Weekmail categorie dropdown getoond, subsite filter verborgen');
            } else {
                weekmailGroep.style.display = 'none'; // Verberg de categorie dropdown
                if (subsiteFilterGroep) subsiteFilterGroep.style.display = 'flex'; // Toon subsite filter
                // Reset de selectie
                document.getElementById('weekmailCategorieFilter').value = '';
                console.log('[UI] Weekmail categorie dropdown verborgen, subsite filter getoond');
            }
            
            // Voer direct een nieuwe zoekopdracht uit
            if (currentQuery) {
                performSearch();
            }
        }

        // Toggle filters visibility
        function toggleFilters() {
            const container = document.getElementById('filtersContainer');
            const button = container.querySelector('.toggle-filters');
            
            if (container.classList.contains('filters-collapsed')) {
                container.classList.remove('filters-collapsed');
                button.textContent = 'Filters Verbergen';
            } else {
                container.classList.add('filters-collapsed');
                button.textContent = 'Filters Tonen';
            }
        }

        // Main search function
        function performSearch() {
            const query = document.getElementById('searchBox').value.trim();
            
            if (!query) {
                document.getElementById('resultsCount').textContent = 'Voer een zoekterm in om te beginnen';
                document.getElementById('resultsContent').innerHTML = '';
                return;
            }

            currentQuery = query;
            
            // Show loading state
            document.getElementById('resultsContent').innerHTML = '<div class="loading">Zoeken</div>';
            
            // Get filter values
            const filters = {
                contentType: document.getElementById('contentTypeFilter').value,
                weekmailCategorie: document.getElementById('weekmailCategorieFilter').value,
                fileType: document.getElementById('fileTypeFilter').value,
                author: document.getElementById('authorFilter').value,
                dateRange: document.getElementById('dateFilter').value,
                site: document.getElementById('siteFilter').value
            };

            console.log('[Zoeken] Query:', query);
            console.log('[Zoeken] Filters:', filters);

            // Execute search with SharePoint REST API
            executeSharePointSearch(query, filters);
        }

        // Execute SharePoint REST API search (aangepast met werkende KQL logica)
        function executeSharePointSearch(query, filters) {
            const zoekApiUrl = `${SEARCH_CONFIG.customSearchUrl}/_api/search/query`;
            
            console.log('[API] Basis URL:', SEARCH_CONFIG.customSearchUrl);
            console.log('[API] API URL:', zoekApiUrl);
            
            // Bouw KQL query zoals in werkende implementatie
            let kqlQuery = "";
            const documentExtensiesLijst = ['doc','docx','xls','xlsx','ppt','pptx','pdf','txt','rtf','odt','ods','odp'];
            const algemeenFileTypeFilter = documentExtensiesLijst.map(ext => `FileType:${ext}`).join(' OR ');
            
            // Bepaal basis path filter
            let pathFilter = `Path:"${SEARCH_CONFIG.basePath}*"`;
            
            // Pas subsite filter toe indien geselecteerd
            if (filters.site) {
                const sanitizedSite = filters.site.replace(/[^a-zA-Z0-9\-_\/]/g, '');
                if (sanitizedSite) {
                    pathFilter = `Path:"https://som.org.om.local${sanitizedSite}*"`;
                }
            }
            
            console.log('[KQL] Path filter:', pathFilter);
            
            // Bepaal content type filter (Documenten vs Weekmail vs Schouwrapporten etc.)
            const contentTypeFilter = filters.contentType || 'documenten';
            console.log('[KQL] Content type filter:', contentTypeFilter);
            
            // Definieer uitgezonderde paden voor documenten zoeken
            const schouwrapportenPad = 'https://som.org.om.local/sites/MulderT/Kennis/Verkeersborden/5. Schouwrapporten';
            const pleeglocatiesPad = 'https://som.org.om.local/sites/MulderT/Kennis/Algemeen/4. Pleeglocaties';
            
            if (contentTypeFilter === 'schouwrapporten') {
                // SCHOUWRAPPORTEN FILTER: Zoek ALLEEN in Schouwrapporten folder
                kqlQuery = `${query} AND Path:"${schouwrapportenPad}*"`;
                
                // Sluit ASPX pagina's uit
                kqlQuery += ` AND NOT FileType:aspx`;
                
                // Alleen echte document types
                const toegestaneTypes = ['doc','docx','xls','xlsx','ppt','pptx','pdf','txt','rtf'];
                const typeFilter = toegestaneTypes.map(ext => `FileType:${ext}`).join(' OR ');
                kqlQuery += ` AND (${typeFilter})`;
                
                console.log('[KQL] Schouwrapporten query:', kqlQuery);
                
            } else if (contentTypeFilter === 'pleeglocaties') {
                // BIJZONDERE PLEEGLOCATIES FILTER: Zoek ALLEEN in Pleeglocaties folder
                kqlQuery = `${query} AND Path:"${pleeglocatiesPad}*"`;
                
                // Sluit ASPX pagina's uit
                kqlQuery += ` AND NOT FileType:aspx`;
                
                // Alleen echte document types
                const toegestaneTypes = ['doc','docx','xls','xlsx','ppt','pptx','pdf','txt','rtf'];
                const typeFilter = toegestaneTypes.map(ext => `FileType:${ext}`).join(' OR ');
                kqlQuery += ` AND (${typeFilter})`;
                
                console.log('[KQL] Bijzondere Pleeglocaties query:', kqlQuery);
                
            } else if (contentTypeFilter === 'weekmail') {
                // WEEKMAIL FILTER: Zoek alleen in SitePages met "Weekmail" in titel/content
                const weekmailBasePath = '/sites/MulderT/Onderdelen/beoordelen';
                
                // Check of er een specifieke categorie geselecteerd is
                let weekmailPathFilter = '';
                if (filters.weekmailCategorie === 'beoordelen') {
                    // Speciaal geval: alleen hoofdmap beoordelen (geen subdirectories)
                    // We zoeken in beoordelen maar NIET in de submappen
                    weekmailPathFilter = `Path:"https://som.org.om.local${weekmailBasePath}/*" AND NOT Path:"https://som.org.om.local${weekmailBasePath}/*/*"`;
                    console.log('[KQL] Alleen beoordelen hoofdmap (geen submappen)');
                } else if (filters.weekmailCategorie) {
                    // Specifieke categorie: zoek alleen in die subfolder
                    weekmailPathFilter = `Path:"https://som.org.om.local${weekmailBasePath}/${filters.weekmailCategorie}*"`;
                    console.log('[KQL] Weekmail categorie geselecteerd:', filters.weekmailCategorie);
                } else {
                    // Geen specifieke categorie: zoek in hele beoordelen folder (inclusief alle submappen)
                    weekmailPathFilter = `Path:"https://som.org.om.local${weekmailBasePath}*"`;
                    console.log('[KQL] Alle weekmail categorieën');
                }
                
                // ContentType moet "Sitepagina" of FileType moet "aspx" zijn
                const sitePageFilter = `(ContentType:"Sitepagina" OR FileType:aspx) AND ${weekmailPathFilter}`;
                
                // Als de zoekterm "weekmail" is, zoek dan gewoon naar alle weekmail pagina's
                if (query.toLowerCase() === 'weekmail') {
                    kqlQuery = `Weekmail AND ${sitePageFilter}`;
                } else {
                    // Combineer zoekterm met weekmail filter
                    kqlQuery = `${query} AND Weekmail AND ${sitePageFilter}`;
                }
                
                console.log('[KQL] Weekmail query:', kqlQuery);
                
            } else if (contentTypeFilter === 'alle') {
                // ALLE CONTENT: Geen bestandstype filters
                kqlQuery = `${query} AND ${pathFilter}`;
                console.log('[KQL] Alles query:', kqlQuery);
                
            } else {
                // DOCUMENTEN FILTER (standaard): Zoals voorheen MAAR met uitzonderingen
                kqlQuery = `${query} AND ${pathFilter}`;
                
                // Sluit ASPX pagina's uit
                kqlQuery += ` AND NOT FileType:aspx`;
                
                // BELANGRIJK: Sluit schouwrapporten en pleeglocaties uit van normale documenten zoeken
                kqlQuery += ` AND NOT Path:"${schouwrapportenPad}*"`;
                kqlQuery += ` AND NOT Path:"${pleeglocatiesPad}*"`;
                
                // Alleen echte document types
                const toegestaneTypes = ['doc','docx','xls','xlsx','ppt','pptx','pdf','txt','rtf'];
                const typeFilter = toegestaneTypes.map(ext => `FileType:${ext}`).join(' OR ');
                kqlQuery += ` AND (${typeFilter})`;
                
                console.log('[KQL] Documenten query (met uitzonderingen):', kqlQuery);
            }
            
            // Stap 4: Extra gebruiker filters (alleen voor documenten en alle content)
            // Stap 4: Extra gebruiker filters (alleen voor documenten, schouwrapporten, pleeglocaties en alle content)
            if (contentTypeFilter !== 'weekmail') {
                if (filters.fileType) {
                    const sanitizedFileType = filters.fileType.replace(/[^a-zA-Z0-9]/g, '');
                    if (sanitizedFileType) {
                        kqlQuery += ` AND FileType:${sanitizedFileType}`;
                        console.log('[KQL] FileType filter toegevoegd:', sanitizedFileType);
                    }
                }
            }
            
            if (filters.author) {
                const sanitizedAuthor = filters.author.replace(/"/g, '\\"');
                if (sanitizedAuthor) {
                    kqlQuery += ` AND Author:"${sanitizedAuthor}"`;
                    console.log('[KQL] Author filter toegevoegd:', sanitizedAuthor);
                }
            }
            
            console.log('[KQL] Complete finale query:', kqlQuery);
            
            const selectProperties = 'Title,Path,HitHighlightedSummary,LastModifiedTime,Author,FileType,Filename,ContentType';
            const apiUrl = `${zoekApiUrl}?querytext='${encodeURIComponent(kqlQuery)}'&selectproperties='${encodeURIComponent(selectProperties)}'&rowlimit=50`;
            
            console.log('[API] Volledige URL:', apiUrl);

            // Make the API call (zoals in werkende versie)
            fetch(apiUrl, {
                method: 'GET',
                headers: {
                    'Accept': 'application/json;odata=verbose'
                }
            })
            .then(response => {
                console.log('[API] Response status:', response.status);
                console.log('[API] Response OK:', response.ok);
                console.log('[API] Response headers:', response.headers);
                
                if (!response.ok) {
                    // Log meer details bij fouten
                    console.error('[API] HTTP Error:', response.status, response.statusText);
                    return response.text().then(text => {
                        console.error('[API] Error response body:', text);
                        throw new Error(`HTTP error! status: ${response.status} - ${response.statusText}`);
                    });
                }
                return response.json();
            })
            .then(data => {
                console.log('[API] Raw data ontvangen:', data);
                
                // Check data structuur
                if (data.d) {
                    console.log('[API] d property:', data.d);
                    if (data.d.query) {
                        console.log('[API] query property:', data.d.query);
                        if (data.d.query.PrimaryQueryResult) {
                            console.log('[API] PrimaryQueryResult:', data.d.query.PrimaryQueryResult);
                            if (data.d.query.PrimaryQueryResult.RelevantResults) {
                                console.log('[API] RelevantResults:', data.d.query.PrimaryQueryResult.RelevantResults);
                                const totalResults = data.d.query.PrimaryQueryResult.RelevantResults.TotalRows;
                                console.log('[API] Totaal aantal resultaten:', totalResults);
                            }
                        }
                    }
                }
                
                if (data.d && data.d.query && data.d.query.PrimaryQueryResult) {
                    const results = data.d.query.PrimaryQueryResult.RelevantResults.Table.Rows.results;
                    console.log('[API] Aantal resultaten gevonden:', results.length);
                    console.log('[API] Eerste resultaat (indien beschikbaar):', results[0]);
                    processAndDisplayResults(results, query, filters);
                } else {
                    console.warn('[API] Data structuur niet zoals verwacht');
                    displayNoResults();
                }
            })
            .catch(error => {
                console.error('[API] Fout opgetreden:', error);
                console.error('[API] Error stack:', error.stack);
                displayNoResults();
            });
        }

        // Helper functie om cel waarde op te halen (zoals in werkende versie)
        function getCelWaarde(cellenArray, propertyNaam) {
            const cel = cellenArray.find(c => c.Key === propertyNaam);
            return cel ? cel.Value : null;
        }

        // Process results with advanced ranking algorithm
        function processAndDisplayResults(rawResults, query, filters) {
            const queryLower = query.toLowerCase();
            const queryTerms = queryLower.split(/\s+/).filter(term => term.length > 0);

            // Transform SharePoint results to our format (gebruik juiste veldnamen)
            const results = rawResults.map(item => {
                const cells = item.Cells.results;
                
                return {
                    title: getCelWaarde(cells, 'Title') || 'Geen titel',
                    url: getCelWaarde(cells, 'Path') || '#',
                    snippet: getCelWaarde(cells, 'HitHighlightedSummary') || '',
                    author: getCelWaarde(cells, 'Author') || 'Onbekend',
                    modified: getCelWaarde(cells, 'LastModifiedTime') || '',
                    fileType: getCelWaarde(cells, 'FileType') || 'aspx'
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

                        // Fuzzy matching - check for word boundary matches with partial term
                        if (term.length >= 4) {
                            // Match words that start with the term (minus last char) as whole words
                            const fuzzyPattern = '\\b' + escapeRegex(term.substring(0, term.length - 1));
                            const fuzzyRegex = new RegExp(fuzzyPattern, 'gi');
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

            resultsCount.textContent = `${results.length} resultaat${results.length !== 1 ? 'en' : ''} gevonden voor "${query}"`;

            let html = '';
            results.forEach(result => {
                const badgeClass = result.matchType === 'exact' ? 'badge-exact' : 
                                 result.matchType === 'almost' ? 'badge-almost' : 'badge-related';
                const badgeText = result.matchType === 'exact' ? 'EXACTE MATCH' : 
                                result.matchType === 'almost' ? 'BIJNA EXACT' : 'GERELATEERD';

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
            console.log('[Display] Toon "geen resultaten" bericht');
            document.getElementById('resultsCount').textContent = 'Geen resultaten gevonden';
            document.getElementById('resultsContent').innerHTML = `
                <div class="no-results">
                    <h3>Geen resultaten gevonden</h3>
                    <p>Probeer andere zoekwoorden of verwijder enkele filters</p>
                    <p><strong>Debug info:</strong> Check de browser console (F12) voor technische details</p>
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
            if (!dateString) return 'Onbekende datum';

            const date = new Date(dateString);
            const now = new Date();
            const diffTime = Math.abs(now - date);
            const diffDays = Math.floor(diffTime / (1000 * 60 * 60 * 24));

            if (diffDays === 0) return 'Vandaag';
            if (diffDays === 1) return 'Gisteren';
            if (diffDays < 7) return `${diffDays} dagen geleden`;
            if (diffDays < 30) return `${Math.floor(diffDays / 7)} weken geleden`;
            if (diffDays < 365) return `${Math.floor(diffDays / 30)} maanden geleden`;

            return date.toLocaleDateString('nl-NL');
        }

        // Mockdata voor demonstratie (fallback wanneer SharePoint API niet beschikbaar is)
        function useMockData(query, filters) {
            const mockResults = [
                {
                    title: 'MulderT Project Documentatie',
                    url: 'https://som.org.om.local/sites/MulderT/Documents/project-docs.docx',
                    snippet: 'Volledige project documentatie voor het MulderT initiatief inclusief doelstellingen en planning.',
                    author: 'T. Mulder',
                    modified: '2025-11-01T10:30:00Z',
                    fileType: 'docx'
                },
                {
                    title: 'Proces Handleiding MulderT',
                    url: 'https://som.org.om.local/sites/MulderT/SitePages/process-guide.aspx',
                    snippet: 'Stap-voor-stap handleiding voor de MulderT werkprocessen en procedures.',
                    author: 'J. de Vries',
                    modified: '2025-10-28T14:20:00Z',
                    fileType: 'aspx'
                },
                {
                    title: 'Maandrapport Oktober 2025',
                    url: 'https://som.org.om.local/sites/MulderT/Reports/monthly-report-oct.pdf',
                    snippet: 'Overzicht van prestaties en activiteiten in oktober 2025 voor het MulderT project.',
                    author: 'A. Bakker',
                    modified: '2025-10-31T09:15:00Z',
                    fileType: 'pdf'
                },
                {
                    title: 'Team Contact Lijst',
                    url: 'https://som.org.om.local/sites/MulderT/Lists/Contacts/AllItems.aspx',
                    snippet: 'Contactgegevens van alle teamleden betrokken bij het MulderT project.',
                    author: 'Systeem',
                    modified: '2025-11-05T16:45:00Z',
                    fileType: 'aspx'
                },
                {
                    title: 'Vergadering Notities November',
                    url: 'https://som.org.om.local/sites/MulderT/Documents/meeting-notes-nov.docx',
                    snippet: 'Notities van de teamvergaderingen in november 2025 met actiepunten en beslissingen.',
                    author: 'T. Mulder',
                    modified: '2025-11-04T11:00:00Z',
                    fileType: 'docx'
                },
                {
                    title: 'Subsite Planning Portal',
                    url: 'https://som.org.om.local/sites/MulderT/Planning/default.aspx',
                    snippet: 'Planning en tijdlijn overzicht voor alle MulderT gerelateerde activiteiten en mijlpalen.',
                    author: 'Planning Team',
                    modified: '2025-11-02T13:30:00Z',
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
