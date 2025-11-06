<!DOCTYPE html>
<html lang="nl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Zoekmachine</title>
    <link rel="stylesheet" href="css/zoeken.css">
    <link rel="stylesheet" href="css/handleiding.css">
    <link rel="icon" href="/sites/MulderT/Zoeken/favicon.svg" type="image/svg+xml">
    <style>
        /* Basisstijlen voor sticky footer */
        html, body {
            height: 100%;
            margin: 0;
        }
        body {
            display: flex;
            flex-direction: column;
        }
        .main-content {
            flex-grow: 1; 
        }
        .site-footer {
            flex-shrink: 0; 
            padding: 1em 0;
            text-align: center;
            background-color: #f0f0f0; 
            border-top: 1px solid #ddd; 
        }

        .zoek-sectie-titel-container {
            display: flex;
            justify-content: space-between;
            align-items: center; 
            margin-bottom: 10px; 
        }

        /* Algemene .admin-knop stijl */
        .admin-knop {
            background-color: #005A9C; /* Standaard blauw */
            color: white;
            border: none;
            padding: 8px 12px;
            text-align: center;
            text-decoration: none;
            display: inline-block;
            font-size: 0.9em;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }
        .admin-knop:hover {
            background-color: #00447C; /* Donkerder blauw bij hover */
        }

        #adminKnoppenContainer .admin-knop { /* Specifiek voor knoppen in de admin container */
            margin-left: 8px;
        }
        #adminKnoppenContainer {
            display: flex; 
        }
        
        .handleiding-start-container {
            margin-top: 10px; 
            margin-bottom: 15px; 
            text-align: left; 
        }

        #startHandleidingKnop { 
             background-color: #28a745; /* Groen voor de Start Handleiding knop */
        }
        #startHandleidingKnop:hover {
            background-color: #218838;
        }
        
        /* Stijl voor kleinere admin knoppen (gebruikt in handleiding modal) */
        .admin-knop.klein {
            padding: 6px 10px;
            font-size: 0.85em;
        }


        /* Stijlen voor zoektips */
        .zoek-tips-container {
            background-color: #f9f9f9;
            border: 1px solid #e0e0e0;
            border-left: 4px solid #007bff; 
            padding: 10px 15px;
            margin-bottom: 20px; 
            border-radius: 5px;
            font-size: 0.9em;
            color: #333;
        }
        .zoek-tips-header { 
            margin-top: 0;
            margin-bottom: 8px;
            color: #005A9C;
            font-size: 1.1em;
            cursor: pointer;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .zoek-tips-header::after { 
            content: '▼'; 
            font-size: 0.8em;
            margin-left: 10px;
            transition: transform 0.3s ease;
        }
        .zoek-tips-header.ingeklapt::after {
            transform: rotate(-90deg); 
        }
        .zoek-tips-container ul {
            margin: 0;
            padding-left: 20px;
            max-height: 1000px; 
            overflow: hidden;
            transition: max-height 0.5s ease-in-out, opacity 0.3s ease-in-out, visibility 0.3s ease-in-out;
            visibility: visible;
            opacity: 1;
        }
        .zoek-tips-container ul.ingeklapt {
            max-height: 0;
            visibility: hidden;
            opacity: 0;
            margin-top: 0; 
            padding-top: 0;
            padding-bottom: 0;
        }
        .zoek-tips-container li {
            margin-bottom: 5px;
        }

        /* Stijlen voor zoekresultaten */
        .resultaat-item .doctype-info {
            display: flex;
            align-items: center;
            gap: 6px; 
        }
        .resultaat-item .doctype-icoon {
            width: 20px; 
            height: 20px;
        }
        .resultaat-item .doctype-tekst {
            font-size: 0.85em;
            color: #555;
        }
        .samenvatting {
            font-size: 0.9em;
            line-height: 1.4;
            max-height: calc(1.4em * 3); 
            overflow: hidden;
            text-overflow: ellipsis;
            display: -webkit-box;
            -webkit-line-clamp: 3;
            -webkit-box-orient: vertical;
        }
        .samenvatting strong { 
            font-weight: bold !important; 
        }


        /* --- Modal Styling (Notificaties) --- */
        #notificatieModalOverlay.modal-overlay { 
            background-color: rgba(0, 0, 0, 0.6); 
        }
        #notificatieModal.modal { 
            background-color: #ffffff;
            border-radius: 8px; 
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
            width: 90%;
            max-width: 500px; 
        }
        #notificatieModal .modal-titel { 
            background-color: #005A9C; 
            color: #ffffff; 
            padding: 12px 15px;
            margin: 0; 
            border-top-left-radius: 8px; 
            border-top-right-radius: 8px;
            font-size: 1.2em;
        }
        #notificatieModal .modal-content { padding: 20px; } 
        #notificatieModal .modal-sluiten-knop { 
            color: #ffffff; 
            opacity: 0.8;
            font-size: 1.8em; 
            line-height: 1;
            padding: 5px 10px; 
            position: absolute;
            top: 10px;
            right: 15px;
            background: none; 
            border: none; 
        }
        #notificatieModal .modal-sluiten-knop:hover { opacity: 1; } 
        
        #notificatieForm .form-groep-modal { margin-bottom: 15px; }
        #notificatieForm .form-groep-modal label {
            display: block;
            margin-bottom: 5px;
            font-weight: normal; 
            color: #333; 
        }
        #notificatieForm .form-groep-modal input[type="text"],
        #notificatieForm .form-groep-modal input[type="date"],
        #notificatieForm .form-groep-modal textarea {
            width: 100%;
            padding: 10px; 
            border: 1px solid #ccc;
            border-radius: 4px;
            box-sizing: border-box;
            font-size: 0.95em;
        }
        #notificatieForm .form-groep-modal textarea {
            resize: vertical;
            min-height: 80px; 
        }
        #notificatieModalBericht { 
            color: #d9534f; 
            margin-top: 10px; 
            margin-bottom: 10px;
            font-size: 0.9em;
            min-height: 1.2em; 
        }
        #notificatieForm .admin-knop { /* Voor Opslaan knop in notificatie modal */
            /* Inherits .admin-knop, kan hier specifiek overschreven worden indien nodig */
        }
        
        .actieve-notificaties-container {
            background-color: #E6F0F7; 
            border: 1px solid #B0C4DE; 
            border-radius: 5px;
            padding: 15px;
            margin-bottom: 20px; 
        }
        .actieve-notificatie-item {
            background-color: #ffffff;
            border: 1px solid #dddddd;
            border-left: 5px solid #005A9C; 
            padding: 10px 15px;
            margin-bottom: 10px;
            border-radius: 4px;
        }
        .actieve-notificatie-item:last-child { margin-bottom: 0; }
        .actieve-notificatie-item h3 {
            margin-top: 0;
            margin-bottom: 5px;
            font-size: 1.1em;
            color: #005A9C; 
        }
        .actieve-notificatie-item p {
            margin-top: 0;
            margin-bottom: 8px;
            font-size: 0.95em;
        }
        .actieve-notificatie-item small {
            font-size: 0.85em;
            color: #555;
        }
    </style>
