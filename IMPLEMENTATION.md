# ZoekMasjien - SharePoint 2019 Zoekcentrum Implementatie

## Overzicht

Dit is een volledig-brede, standalone zoekcentrum pagina voor SharePoint Server 2019 met een geavanceerd ranking-algoritme dat resultaten prioriteert op basis van match-kwaliteit.

## Functies

### 1. Schoon, Volledig-Breed Ontwerp
- Modern, responsief ontwerp dat werkt op alle schermformaten
- Volledig-brede header met prominente zoekbox
- Card-gebaseerde layout voor resultaten en filters
- Professioneel kleurenschema met vloeiende overgangen

### 2. Geavanceerd Zoek Ranking-Algoritme

De zoekmachine gebruikt een drie-lagen ranking systeem vergelijkbaar met Google:

#### **Exacte Match (1000-800 punten)** - Hoogste Prioriteit
- Titel komt exact overeen met de zoekopdracht
- Titel bevat de volledige zoekfrase
- Inhoud bevat de volledige zoekfrase

#### **Bijna Exacte Match (700-500 punten)** - Gemiddelde Prioriteit
- Alle zoektermen verschijnen in de titel
- Alle zoektermen verschijnen in de inhoud
- Meeste zoektermen komen overeen met hoge frequentie

#### **Gerelateerde Match (0-499 punten)** - Laagste Prioriteit
- Gedeeltelijke term matches
- Fuzzy matching voor vergelijkbare termen
- Term frequentie-gebaseerde relevantie

