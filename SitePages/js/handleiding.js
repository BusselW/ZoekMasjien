// js/handleiding.js
document.addEventListener('DOMContentLoaded', () => {
    console.log('[Handleiding] Script geladen.');

    // DOM-elementen voor de handleiding
    const startHandleidingKnop = document.getElementById('startHandleidingKnop');
    const handleidingOverlay = document.getElementById('handleidingOverlay');
    const handleidingModal = document.getElementById('handleidingModal');
    const sluitHandleidingKnop = document.getElementById('sluitHandleidingKnop');
    const handleidingTitelEl = document.getElementById('handleidingTitel');
    const handleidingTekstEl = document.getElementById('handleidingTekst');
    const handleidingStapIndicatorEl = document.getElementById('handleidingStapIndicator');
    const handleidingVorigeKnop = document.getElementById('handleidingVorigeKnop');
    const handleidingVolgendeKnop = document.getElementById('handleidingVolgendeKnop');

    // DOM-elementen van de zoekpagina
    const zoekTipsContainerEl = document.getElementById('zoekTipsContainer');
    const zoekTipsHeaderEl = document.getElementById('zoekTipsHeader'); 
    const zoekTipsLijstEl = document.getElementById('zoekTipsLijst'); 
    const zoekInvoerElHandleiding = document.getElementById('zoekInvoer'); 
    const filterOptieWrapperEl = document.getElementById('filterOptieWrapper'); 
    const filterOptieElHandleiding = document.getElementById('filterOptie'); 
    const zoekKnopElHandleiding = document.getElementById('zoekKnop'); 
    const resultatenContainerElHandleiding = document.getElementById('resultatenContainer'); 
    const zoekInputContainerEl = document.getElementById('zoekInputContainer'); 

    let huidigeStapIndex = 0;
    let highlightElements = []; // Array voor meerdere highlight divs

    const stappen = [
        {
            titel: "Welkom bij de Zoekmachine!",
            tekst: "Deze handleiding helpt je op weg met het effectief gebruiken van de zoekmachine. Klik op 'Volgende' om te beginnen.",
            elementIds: null // Kan null, string, of array van strings zijn
        },
        {
            titel: "Handige Zoektips",
            tekst: "Bekijk de 'Handige zoektips' voor geavanceerde zoekmogelijkheden. Je kunt deze sectie uit- en inklappen door op de titel te klikken.",
            elementIds: 'zoekTipsContainer',
            preAction: () => {
                if (zoekTipsLijstEl && zoekTipsHeaderEl && zoekTipsLijstEl.classList.contains('ingeklapt')) {
                    zoekTipsHeaderEl.click(); 
                }
            }
        },
        {
            titel: "Trefwoorden Invoeren",
            tekst: "Voer hier je zoekterm(en) in. Wees zo specifiek mogelijk voor de beste resultaten.",
            elementIds: 'zoekInvoer'
        },
        {
            titel: "Filteren op Type",
            tekst: "Gebruik dit dropdown-menu om je zoekresultaten te filteren op een specifiek type content, zoals 'Documenten', 'Schouwrapporten', etc.",
            elementIds: 'filterOptieWrapper'
        },
        {
            titel: "Voorbeeld 1: Documenten Zoeken (Actie)",
            tekst: "We vullen nu 'Verkeersborden' in bij trefwoorden en selecteren 'Documenten' als filter. Let op hoe de velden worden aangepast.",
            elementIds: 'zoekInputContainer',
            preAction: () => {
                if (zoekInvoerElHandleiding) zoekInvoerElHandleiding.value = 'Verkeersborden';
                if (filterOptieElHandleiding) filterOptieElHandleiding.value = 'documenten';
                if (resultatenContainerElHandleiding) resultatenContainerElHandleiding.innerHTML = '';
                if (typeof verbergStatusBericht === 'function') verbergStatusBericht();
            },
            postAction: null 
        },
        {
            titel: "Voorbeeld 1: Documenten Zoeken (Resultaat)",
            tekst: "De zoekopdracht voor 'Verkeersborden' (gefilterd op 'Documenten') is uitgevoerd. Je ziet hieronder de resultaten (indien gevonden) en de zoekbalk blijft zichtbaar.",
            elementIds: ['zoekInputContainer', 'resultatenContainer'], // Highlight beide
            focusElementId: 'zoekInputContainer', // Scroll naar zoekbalk
            preAction: async () => {
                if (zoekInvoerElHandleiding) zoekInvoerElHandleiding.value = 'Verkeersborden'; 
                if (filterOptieElHandleiding) filterOptieElHandleiding.value = 'documenten'; 
                if (typeof voerZoekopdrachtUit === 'function') {
                    if (typeof toonStatusBericht === 'function') toonStatusBericht('Voorbeeldzoekopdracht wordt uitgevoerd...', 'info');
                    await voerZoekopdrachtUit(); 
                } else {
                    console.error('[Handleiding] Functie voerZoekopdrachtUit niet gevonden.');
                }
            },
            postAction: () => { 
                if (zoekInvoerElHandleiding) zoekInvoerElHandleiding.value = '';
                if (resultatenContainerElHandleiding) resultatenContainerElHandleiding.innerHTML = '';
                if (typeof verbergStatusBericht === 'function') verbergStatusBericht();
            }
        },
        {
            titel: "Voorbeeld 2: Weekmail Zoeken (Actie)",
            tekst: "Nu vullen we 'Verkeersborden' in en selecteren 'Weekmail'.",
            elementIds: 'zoekInputContainer',
            preAction: () => {
                if (zoekInvoerElHandleiding) zoekInvoerElHandleiding.value = 'Verkeersborden';
                if (filterOptieElHandleiding) filterOptieElHandleiding.value = 'weekmail';
                if (resultatenContainerElHandleiding) resultatenContainerElHandleiding.innerHTML = '';
                if (typeof verbergStatusBericht === 'function') verbergStatusBericht();
            },
            postAction: null
        },
        {
            titel: "Voorbeeld 2: Weekmail Zoeken (Resultaat)",
            tekst: "De zoekopdracht voor 'Verkeersborden' (gefilterd op 'Weekmail') is uitgevoerd. De resultaten zijn nu voornamelijk sitepagina's.",
            elementIds: ['zoekInputContainer', 'resultatenContainer'], 
            focusElementId: 'zoekInputContainer',
            preAction: async () => {
                if (zoekInvoerElHandleiding) zoekInvoerElHandleiding.value = 'Verkeersborden';
                if (filterOptieElHandleiding) filterOptieElHandleiding.value = 'weekmail';
                 if (typeof voerZoekopdrachtUit === 'function') {
                    if (typeof toonStatusBericht === 'function') toonStatusBericht('Voorbeeldzoekopdracht wordt uitgevoerd...', 'info');
                    await voerZoekopdrachtUit();
                }
            },
            postAction: () => {
                if (zoekInvoerElHandleiding) zoekInvoerElHandleiding.value = '';
                if (resultatenContainerElHandleiding) resultatenContainerElHandleiding.innerHTML = '';
                if (typeof verbergStatusBericht === 'function') verbergStatusBericht();
            }
        },
        {
            titel: "Voorbeeld 3: Schouwrapporten Zoeken (Actie)",
            tekst: "Als laatste voorbeeld zoeken we op 'Amsterdam' en filteren we op 'Schouwrapporten'.",
            elementIds: 'zoekInputContainer',
            preAction: () => {
                if (zoekInvoerElHandleiding) zoekInvoerElHandleiding.value = 'Amsterdam';
                if (filterOptieElHandleiding) filterOptieElHandleiding.value = 'schouwrapporten';
                if (resultatenContainerElHandleiding) resultatenContainerElHandleiding.innerHTML = '';
                if (typeof verbergStatusBericht === 'function') verbergStatusBericht();
            },
            postAction: null
        },
        {
            titel: "Voorbeeld 3: Schouwrapporten Zoeken (Resultaat)",
            tekst: "De zoekopdracht voor 'Amsterdam' (gefilterd op 'Schouwrapporten') is uitgevoerd. Dit filter zoekt specifiek binnen de mapstructuur voor schouwrapporten.",
            elementIds: ['zoekInputContainer', 'resultatenContainer'], 
            focusElementId: 'zoekInputContainer',
            preAction: async () => {
                if (zoekInvoerElHandleiding) zoekInvoerElHandleiding.value = 'Amsterdam';
                if (filterOptieElHandleiding) filterOptieElHandleiding.value = 'schouwrapporten';
                 if (typeof voerZoekopdrachtUit === 'function') {
                    if (typeof toonStatusBericht === 'function') toonStatusBericht('Voorbeeldzoekopdracht wordt uitgevoerd...', 'info');
                    await voerZoekopdrachtUit();
                }
            },
            postAction: () => {
                if (zoekInvoerElHandleiding) zoekInvoerElHandleiding.value = '';
                if (resultatenContainerElHandleiding) resultatenContainerElHandleiding.innerHTML = '';
                if (typeof verbergStatusBericht === 'function') verbergStatusBericht();
            }
        },
        {
            titel: "Einde Handleiding",
            tekst: "Je hebt de handleiding voltooid! Je kunt nu zelfstandig de zoekmachine gebruiken. Klik op 'Voltooien' om de handleiding te sluiten.",
            elementIds: null
        }
    ];

    function maakHighlightElement() {
        const div = document.createElement('div');
        div.className = 'handleiding-highlight';
        document.body.appendChild(div);
        return div;
    }

    function verwijderHighlights() { // Hernoemd naar meervoud
        highlightElements.forEach(hl => hl.remove());
        highlightElements = [];
    }

    function updateHighlight(elementIdOrIds, focusElementId = null) {
        verwijderHighlights(); 
        if (!elementIdOrIds) return;

        const idsToHighlight = Array.isArray(elementIdOrIds) ? elementIdOrIds : [elementIdOrIds];
        let firstTargetElement = null;

        idsToHighlight.forEach((id, index) => {
            const targetElement = document.getElementById(id);
            if (targetElement) {
                if (index === 0) { // Sla het eerste element op voor mogelijke focus
                    firstTargetElement = targetElement;
                }
                const highlightDiv = maakHighlightElement();
                const rect = targetElement.getBoundingClientRect();
                const scrollX = window.scrollX || window.pageXOffset;
                const scrollY = window.scrollY || window.pageYOffset;

                highlightDiv.style.top = `${rect.top + scrollY - 5}px`; 
                highlightDiv.style.left = `${rect.left + scrollX - 5}px`;
                highlightDiv.style.width = `${rect.width + 10}px`;
                highlightDiv.style.height = `${rect.height + 10}px`;
                highlightElements.push(highlightDiv); // Voeg toe aan de array
            } else {
                console.warn(`[Handleiding] Element met ID '${id}' niet gevonden voor highlighting.`);
            }
        });

        // Bepaal welk element de scroll-focus krijgt
        const elementToFocus = focusElementId ? document.getElementById(focusElementId) : firstTargetElement;

        if (elementToFocus) {
            setTimeout(() => {
                const currentTarget = document.getElementById(elementToFocus.id); // Her-verkrijg element voor het geval DOM is veranderd
                if (currentTarget && currentTarget.offsetParent !== null) {
                    currentTarget.scrollIntoView({ behavior: 'smooth', block: 'center', inline: 'nearest' });
                }
            }, 50); 
        }
    }
    
    async function toonStap(stapIndex) {
        if (stapIndex < 0 || stapIndex >= stappen.length) {
            console.warn('[Handleiding] Ongeldige stapindex:', stapIndex);
            return;
        }
        const stap = stappen[stapIndex];

        verwijderHighlights(); 

        if (stap.preAction) {
            if (handleidingModal) handleidingModal.classList.add('bezig');
            await stap.preAction(); 
            if (handleidingModal) handleidingModal.classList.remove('bezig');
        }

        if(handleidingTitelEl) handleidingTitelEl.textContent = stap.titel;
        if(handleidingTekstEl) handleidingTekstEl.innerHTML = stap.tekst; 
        if(handleidingStapIndicatorEl) handleidingStapIndicatorEl.textContent = `Stap ${stapIndex + 1} / ${stappen.length}`;

        updateHighlight(stap.elementIds, stap.focusElementId); // Geef ook focusElementId mee

        if(handleidingVorigeKnop) handleidingVorigeKnop.disabled = stapIndex === 0;
        if(handleidingVolgendeKnop) {
            if (stapIndex === stappen.length - 1) {
                handleidingVolgendeKnop.textContent = 'Voltooien';
            } else {
                handleidingVolgendeKnop.textContent = 'Volgende';
            }
        }
    }

    function startHandleiding() {
        console.log('[Handleiding] Gestart.');
        huidigeStapIndex = 0;
        if (handleidingOverlay) handleidingOverlay.style.display = 'flex';
        document.body.classList.add('handleiding-actief');
        toonStap(huidigeStapIndex); 
    }

    function sluitHandleiding() {
        console.log('[Handleiding] Gesloten.');
        if (handleidingOverlay) handleidingOverlay.style.display = 'none';
        verwijderHighlights();
        document.body.classList.remove('handleiding-actief');
        
        const laatsteStap = stappen[huidigeStapIndex]; 
        if (laatsteStap && laatsteStap.postAction) {
            Promise.resolve(laatsteStap.postAction()).catch(err => console.error("[Handleiding] Fout in postAction bij sluiten:", err));
        }
        
        if (zoekInvoerElHandleiding) zoekInvoerElHandleiding.value = '';
        if (filterOptieElHandleiding) filterOptieElHandleiding.value = 'documenten'; 
        if (resultatenContainerElHandleiding) resultatenContainerElHandleiding.innerHTML = '';
        if (typeof verbergStatusBericht === 'function') verbergStatusBericht();
    }

    async function gaNaarVolgendeStap() {
        const huidigeStapDef = stappen[huidigeStapIndex];
        if (huidigeStapDef && huidigeStapDef.postAction) {
            if (handleidingModal) handleidingModal.classList.add('bezig');
            await huidigeStapDef.postAction();
            if (handleidingModal) handleidingModal.classList.remove('bezig');
        }

        if (huidigeStapIndex < stappen.length - 1) {
            huidigeStapIndex++;
            await toonStap(huidigeStapIndex); 
        } else {
            sluitHandleiding();
        }
    }

    async function gaNaarVorigeStap() {
        const huidigeStapDef = stappen[huidigeStapIndex];
        if (huidigeStapDef && huidigeStapDef.postAction) { 
            if (handleidingModal) handleidingModal.classList.add('bezig');
            await huidigeStapDef.postAction();
            if (handleidingModal) handleidingModal.classList.remove('bezig');
        }

        if (huidigeStapIndex > 0) {
            huidigeStapIndex--;
            await toonStap(huidigeStapIndex); 
        }
    }

    if (startHandleidingKnop) {
        startHandleidingKnop.addEventListener('click', startHandleiding);
    } else {
        console.warn('[Handleiding] Startknop (#startHandleidingKnop) niet gevonden op de pagina.');
    }

    if (sluitHandleidingKnop) {
        sluitHandleidingKnop.addEventListener('click', sluitHandleiding);
    }
    if (handleidingVolgendeKnop) {
        handleidingVolgendeKnop.addEventListener('click', gaNaarVolgendeStap);
    }
    if (handleidingVorigeKnop) {
        handleidingVorigeKnop.addEventListener('click', gaNaarVorigeStap);
    }
    
    if (handleidingOverlay) {
        handleidingOverlay.addEventListener('click', (event) => {
            if (event.target === handleidingOverlay) {
                sluitHandleiding();
            }
        });
    }
});
