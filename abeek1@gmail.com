# Korteriühistu IT-taristu

Hoidla sisaldab korteriühistu serverite, võrguseadmete ja nendega seotud teenuste konfiguratsiooni ning käitusjuhendeid.

## Dokumentatsioon

- [Decidim02 tarkvarainventuur ja serveri konfiguratsioon](docs/Decidim02_Software_Inventory_and_Server_Configuration.md)
- [OpenWrt ruuteri tarkvarainventuur ja konfiguratsioon](docs/OpenWrt_Router_Software_Inventory_and_Configuration.md)
- [OpenWrt ruuteri turvalise halduse tegevusjuhend](docs/OpenWrt_Router_Secure_Management_Runbook.md)
- [Task Intake mall] (docs/process/task-intake-template.md)

## Kataloogid

- `docs/` – inventuuri-, konfiguratsiooni- ja tegevusjuhendid;
- `decidim02/` – serveri rakendus- ja teenusekonfiguratsioonid;
- `openwrt/` – ruuteri skriptid ning saladustest puhastatud konfiguratsioonid;
- `local-only/` – kohalikud varukoopiad ja binaarfailid; kataloogi ei kanta Git-hoidlasse.

## Turvanõue

Hoidlasse ei kanta paroole, privaatvõtmeid, WireGuardi eeljagatud võtmeid, Wi-Fi paroole ega saladusi sisaldavaid varukoopiaid.

## Hoidla ulatus

Git-hoidla dokumenteerib seadistuste kontrollitud või kavandatud seisundi ning säilitab rakendatavad skriptid ja saladustest puhastatud konfiguratsioonid. Täielikke seadmevarukoopiaid ja püsivarabinaare säilitatakse väljaspool Git-hoidlat.