</head>
<body>
    <header class="site-header">
        <div class="header-content">
            <span class="site-title-header">Zoekmachine</span>
            <nav class="breadcrumbs">
                <a href="#">Home</a> &gt; <span>Zoekmachine</span>
            </nav>
        </div>
    </header>

    <main class="main-content">
        <div id="actieveNotificatiesContainer" class="actieve-notificaties-container" style="display:none;">
            </div>

        <div class="zoek-sectie">
            <div class="zoek-sectie-titel-container">
                <h2>Documenten zoeken</h2>
                <div id="adminKnoppenContainer">
                    <a href="#" id="siteInhoudKnop" class="admin-knop" title="Ga naar site-inhoud">Site-inhoud</a>
                    <a href="#" id="siteInstellingenKnop" class="admin-knop" title="Ga naar site-instellingen">Site-instellingen</a>
                    <a href="#" id="notificatieBeheerKnop" class="admin-knop" title="Nieuwe notificatie toevoegen">Notificatie toevoegen</a>
                    </div>
            </div>
            
            <div class="handleiding-start-container">
                <button id="startHandleidingKnop">Start Handleiding</button> 
            </div>

            <div class="zoek-tips-container" id="zoekTipsContainer"> 
                <h4 class="zoek-tips-header" id="zoekTipsHeader">Handige zoektips:</h4>
                <ul id="zoekTipsLijst">
                    <li>Gebruik <strong>dubbele aanhalingstekens</strong> (bijv. <code>"jaarverslag 2023"</code>) om op een exacte zin te zoeken.</li>
                    <li>Combineer termen met <strong>AND</strong>, <strong>OR</strong>, of <strong>NOT</strong> (in hoofdletters) om je zoekopdracht te specificeren (bijv. <code>rapport AND financieel NOT concept</code>). SharePoint gebruikt vaak automatisch AND.</li>
                    <li>Gebruik een <strong>sterretje (*)</strong> als wildcard aan het einde van een woord (bijv. <code>verkeers*</code> zoekt naar verkeersbord, verkeersplan, etc.).</li>
                    <li>Zoek naar specifieke bestandstypen met <code>filetype:</code> (bijv. <code>presentatie filetype:pptx</code>).</li>
                </ul>
            </div>
            
            <div class="zoek-container">
                <div class="zoek-input-container" id="zoekInputContainer"> 
                    <div class="form-groep">
                        <label for="zoekInvoer">Trefwoorden:</label>
                        <input type="text" id="zoekInvoer" placeholder="Bijv. 'WI Verkeersborden'...">
                    </div>
                    
                    <div class="form-groep">
                        <label for="filterOptie">Filter op:</label>
                        <div class="filter-wrapper" id="filterOptieWrapper"> 
                            <select id="filterOptie">
                                <option value="documenten" selected>Documenten</option> 
                                <option value="schouwrapporten">Schouwrapporten</option>
                                <option value="bijzonderePleeglocaties">Bijzondere Pleeglocaties</option>
                                <option value="weekmail">Weekmail</option>
                            </select>
                            <span class="info-icoon" title="Selecteer een filter om uw zoekopdracht te verfijnen.">i</span>
                        </div>
                    </div>
                    
                    <div class="form-groep zoek-knop-groep">
                        <button id="zoekKnop">Zoeken</button>
                    </div>
                </div>
                <div class="hulp-link-container">
                    <a href="melding/MeldFouten.aspx" id="hulpLink">Kon je iets niet vinden? Meld het hier.</a>
                </div>
                
                <div id="sorteerKnoppenContainer">
                    <button id="sorteerRelevantie" class="sorteer-knop actief">Relevantie</button>
                    <button id="sorteerDatumNieuwOud" class="sorteer-knop">Datum (nieuw-oud)</button>
                    <button id="sorteerDatumOudNieuw" class="sorteer-knop">Datum (oud-nieuw)</button>
                </div>
        
                <div id="statusContainer" class="status-bericht" style="display:none;"></div>
                <div id="resultatenContainer" class="resultaten-container">
                    </div>
            </div>
        </div>
    </main>

    <footer class="site-footer">
        <p>&copy; CVOM - Mulder</p>
    </footer>

    <div id="notificatieModalOverlay" class="modal-overlay" style="display:none;">
         <div id="notificatieModal" class="modal">
            <button id="notificatieModalSluitenKnop" class="modal-sluiten-knop">&times;</button>
            <h3 id="notificatieModalTitel" class="modal-titel">MEDEDELING TOEVOEGEN</h3> 
            <div id="notificatieModalContent" class="modal-content">
                <form id="notificatieForm">
                    <input type="hidden" id="notificatieEditId" name="notificatieEditId">
                    <div class="form-groep-modal">
                        <label for="notificatieTitelInput"><strong>Titel:</strong></label>
                        <input type="text" id="notificatieTitelInput" name="titel" required>
                    </div>
                    <div class="form-groep-modal">
                        <label for="notificatieBeschrijvingInput">Beschrijving:</label>
                        <textarea id="notificatieBeschrijvingInput" name="beschrijving" rows="4" required></textarea>
                    </div>
                    <div class="form-groep-modal">
                        <label for="notificatieStartDatumInput">Startdatum:</label>
                        <input type="date" id="notificatieStartDatumInput" name="startdatum" required>
                    </div>
                    <div class="form-groep-modal">
                        <label for="notificatieEindDatumInput">Einddatum:</label>
                        <input type="date" id="notificatieEindDatumInput" name="einddatum" required>
                    </div>
                    <div id="notificatieModalBericht"></div>
                    <button type="submit" class="admin-knop" style="width: auto;">Opslaan</button>
                </form>
            </div>
        </div>
    </div>

    <div id="handleidingOverlay" class="handleiding-overlay" style="display: none;">
        <div id="handleidingModal" class="handleiding-modal">
            <div id="handleidingHeader" class="handleiding-header">
                <h3 id="handleidingTitel">Handleiding</h3>
                <button id="sluitHandleidingKnop" class="handleiding-sluit-knop">&times;</button>
            </div>
            <div id="handleidingContent" class="handleiding-content">
                <p id="handleidingTekst">Welkom bij de handleiding!</p>
            </div>
            <div id="handleidingFooter" class="handleiding-footer">
                <span id="handleidingStapIndicator">Stap 1 / X</span>
                <div class="handleiding-navigatie">
                    <button id="handleidingVorigeKnop" class="admin-knop klein">Vorige</button>
                    <button id="handleidingVolgendeKnop" class="admin-knop klein">Volgende</button>
                </div>
            </div>
        </div>
    </div>


    <script>
        // Basis URL van uw SharePoint site collectie
        const basisSiteUrl = "https://som.org.om.local/sites/MulderT/"; 
        const iconBaseUrl = "https://som.org.om.local/sites/MulderT/Zoeken/sitepages/Icoontjes/";
        const schouwrapportenPad = "https://som.org.om.local/sites/MulderT/Kennis/Verkeersborden/5.%20Schouwrapporten/";
        const bijzonderePleeglocatiesPad = "https://som.org.om.local/sites/MulderT/Kennis/Algemeen/4. Pleeglocaties/Bijzondere pleeglocaties ZV/";
        const zoekApiUrl = `${basisSiteUrl}_api/search/query`;

        const zoekInvoerEl = document.getElementById('zoekInvoer');
        const zoekKnopEl = document.getElementById('zoekKnop');
        const filterOptieEl = document.getElementById('filterOptie');
        const resultatenContainerEl = document.getElementById('resultatenContainer');
        const statusContainerEl = document.getElementById('statusContainer');
        
        const sorteerKnoppenContainerEl = document.getElementById('sorteerKnoppenContainer');
        const sorteerRelevantieKnop = document.getElementById('sorteerRelevantie');
        const sorteerDatumNieuwOudKnop = document.getElementById('sorteerDatumNieuwOud');
        const sorteerDatumOudNieuwKnop = document.getElementById('sorteerDatumOudNieuw');
        
        const zoekTipsHeaderEl = document.getElementById('zoekTipsHeader');
        const zoekTipsLijstEl = document.getElementById('zoekTipsLijst');


        let origineleResultaten = []; 
        let huidigeWeergegevenResultaten = []; 
        let actieveSorteerOptie = 'relevantie'; 

        function toonStatusBericht(bericht, type = 'info') {
            console.log(`[Status] ${type}: ${bericht}`);
            statusContainerEl.textContent = bericht;
            statusContainerEl.className = `status-bericht ${type}`;
            statusContainerEl.style.display = 'block';
            if (type === 'fout' || bericht.includes('Geen resultaten')) {
                 if(sorteerKnoppenContainerEl) sorteerKnoppenContainerEl.style.display = 'none'; 
            }
        }

        function verbergStatusBericht() {
            statusContainerEl.style.display = 'none';
        }

        function getCelWaarde(cellenArray, propertyNaam) {
            const cel = cellenArray.find(c => c.Key === propertyNaam);
            return cel ? cel.Value : null;
        }

        function getIcoonVoorBestandstype(fileType) {
            if (!fileType) return iconBaseUrl + 'bestand.svg';
            const typeLower = fileType.toLowerCase();
            switch (typeLower) {
                case 'xlsx': case 'xls': return iconBaseUrl + 'Exceldoc.svg';
                case 'pdf': return iconBaseUrl + 'pdfdoc.svg';
                case 'pptx': case 'ppt': return iconBaseUrl + 'ptxdoc.svg'; 
                case 'docx': case 'doc': return iconBaseUrl + 'worddoc.svg'; 
                case 'aspx': return iconBaseUrl + 'bestand.svg'; 
                default: return iconBaseUrl + 'bestand.svg';
            }
        }
        
        function updateActieveSorteerKnop() {
            document.querySelectorAll('.sorteer-knop').forEach(knop => knop.classList.remove('actief'));
            if (!sorteerRelevantieKnop || !sorteerDatumNieuwOudKnop || !sorteerDatumOudNieuwKnop) return;

            if (actieveSorteerOptie === 'relevantie') sorteerRelevantieKnop.classList.add('actief');
            else if (actieveSorteerOptie === 'datumNieuwOud') sorteerDatumNieuwOudKnop.classList.add('actief');
            else if (actieveSorteerOptie === 'datumOudNieuw') sorteerDatumOudNieuwKnop.classList.add('actief');
        }

        function renderResultaten(resultatenArray) {
            resultatenContainerEl.innerHTML = ''; 
            if (!resultatenArray || resultatenArray.length === 0) {
                toonStatusBericht('Geen resultaten gevonden voor uw zoekopdracht.', 'info');
                if(sorteerKnoppenContainerEl) sorteerKnoppenContainerEl.style.display = 'none';
                return;
            }

            verbergStatusBericht();
            if(sorteerKnoppenContainerEl) sorteerKnoppenContainerEl.style.display = 'flex';
            updateActieveSorteerKnop();

            resultatenArray.forEach(item => {
                const cellen = item.Cells.results; 
                const titel = getCelWaarde(cellen, 'Title');
                const pad = getCelWaarde(cellen, 'Path');
                const samenvatting = getCelWaarde(cellen, 'HitHighlightedSummary');
                const auteur = getCelWaarde(cellen, 'Author');
                const laatstGewijzigd = getCelWaarde(cellen, 'LastModifiedTime');
                const fileType = getCelWaarde(cellen, 'FileType'); 
                
                const icoonUrl = getIcoonVoorBestandstype(fileType);
                let laatstGewijzigdDatum = '';
                if (laatstGewijzigd) {
                    try {
                        laatstGewijzigdDatum = new Date(laatstGewijzigd).toLocaleDateString('nl-NL', {
                            year: 'numeric', month: 'long', day: 'numeric', hour: '2-digit', minute: '2-digit'
                        });
                    } catch (e) {
                        console.warn(`[Datum Formattering] Kon datum niet formatteren: ${laatstGewijzigd}`, e);
                        laatstGewijzigdDatum = laatstGewijzigd;
                    }
                }

                const resultaatDiv = document.createElement('div');
                resultaatDiv.className = 'resultaat-item';
                
                let titelHtml = '';
                const bestandsTypeInfo = fileType ? `<span class="doctype-info"><img src="${icoonUrl}" alt="Icoon" class="doctype-icoon"><span class="doctype-tekst">(${fileType.toUpperCase()})</span></span>` : `<span class="doctype-info"><img src="${icoonUrl}" alt="Icoon" class="doctype-icoon"></span>`;

                if (titel && pad) {
                    titelHtml = `<h3>${bestandsTypeInfo} <a href="${pad}" target="_blank">${titel}</a></h3>`;
                } else if (titel) {
                     titelHtml = `<h3>${bestandsTypeInfo} ${titel}</h3>`;
                } else if (pad) { 
                     titelHtml = `<h3>${bestandsTypeInfo} <a href="${pad}" target="_blank">${pad.substring(pad.lastIndexOf('/') + 1)}</a></h3>`;
                } else {
                     titelHtml = `<h3>${bestandsTypeInfo} Geen titel beschikbaar</h3>`;
                }

                let htmlContent = titelHtml; 
                if (pad) {
                     htmlContent += `<p><a href="${pad}" target="_blank" style="word-break: break-all;">${pad}</a></p>`;
                }
                if (auteur) {
                    htmlContent += `<p><strong>Auteur:</strong> ${auteur}</p>`;
                }
                if (laatstGewijzigdDatum) {
                    htmlContent += `<p><strong>Laatst gewijzigd:</strong> ${laatstGewijzigdDatum}</p>`;
                }
                resultaatDiv.innerHTML = htmlContent; 
                if (samenvatting) {
                    const samenvattingP = document.createElement('div');
                    samenvattingP.className = 'samenvatting';
                    samenvattingP.innerHTML = samenvatting; 
                    resultaatDiv.appendChild(samenvattingP);
                }
                resultatenContainerEl.appendChild(resultaatDiv);
            });
        }

        function sorteerEnRenderResultaten(sorteerType) {
            actieveSorteerOptie = sorteerType;
            let teSorterenResultaten = [...huidigeWeergegevenResultaten]; 

            if (sorteerType === 'relevantie') {
                teSorterenResultaten = [...origineleResultaten];
            } else if (sorteerType === 'datumNieuwOud') {
                teSorterenResultaten.sort((a, b) => {
                    const datumA = new Date(getCelWaarde(a.Cells.results, 'LastModifiedTime') || 0);
                    const datumB = new Date(getCelWaarde(b.Cells.results, 'LastModifiedTime') || 0);
                    return datumB - datumA; 
                });
            } else if (sorteerType === 'datumOudNieuw') {
                teSorterenResultaten.sort((a, b) => {
                    const datumA = new Date(getCelWaarde(a.Cells.results, 'LastModifiedTime') || 0);
                    const datumB = new Date(getCelWaarde(b.Cells.results, 'LastModifiedTime') || 0);
                    return datumA - datumB; 
                });
            }
            huidigeWeergegevenResultaten = teSorterenResultaten;
            renderResultaten(huidigeWeergegevenResultaten); 
        }

        async function voerZoekopdrachtUit() {
            const zoekTerm = zoekInvoerEl.value.trim();
            if (!zoekTerm && !document.body.classList.contains('handleiding-actief')) {
                 toonStatusBericht('Voer alstublieft een zoekterm in om te zoeken.', 'fout');
                 if(sorteerKnoppenContainerEl) sorteerKnoppenContainerEl.style.display = 'none';
                 resultatenContainerEl.innerHTML = '';
                 return []; 
            }

            const geselecteerdeFilter = filterOptieEl.value; 
            console.log(`[Filter] Geselecteerde filter: ${geselecteerdeFilter}`);
            verbergStatusBericht();
            resultatenContainerEl.innerHTML = ''; 
            if(sorteerKnoppenContainerEl) sorteerKnoppenContainerEl.style.display = 'none';
            toonStatusBericht('Bezig met zoeken...', 'info');
            
            let kqlQuery = ""; 
            const documentExtensiesLijst = ['doc','docx','xls','xlsx','ppt','pptx','pdf','txt','rtf','odt','ods','odp'];
            const algemeenFileTypeFilter = documentExtensiesLijst.map(ext => `FileType:${ext}`).join(' OR ');

            console.log(`[Zoekopdracht] Starten zoekopdracht voor: "${zoekTerm}" met filter "${geselecteerdeFilter}"`);

            switch (geselecteerdeFilter) {
                case 'documenten':
                    kqlQuery = `(${zoekTerm} AND Path:"${basisSiteUrl}*") AND (${algemeenFileTypeFilter}) AND NOT FileType:aspx AND NOT Path:"${schouwrapportenPad}*" AND NOT Path:"${bijzonderePleeglocatiesPad}*"`;
                    console.log('[KQL Aanpassing] Filter voor documenten toegepast met uitsluiting.');
                    break;
                case 'schouwrapporten':
                    kqlQuery = `(${zoekTerm} AND Path:"${schouwrapportenPad}*") AND (${algemeenFileTypeFilter}) AND NOT FileType:aspx`;
                    console.log(`[KQL Aanpassing] Filter voor Schouwrapporten toegepast.`);
                    break;
                case 'bijzonderePleeglocaties':
                    kqlQuery = `(${zoekTerm} AND Path:"${bijzonderePleeglocatiesPad}*") AND (${algemeenFileTypeFilter}) AND NOT FileType:aspx`;
                    console.log('[KQL Aanpassing] Filter voor Bijzondere Pleeglocaties toegepast.');
                    break;
                case 'weekmail':
                    let weekmailContentSearchTerm = "Weekmail"; 
                    let sitePageFilter = `(ContentType:"Sitepagina" OR FileType:aspx) AND Path:"${basisSiteUrl}*"`;
                    if (zoekTerm.toLowerCase() === weekmailContentSearchTerm.toLowerCase()) {
                        kqlQuery = `(${weekmailContentSearchTerm} AND ${sitePageFilter})`;
                    } else {
                        kqlQuery = `(${zoekTerm} AND ${weekmailContentSearchTerm} AND ${sitePageFilter})`;
                    }
                    console.log('[KQL Aanpassing] Filter voor Weekmail toegepast.');
                    break;
            }
            
            console.log(`[KQL Query - Ruw] De volgende KQL wordt gebruikt: ${kqlQuery}`);
            const selectProperties = 'Title,Path,HitHighlightedSummary,LastModifiedTime,Author,FileType,Filename,ContentType'; 
            const volledigeZoekUrl = `${zoekApiUrl}?querytext='${encodeURIComponent(kqlQuery)}'&selectproperties='${encodeURIComponent(selectProperties)}'&rowlimit=50`; 
            console.log(`[Zoekopdracht] Geconstrueerde API URL: ${volledigeZoekUrl}`);

            try {
                const response = await fetch(volledigeZoekUrl, {
                    method: 'GET',
                    headers: { 'Accept': 'application/json;odata=verbose' }
                });
                console.log(`[API Reactie] Status code: ${response.status}`);
                if (!response.ok) {
                    const foutDetail = await response.text();
                    console.error(`[API Fout] Fout bij het ophalen van zoekresultaten: ${response.statusText}`, foutDetail);
                    toonStatusBericht(`Fout bij het zoeken: ${response.statusText}. Controleer de console.`, 'fout');
                    return []; 
                }
                const data = await response.json();
                console.log('[API Reactie] Data ontvangen:', data);
                let apiResultaten = data?.d?.query?.PrimaryQueryResult?.RelevantResults?.Table?.Rows?.results || [];
                
                origineleResultaten = [...apiResultaten]; 

                if (apiResultaten.length > 0) {
                    if (geselecteerdeFilter === 'documenten') {
                        console.log('[Client Sortering] Starten client-side prioritering voor Kennis sub-sites.');
                        const kennisItems = [];
                        const andereItems = [];
                        apiResultaten.forEach(item => {
                            const pad = getCelWaarde(item.Cells.results, 'Path');
                            if (pad) {
                                const padLower = pad.toLowerCase();
                                if (padLower.startsWith(basisSiteUrl.toLowerCase()) && 
                                    padLower.substring(basisSiteUrl.toLowerCase().length).includes("kennis/") &&
                                    !padLower.startsWith(schouwrapportenPad.toLowerCase()) &&
                                    !padLower.startsWith(bijzonderePleeglocatiesPad.toLowerCase()) ) { 
                                    kennisItems.push(item);
                                } else {
                                    andereItems.push(item);
                                }
                            } else {
                                andereItems.push(item); 
                            }
                        });
                        origineleResultaten = [...kennisItems, ...andereItems]; 
                        console.log(`[Client Sortering] Voltooid. Kennis items: ${kennisItems.length}, Andere items: ${andereItems.length}`);
                    }
                    huidigeWeergegevenResultaten = [...origineleResultaten];
                    actieveSorteerOptie = 'relevantie'; 
                    renderResultaten(huidigeWeergegevenResultaten);
                } else {
                    renderResultaten([]); 
                }
                return apiResultaten; 
            } catch (error) {
                console.error('[Algemene Fout] Er is een fout opgetreden:', error);
                toonStatusBericht(`Er is een technische fout opgetreden: ${error.message}. Controleer de console.`, 'fout');
                return []; 
            }
        }
        
        if (zoekTipsHeaderEl) {
            zoekTipsHeaderEl.addEventListener('click', () => {
                zoekTipsLijstEl.classList.toggle('ingeklapt');
                zoekTipsHeaderEl.classList.toggle('ingeklapt');
            });
            zoekTipsLijstEl.classList.add('ingeklapt');
            zoekTipsHeaderEl.classList.add('ingeklapt');
        }


        zoekKnopEl.addEventListener('click', voerZoekopdrachtUit);
        zoekInvoerEl.addEventListener('keypress', function(event) {
            if (event.key === 'Enter') {
                voerZoekopdrachtUit();
            }
        });
        
        if (sorteerRelevantieKnop) sorteerRelevantieKnop.addEventListener('click', () => sorteerEnRenderResultaten('relevantie'));
        if (sorteerDatumNieuwOudKnop) sorteerDatumNieuwOudKnop.addEventListener('click', () => sorteerEnRenderResultaten('datumNieuwOud'));
        if (sorteerDatumOudNieuwKnop) sorteerDatumOudNieuwKnop.addEventListener('click', () => sorteerEnRenderResultaten('datumOudNieuw'));

        console.log('[Initialisatie] Zoekpagina geladen en scripts geïnitialiseerd.');
        toonStatusBericht('Voer een zoekterm in en klik op "Zoeken". Standaardfilter is "Documenten".', 'info');
        if(sorteerKnoppenContainerEl) sorteerKnoppenContainerEl.style.display = 'none'; 

    </script>
    <script src="js/authenticatie.js" defer></script>
    <script src="js/Notificaties.js" defer></script> 
    <script src="js/handleiding.js" defer></script>
</body>
</html>