### 3. Uitgebreide Filters
- **Bestandstype**: Filter op documenttype (Word, Excel, PowerPoint, PDF, Webpagina's)
- **Auteur**: Zoeken op document auteur
- **Datumbereik**: Filter op wijzigingsdatum (Vandaag, Week, Maand, Jaar)
- **Site**: Filter op SharePoint site locatie
- Inklapbaar filter paneel voor schone interface

### 4. Zoekresultaten Weergave
- Kleurgecodeerde badges geven match-kwaliteit aan:
  - 🟢 **Groen** (EXACTE MATCH): Perfecte match
  - 🟠 **Oranje** (BIJNA EXACT): Zeer dichte match
  - 🔵 **Blauw** (GERELATEERD): Gerelateerde inhoud
- Gemarkeerde zoektermen in resultaten
- Rijke metadata (bestandstype, auteur, wijzigingsdatum)
- Doorklik links naar originele documenten

### 5. SharePoint Integratie
- Integreert met SharePoint 2019 REST API
- Fallback naar mock data voor demonstratie
- Ondersteunt SharePoint context (`_spPageContextInfo`)
- Compatibel met SharePoint authenticatie

## Installatie

### Voor SharePoint Server 2019

1. **Upload het bestand**:
   - Upload `search-center.aspx` naar uw SharePoint documentbibliotheek of Site Pages
   - Aanbevolen locatie: `/SitePages/search-center.aspx`

2. **Stel machtigingen in**:
   - Zorg ervoor dat gebruikers leestoegang hebben tot de pagina
   - Verifieer dat de zoekservice draait en geconfigureerd is

3. **Toegang tot de pagina**:
   - Navigeer naar de pagina URL in uw browser
   - Bookmark voor eenvoudige toegang

### Standalone Implementatie

De pagina kan ook werken als een standalone HTML bestand:
1. Opslaan als `search-center.html`
2. Hosten op elke webserver
3. Mock data wordt gebruikt voor demonstratie

## Gebruik

### Basis Zoeken
1. Voer zoektermen in de zoekbox in
2. Druk op Enter of klik op de Zoeken knop
3. Resultaten worden automatisch gerangschikt en weergegeven

### Filters Gebruiken
1. Klap de Filters sectie uit (indien ingeklapt)
2. Selecteer gewenste filter opties
3. Resultaten worden automatisch bijgewerkt
4. Combineer meerdere filters voor precieze resultaten

### Resultaten Begrijpen
- **EXACTE MATCH** badge: Het resultaat komt perfect overeen met uw zoekopdracht
- **BIJNA EXACT** badge: Het resultaat bevat al uw zoektermen
- **GERELATEERD** badge: Het resultaat is gerelateerd aan uw zoektermen
- Resultaten zijn gesorteerd op relevantiescore (hoogste eerst)

## Technische Details

### Ranking Algoritme

Het algoritme berekent een score voor elk resultaat:

```javascript
// Exacte Match
- Titel is exact gelijk aan zoekopdracht: 1000 punten
- Titel bevat volledige zoekopdracht: 900 punten
- Inhoud bevat volledige zoekopdracht: 800 punten

// Bijna Exacte Match
- Alle termen in titel: 700 punten
- Alle termen in inhoud: 600 punten
- Meeste termen met hoge frequentie: 500-599 punten

// Gerelateerde Match
- Gebaseerd op term frequentie: 0-499 punten
- Titel matches: 50 punten per voorkomen
- Inhoud matches: 10 punten per voorkomen
- Fuzzy matches: 5 punten per voorkomen
```

### SharePoint REST API Integratie

De pagina gebruikt de SharePoint Search REST API:
```
/_api/search/query?querytext='[query]'&rowlimit=50
```

Filters worden toegepast met SharePoint zoek query syntax:
- Bestandstype: `FileExtension:docx`
- Auteur: `Author:"Jan Janssen"`
- Pad: `Path:/sites/site1`

### Browser Compatibiliteit
- Microsoft Edge (aanbevolen voor SharePoint)
- Google Chrome
- Mozilla Firefox
- Safari
- Internet Explorer 11 (met beperkingen)

## Aanpassing

### Kleuren Wijzigen
Bewerk de CSS in de `<style>` sectie:
```css
.search-header {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}
```

### Meer Filters Toevoegen
Voeg nieuwe filter groepen toe in de HTML:
```html
<div class="filter-group">
    <label for="newFilter">Nieuw Filter</label>
    <select id="newFilter" onchange="performSearch()">
        <option value="">Alle</option>
    </select>
</div>
```

### Ranking Gewichten Aanpassen
Wijzig de scoring in de `rankResults()` functie:
```javascript
// Verhoog het belang van titel matches
const titleMatches = (titleLower.match(new RegExp(term, 'g')) || []).length;
relatedScore += titleMatches * 100; // Gewijzigd van 50 naar 100
```

## Testen

### Test Cases

1. **Exacte Match Test**:
   - Zoeken: "SharePoint Server 2019"
   - Verwacht: Documenten met exacte titel match verschijnen eerst met groene badge

2. **Bijna Exacte Test**:
   - Zoeken: "SharePoint 2019"
   - Verwacht: Documenten die beide termen bevatten verschijnen met oranje badge

3. **Gerelateerde Test**:
   - Zoeken: "document beheer"
   - Verwacht: Gerelateerde documenten verschijnen met blauwe badge

4. **Filter Test**:
   - Pas bestandstype filter toe op "Word Documenten"
   - Verwacht: Alleen .docx bestanden getoond

5. **Datum Filter Test**:
   - Stel datumbereik in op "Afgelopen Week"
   - Verwacht: Alleen recente documenten getoond

## Probleemoplossing

### Geen Resultaten Gevonden
- Controleer of SharePoint Search Service draait
- Verifieer dat gebruiker machtigingen heeft om inhoud te zoeken
- Probeer bredere zoektermen
- Verwijder filters om resultaten uit te breiden

### Mock Data Verschijnt
- SharePoint REST API is niet toegankelijk
- Controleer browser console voor fouten
- Verifieer dat pagina vanuit SharePoint site wordt benaderd
- Zorg voor juiste authenticatie

### Styling Problemen
- Wis browser cache
- Controleer op CSS conflicten met SharePoint master page
- Verifieer dat pagina laadt in een schoon frame (geen master page)

## Prestaties

- Initiële laadtijd: ~1-2 seconden
- Zoek uitvoering: ~500ms - 2 seconden (afhankelijk van index grootte)
- Resultaten weergave: < 100ms
- Ondersteunt tot 50 resultaten per pagina (configureerbaar)

## Beveiliging

- Gebruikt SharePoint authenticatie
- Geen credentials opgeslagen in pagina
- CORS-compliant REST API calls
- XSS bescherming door juiste escaping
- Geen eval() of gevaarlijke functies gebruikt

## Toekomstige Verbeteringen

Mogelijke verbeteringen:
- Paginering voor grote resultatensets
- Zoek suggesties en autocomplete
- Resultaat previews en thumbnails
- Zoekresultaten exporteren
- Zoekopdrachten opslaan en delen
- Geavanceerde query syntax ondersteuning
- Personen zoek integratie
- Analytics en zoek inzichten

## Ondersteuning

Voor problemen of vragen:
1. Controleer SharePoint logs
2. Verifieer zoekservice configuratie
3. Test eerst met mock data
4. Bekijk browser console fouten

## Licentie

Deze implementatie wordt aangeboden zoals het is voor SharePoint Server 2019 omgevingen.
