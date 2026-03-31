Inlämning 2: Avancerad SQL & Databashantering

Databas som behandlar en bokhandel
En kort och slagkraftig beskrivning på en rad om vad projektet gör.

Syftet med projektet var att skapa en databas som behandlar en bokhandel där man enkelt ska kunna se olika kopplingar 
mellan kunder, ordrar, böcker etc. I databasen ska man även kunna se hur förändringar i olika tabeller triggar igång en händelse i andra tabeller. 
Det viktiga som databasen säkerställer är att det inte är möjligt för en order att existera utan att en kund har gjort en och att priset på böcker 
inte kan vara mindre än 0 kr. Allteftersom en kund gör en beställning så sker även uppdatering av lager saldot.
Möjligheten att utöka bokhandelns kapacitet med fler boktitlar är fullt möjligt utan att databassystemet blir trögt.


Database Schema

Beskriv de viktigaste tabellerna och deras relationer. Det är mycket vanligt att infoga en bild på sitt ER-diagram här.

	Bestallningar: När en kund gör en beställnning så kommer den att loggas i tabellen

	Bocker: Tabell som Innehåller alla böcker som själva bokhandeln har.

    Kunder: Här registreras alla kunder och kundernas information som namn, efternamn, e-post etc.
	
	Kundlogg: Tabell som håller koll på nya kunder som registreras.
	
	Orderrader: Tabell som visar vad varje kund som lagt en beställning faktiskt har köpt.    
	
	

Funktioner i databasen

Här listar du de tekniska höjdpunkterna i din kod:

    [x] Automatisk lageruppdatering via Triggers.

    [x] Transaktionssäker uppdatering av kunddata.

    [x] Loggning av nyregistrerade kunder.

    [x] Constraints för prissättning och lagersaldo.



Reflektion och analys av databaslösning:

När det kommer till designen av databasen så finns det säkert många sätt man kan göra den på. Den stora anledningen till att jag designade den som
jag gjorde var att jag ville prioritera strukturen i databasen. En strukturerad databas gör det enkelt för alla som tar del av den att förstå den 
men den blir även enklare att underhålla. Exempelvis så delade jag in all information som en kund kan tänkas ha i en tabell för sig, all information
om böcker (titel, ISBN nummer, pris etc) i en tabell för sig, information om ordrar som är kopplad till varje kund i en tabell för sig.
Detta gör det enklare att kombinera och visa data från olika tabeller med hjälp av ex. JOINS. Om databasen istället hade varit konstruerad på ett
sätt där flera tabeller hade kombinerats till en enda tabell så hade det gjort databasen mer svårhanterlig samtidigt som det hade ökat risken för
inmatningsfel.


100 000 kunder istället för 10:

Om databasen istället skulle gå från att behöva hantera 10 kunder till 100 000 kunder så finns det en rad lämpliga ändringar som skulle kunna göras
för att databasen skulle bli enklare att hantera. Exempelivs en tabell med recensioner hade kunnat läggas till vilket hade gjort det enklare för 
kunder att dela med sig av tankar och åsikter om böcker som de köpt när det är så många kunder som databasen hanterar. Normalt sätt om en kund gör
en beställning så infogas datan i tabellen "beställningar". Låt oss säga att 50 000 kunder av de ursprungliga 100 000 vill ångra sina beställningar
eller ändra den på något sätt, då måste databasen använda sig av många "INSERT", "UPDATE" och "DELETE" kommandon för att uppdatera varje gång en
förändring sker. Detta kommer att belasta "beställningar" tabellen rejält och då är det mer lämpligt att lägga till en "Varukorg" tabell som är
bättre lämpad för att hantera den här typen av förändringar.


Möjliga optimeringar i index och struktur:

De förbättringar som skulle kunna göras är att man sätter index på det man kan tänka sig att kunder söker på ofta och i den här databasen med 
bokhandeln så vore det lämpligt att även sätta index på titel och/eller författare i tabellen böcker utöver index som finns på "E_post" i tabellen
kunder. Ett nytt index på titel och/eller författare skulle göra att en kund kan hitta den eller de böckerna de letar efter mycket snabbare än utan
index. Det är dock viktigt att tänka på att varje index som läggs till belastar databasen och därför är det viktigt att bara sätta index på sådant
som kunder kan tänkas söka på ofta. Det man kan förbättra när det gäller strukturen av databasen är att man exempelvis skulle kunna skapa en ny
tabell som bara hanterar kunders köphistorik. Om en bokhandel behöver hantera 100 000 kunder där varje kund gör några beställningar inom en viss
tidsperiod så kommer tabellen "beställningar" att belastas med en massa beställningar, nya som gamla. Därför skulle man kunna göra en ny tabell som
hanterar beställningar som är äldre än ex. 6 månader. Detta gör att tabellen "Beställningar" inte blir allt för belastad.

