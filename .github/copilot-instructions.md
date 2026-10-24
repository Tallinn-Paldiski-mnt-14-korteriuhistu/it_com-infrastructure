# Hoidla eesmärk

Hoidla dokumenteerib korteriühistu teenuste kavandamist, tegelikku seadistust ja käitamist:

- Decidim: koosolekute, otsuste ja osalejate teenus.
- wM-Bus: veearvestite näitude raadio teel kogumise ja haldamise teenus.
- Taristu: nende teenuste jaoks vajalik riistvara, tarkvara, võrk, varundus ja haldus.

# Tööreeglid

- Erista selgelt kontrollitud tegelikku seisu, kavandatud lahendust, oletust ja teadmata asjaolu.
- Ära käsitle dokumentatsioonis olevat väidet tõendina, et seadistus on seadmes rakendatud.
- Lisa võimalusel kontrollitud faktile allikas ja kontrollimise kuupäev.
- Ära mõtle välja seadmete andmeid, aadresse, versioone, seadistusi ega testitulemusi.
- Kui oluline info puudub, märgi see teadmata või ebakindlaks. Küsi täpsustust, kui puuduv info mõjutab muudatuse õigsust või ohutust.
- Enne failide muutmist selgita lühidalt ülesandest arusaamist, nimeta muudetavad failid ja esita muudatusplaan.
- Tee muudatused väikestena ja piira need ülesandega seotud failidega.
- Ära tee muudatusi töötavates serverites, ruuterites ega muudes seadmetes. Ära väida, et muudatus on rakendatud, kui seda pole eraldi kontrollitud.
- Muudatuse järel esita muudetud failide loetelu, diff või muudatuste kokkuvõte ning kontrollide tulemused. Ära väida, et kontroll käivitati, kui seda tegelikult ei tehtud.
- Konfiguratsioonimuudatuse puhul kirjelda eeldused, rakendamine, kontroll ja tagasipööramine.
- Ära lisa hoidlasse paroole, privaatvõtmeid, tokeneid ega elanike või korterite tuvastatavaid andmeid. Kasuta näidetes kohatäitjaid, näiteks `<RUUTERI_LAN_IP>`.
- Kirjuta eesti keeles ja selgita tehnilised mõisted nii, et dokumentatsioon oleks arusaadav ka ühistu juhatuse liikmele.

# Tööülesande sisestusmall

Ainus tööülesande sisestusmall asub failis
`docs/process/task-intake-template.md`.

- Kasuta seda faili tööülesande lähtealusena.
- Ära loo ega hoia mallist koopiaid kaustas `.github/prompts/` ega mujal.
- Kui mall või vajalik hoidla fail pole aktiivses seansis kättesaadav, ütle seda selgelt ning palu kasutajal fail lisada või selle sisu vestlusse kopeerida.
- Ära väida, et oled faili lugenud, kui selle sisu polnud sulle kättesaadav.
