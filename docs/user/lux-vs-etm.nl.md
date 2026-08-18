# LUX en het Energy Transition Model (ETM)

LUX Energy Twin en het [Energy Transition Model](https://energytransitionmodel.com/) (ETM) worden beide veel gebruikt voor beleid in de energietransitie, maar beantwoorden verschillende vragen.

Het ETM kan worden gezien als een boekhouder van energie transitie scenario's, varierend van scenario's per gemeente tot heel Nederland. Het ETM is belangrijk aangezien hierin de nationale scenario's door Netbeheer Nederland gedefiniëeerd staan. 
LUX voegt daar een aantal lagen aan toe. LUX zoomt in op individuele buurten en bedrijventerreinen, opschalend tot gemeente, regio of provincies. LUX heeft hierin drie toevoegingen:

1. LUX visualiseert de energie infrastructuur en scenario's op een kaart, om zo meer inzicht te geven wat een scenario ruimtelijk betekent. 
2. In LUX kunnen specifieke toekomstscenario's worden ingeladen. Denk aan RES plannen voor grootschalige opwek, bedrijventerreinen met hoge logistieke vraag, of grootschalige batterijen. In LUX krijgen deze niet alleen een capaciteit, maar ook een plek op de kaart en een verbinding met het elektriciteitsnet.
3. LUX is gespecialiseerd in oplossingen voor slimme energiesystemen om o.a. netcongestie te verhelpen. Met LUX kunnen verschillende aansturingen van flexibiliteit als (thuis)batterijen en bi-directioneel ladende EVs worden gesimuleerd, rekening houdend met huidige en toekomstige sturingsmechanismes als nettarieven, marktprijzen of lokale balans.

## ETM en LUX zijn complementair
Waar ETM een volledige en consistente boekhouding van scenario's over schaalniveaus biedt. Kan LUX deze scenario's inladen, en hier concreet handen en voeten aan geven door ze op de kaart te plotten, en op zoek te gaan naar oplossingsruimte binnen de grenzen van het net en de ruimtelijke mogelijkheden. 

## Wat ze gemeen hebben

* Beide zijn **open source en interactief**: je schuift zelf aan de knoppen en ziet direct wat er gebeurt.
* Beide zijn **scenariotools, geen optimalisatiemodellen die het "beste" antwoord geven**. Ze rekenen door wat jij invoert. Het inzicht zit in het vergelijken van varianten.
* Beide kijken naar het **hele energiesysteem in samenhang**, niet naar één techniek los.

## Waar ze verschillen

| | **ETM** | **LUX-regio** |
|---|---|---|
| Kernvraag | Wat is energetisch een goed scenario? | Hoe wordt een scenario lokaal uitgevoerd en ingepast? |
| Schaal | Land, provincie, regio, gemeente | regio, tot op individuele aansluitingen en transformatoren |
| Sectoren | Alle: gebouwde omgeving, industrie, landbouw, mobiliteit |  Alle: gebouwde omgeving, industrie, landbouw, mobiliteit |
| Belangrijkste uitkomsten | Energievraag en -aanbod, CO<sub>2</sub>-uitstoot en systeemkosten | Netbelasting, congestie, benutting van aansluit- en stationscapaciteit, pieken |
| Net | Is geaggregeerd tot één node per netvlak | Zit er als de data beschikbaar is expliciet in: stations en transformatoren met echte capaciteitsgrenzen |


## De koppeling: ETM-scenario's in LUX

Het belangrijkste punt voor gebruikers van beide modellen: **LUX kan ETM-scenario's inladen.** Een scenario dat in het ETM is opgebouwd, bijvoorbeeld een regionaal beeld van elektrificatie van warmte en mobiliteit richting 2035 of 2050, kan als uitgangspunt dienen voor een LUX-berekening. Met de ETM API-koppeling en een scenario ID nummer kan LUX automatisch verbinding leggen en de scenario aannames ophalen. LUX zal deze vervolgens uitsplitsen naar buurten aan de hand van aanwezige buurtdata en schalingsfactoren. Daarnaast kunnen 

## Wanneer gebruik je wat

Gebruik het **ETM** om richting te kiezen: hoeveel wind en zon, hoe ver gaat de elektrificatie, wat is het kostenplaatje, halen we de klimaatdoelen. Het antwoord komt in volumes, kosten en uitstoot.

Gebruik **LUX-regio** om die richting te toetsen: houdt het net het, wanneer en waar loopt het vast, en helpt flexibiliteit — batterijen, slim laden, afspraken tussen bedrijven over gedeelde capaciteit — om dat op te lossen of uit te stellen. Het antwoord komt in belastingprofielen, knelpunten en congestie-uren.

## Belangrijkste uitdaging

Aangezien de analyse in LUX vaak een stap gedetailleerder is, vooral gericht op netten en locaties, is de databehoefte ook groter. Netdata en locatiegegevens van energie assets als windmolens, zonnevelden en batterijen zijn benodigd om de volledig potentie van LUX te benutten. Veel van deze data kan Zenmo open-source samenstellen, maar vaak is ook medewerking van de netbeheerder en grootverbruikers nodig.

