// authenticatie.js

document.addEventListener('DOMContentLoaded', function() {
    // De basis URL van de SharePoint site.
    const spSiteContextUrl = (typeof _spPageContextInfo !== 'undefined' && _spPageContextInfo.webAbsoluteUrl) ? _spPageContextInfo.webAbsoluteUrl.replace(/\/$/, "") : "https://som.org.om.local/sites/MulderT"; // Fallback als _spPageContextInfo niet beschikbaar is
    const notificatiesListSiteUrl = "https://som.org.om.local/sites/MulderT/Zoeken"; // Specifieke site voor Notificaties lijst

    const siteInhoudKnop = document.getElementById('siteInhoudKnop');
    const siteInstellingenKnop = document.getElementById('siteInstellingenKnop');
    const notificatieToevoegenKnop = document.getElementById('notificatieToevoegenKnop'); // Nieuwe knop referentie

    // URLs voor de knoppen
    const siteContentsUrl = "https://som.org.om.local/sites/MulderT/Zoeken/_layouts/15/viewlsts.aspx?view=14"; 
    let siteSettingsUrl = `${spSiteContextUrl}/_layouts/15/settings.aspx`; // Gebruik de context van de huidige site voor instellingen
    
    // De URL voor het toevoegen van een nieuw item aan de 'Notificaties' lijst.
    // De lijst bevindt zich op /sites/MulderT/Zoeken/
    const addNotificatieUrl = `${notificatiesListSiteUrl}/Lists/Notificaties/NewForm.aspx`;

    if (siteInhoudKnop) {
        siteInhoudKnop.href = siteContentsUrl; 
        console.log(`[Authenticatie] "Site-inhoud" knop URL ingesteld op: ${siteContentsUrl}`);
    }
    if (siteInstellingenKnop) { 
        siteInstellingenKnop.href = siteSettingsUrl;
        console.log(`[Authenticatie] "Site-instellingen" knop URL ingesteld op: ${siteSettingsUrl}`);
    }
    if (notificatieToevoegenKnop) { // Stel href in voor de nieuwe knop
        notificatieToevoegenKnop.href = addNotificatieUrl;
        console.log(`[Authenticatie] "Notificatie toevoegen" knop URL ingesteld op: ${addNotificatieUrl}`);
    }

    const toegestaneGroepen = [
        "1. Sharepoint beheer",
        "1.1. Mulder MT"
    ];

    /**
     * Haalt de groepen op waar de huidige gebruiker lid van is.
     * Gebruikt de context van de site waar het script draait (meestal /sites/MulderT/).
     */
    async function haalGebruikersGroepenOp() {
        // API call voor gebruikersgroepen relatief aan de site waar de zoekpagina is (spSiteContextUrl)
        const apiUrl = `${spSiteContextUrl}/_api/web/currentuser/groups`;
        console.log(`[Authenticatie] API URL voor gebruikersgroepen: ${apiUrl}`);

        if (!siteInhoudKnop && !siteInstellingenKnop && !notificatieToevoegenKnop) { 
            console.error('[Authenticatie] Geen admin knoppen gevonden in het DOM.');
            return;
        }

        try {
            const response = await fetch(apiUrl, {
                method: 'GET',
                headers: {
                    'Accept': 'application/json;odata=verbose'
                }
            });

            if (!response.ok) {
                console.error(`[Authenticatie] Fout bij ophalen gebruikersgroepen: ${response.status} ${response.statusText}`);
                const errorText = await response.text();
                console.error(`[Authenticatie] Foutdetails: ${errorText}`);
                return;
            }

            const data = await response.json();
            console.log('[Authenticatie] Gebruikersgroepen data ontvangen:', data);

            if (data && data.d && data.d.results) {
                const gebruikersGroepen = data.d.results;
                let gebruikerIsLid = false;

                for (const groep of gebruikersGroepen) {
                    if (groep.LoginName && toegestaneGroepen.includes(groep.LoginName)) {
                        gebruikerIsLid = true;
                        console.log(`[Authenticatie] Gebruiker is lid van toegestane groep: ${groep.LoginName}`);
                        break; 
                    }
                }

                if (gebruikerIsLid) {
                    if (siteInhoudKnop) {
                        siteInhoudKnop.style.display = 'inline-block'; 
                        console.log('[Authenticatie] "Site-inhoud" knop wordt weergegeven.');
                    }
                    if (siteInstellingenKnop) { 
                        siteInstellingenKnop.style.display = 'inline-block';
                        console.log('[Authenticatie] "Site-instellingen" knop wordt weergegeven.');
                    }
                    if (notificatieToevoegenKnop) { // Toon de nieuwe knop
                        notificatieToevoegenKnop.style.display = 'inline-block';
                        console.log('[Authenticatie] "Notificatie toevoegen" knop wordt weergegeven.');
                    }
                } else {
                    if (siteInhoudKnop) siteInhoudKnop.style.display = 'none';
                    if (siteInstellingenKnop) siteInstellingenKnop.style.display = 'none'; 
                    if (notificatieToevoegenKnop) notificatieToevoegenKnop.style.display = 'none';
                    console.log('[Authenticatie] Gebruiker is geen lid van een toegestane groep. Admin knoppen blijven verborgen.');
                }
            } else {
                console.warn('[Authenticatie] Geen groepen gevonden in API respons of onverwachte data structuur.');
            }

        } catch (error) {
            console.error('[Authenticatie] Algemene fout tijdens ophalen gebruikersgroepen:', error);
        }
    }

    haalGebruikersGroepenOp();
});
