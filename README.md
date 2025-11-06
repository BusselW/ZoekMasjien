# ZoekMasjien

**ZoekMasjien** is een modern, volledig-breed zoekcentrum ontworpen voor SharePoint Server 2019. Het beschikt over een geavanceerd ranking-algoritme dat zoekresultaten prioriteert op basis van match-kwaliteit: Exact > Bijna Exact > Gerelateerd.

## Functies

- ✨ **Schoon, Modern Ontwerp**: Volledig-breed layout met responsief design
- 🎯 **Geavanceerd Ranking-Algoritme**: Prioriteert exacte matches, dan bijna exacte, dan gerelateerde resultaten
- 🔍 **Uitgebreide Filters**: Filter op bestandstype, auteur, datumbereik en site
- 📊 **Visuele Match Indicatoren**: Kleurgecodeerde badges tonen match-kwaliteit in één oogopslag
- ⚡ **Snel & Responsief**: Geoptimaliseerd voor snelle zoekopdrachten en soepele gebruikerservaring
- 🔌 **SharePoint Integratie**: Werkt naadloos samen met SharePoint 2019 REST API

## Snel Starten

### Demo Versie (Geen SharePoint Vereist)
Open `demo.html` in elke webbrowser om het zoekcentrum in actie te zien met mock data.

### SharePoint Implementatie
1. Upload `search-center.aspx` naar uw SharePoint site (bijv. `/SitePages/`)
2. Navigeer naar de pagina URL
3. Begin met zoeken!

## Bestanden

- **search-center.aspx**: Volledige SharePoint 2019 ASPX pagina met REST API integratie
- **demo.html**: Standalone HTML demo versie met mock data
- **IMPLEMENTATION.md**: Gedetailleerde implementatie handleiding en documentatie

## Ranking Algoritme

De zoekmachine gebruikt een drie-lagen systeem:

1. **Exacte Match** (🟢 Groene Badge): Titel of inhoud komt exact overeen met de zoekopdracht
2. **Bijna Exact** (🟠 Oranje Badge): Alle zoektermen aanwezig in titel of inhoud
3. **Gerelateerd** (🔵 Blauwe Badge): Gedeeltelijke matches en fuzzy term matching

## Documentatie

Zie [IMPLEMENTATION.md](IMPLEMENTATION.md) voor:
- Gedetailleerde functie beschrijvingen
- Installatie instructies
- Gebruikshandleiding
- Technische documentatie
- Aanpassingsopties
- Probleemoplossing tips

## Screenshots

Probeer deze test zoekopdrachten in de demo:
- "SharePoint Server 2019" - Zie exacte match ranking
- "SharePoint 2019" - Zie bijna exacte matching
- "zoeken" - Zie gerelateerde resultaten

## Vereisten

- SharePoint Server 2019 (voor productie gebruik)
- Moderne webbrowser (Edge, Chrome, Firefox, Safari)
- SharePoint Search Service moet geconfigureerd zijn en draaien

## Licentie

Dit project wordt aangeboden zoals het is voor gebruik met SharePoint Server 2019 omgevingen.
