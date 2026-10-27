# Decidim02 – Software Inventory and Server Configuration

## Dokumendi otstarve

Dokument kirjeldab serveri `decidim02` riistvara, paigaldatud tarkvara, püsivat konfiguratsiooni, rolli, kontrollitud hetkeseisu ja seoseid muu taristuga.

Üksikasjalikud paigaldus-, muudatus-, taastamis- ja käitusprotseduurid paiknevad eraldi tegevusjuhendites. Käesolevas dokumendis eristatakse tegelikult rakendatud, kontrollitud, kavandatud ja veel dokumenteerimata konfiguratsiooni.

## Versiooniajalugu

| Versioon | Kuupäev | Autor | Muudatus |
|---|---|---|---|
| 0.1 | 2026-10-21 | Andres Beek / Copilot | Debiani paigaldus, BIOS-i/UEFI seadistamine, kettajaotus ja Dockeri paigaldus. |
| 0.2 | 2026-10-21 | Andres Beek / Copilot | UEFI alglaadimise, AHCI töö ja SSD SMART-seisundi kontroll. |
| 0.3 | 2026-10-21 | Andres Beek / Copilot | SSH võtmega autentimise seadistamine ja kontrollimine. |
| 0.4 | 2026-10-21 | Andres Beek / Copilot | Uneolekute keelamine serverikasutuseks. |
| 1.0 | 2026-10-22 | Andres Beek / Copilot | Koostatud esialgne tarkvarainventuuri ja serveri konfiguratsiooni dokument. |
| 1.1 | 2026-10-23 | Andres Beek / Copilot | Lisatud võrgutaristu seos ja OpenWrt haldusmudeli kavand. |
| 1.2 | 2026-10-23 | Andres Beek / Copilot | Eemaldatud ruuteri üksikasjalik seadistusprotseduur; ruuteri konfiguratsioon ja tegevusjuhend viidud eraldi failidesse. Taastatud varasema dokumendi sisu ja täpsustatud eristus kontrollitud, kavandatud ja teadmata asjaolude vahel. |
| 1.3 | 2026-10-27 | Andres Beek / Copilot | Ajakohastatud Decidimi teenuse tegelik seis sisevõrgus: teenus on käivitatud ja kontrollitud; TLS-i lõpetamine pole veel seadistatud; WAN-poolne juurdepääs pole lubatud; välisvõrgust juurdepääsu toimivust ei tohi järeldada. |

## 1. Identifitseerimine ja roll

- Hostinimi: `decidim02`
- Roll: Decidimi varuserver (*warm standby*)
- Operatsioonisüsteem: Debian GNU/Linux 13 (Trixie), versioon 13.7
- Arhitektuur: `amd64`
- Ajavöönd: `Europe/Tallinn`

## 2. Riistvara

- Mudel: Samsung NP905S3G-K01EE
- CPU: AMD A6-1450
- RAM: 4096 MB
- SSD: Samsung MZMTD128HAFV-000, 128 GB
- BIOS: P13RBV
- MICOM: P13RBV

## 3. BIOS-i ja alglaadimise konfiguratsioon

Viimati dokumenteeritud BIOS-i/UEFI sätted:

- `Password On Boot`: `Off`
- `Secure Boot Control`: `Off`
- `OS Mode Selection`: `UEFI OS`
- `AHCI Mode Control`: `Manual`
- `Set AHCI Mode`: `Enabled`
- `Fast BIOS Mode`: `Off`
- `PXE OPROM`: `Off`
- Alglaadimisrežiim: UEFI
- Alglaadimiskirjed: `Boot0003* debian` ja `Boot0004* UEFI OS`
- SATA-režiim: AHCI
- Viimati dokumenteeritud SATA ühenduse kiirus: 6 Gbit/s

BIOS-i sätted tuleb pärast BIOS-i lähtestamist, püsivara uuendamist või riistvaramuudatust uuesti kontrollida.

## 4. Kettajaotus

```text
sda1   EFI      512 MB   /boot/efi
sda2   ext4      26 GB   /
sda3   swap       4 GB
sda4   ext4      88 GB   /srv
```

## 5. Mälu ja SSD viimati dokumenteeritud seis

### Mälu

- RAM kokku: 3,3 GiB
- kasutusel: 485 MiB
- saadaval: 2,8 GiB
- swap kasutusel: 0 B

### SSD

- SMART üldhinnang: `PASSED`
- `Power_On_Hours`: 6628
- `Power_Cycle_Count`: 7738
- SMART Error Log: `No Errors Logged`

Need väärtused kirjeldavad kontrollimise hetke, mitte püsikonfiguratsiooni. Järgmise kontrolli järel tuleb lisada kontrollimise kuupäev ja ajakohastatud tulemus.

## 6. Tarkvarainventuur

Viimati dokumenteeritud tarkvara:

- Docker: `26.1.5+dfsg1`
- Docker Compose: `2.26.1-4`
- OpenSSH Server
- smartmontools

Paketiversioonid tuleb pärast süsteemi või pakettide uuendamist üle kontrollida.

## 7. SSH konfiguratsioon

- Halduskasutaja: `abeek`
- Autentimine: Ed25519 SSH-võti
- Võtmepõhine sisselogimine on kontrollitud.

„Võtmepõhine” ei tähenda tingimata, et SSH privaatvõti on paroolifraasita. Serveri kasutajakonto parooli asemel kasutatakse SSH avaliku võtme autentimist.

SSH-serveri täpsed aktiivsed sätted tuleb pärast serveri turvakõvastuse lõpetamist lisada tegeliku konfiguratsiooni ja kontrollväljundite alusel.

## 8. Energiahaldus

Serverikasutuseks on maskeeritud järgmised systemd sihtüksused:

- `sleep.target`
- `suspend.target`
- `hibernate.target`
- `hybrid-sleep.target`

## 9. Teenusekataloogid

Kavandatud kataloogid:

```text
/srv/decidim
/srv/postgresql
/srv/backups
/srv/restic
/srv/wmbus
```

Kataloogide tegelik olemasolu, omanikud, rühmad ja õigused tuleb dokumenteerida pärast nende loomist või kontrollimist.

## 9.1. Decidimi teenuse tegelik seis

Decidim teenus on sisevõrgus kasutatav.

Teenusele pääseb ligi hostinime kaudu:

    decidim.lan

Rakendus kuvab administraatori sisselogimislehe.

Decidim, PostgreSQL ja Redis töötavad.

Sisevõrgu DNS-lahendus toimib OpenWrt dnsmasq kaudu.

Kasutajaliides on kontrollitud veebibrauserist.

Kontrollitud 2026-10-27.

Decidim::Organization.count = 0

Rakendus on käivitatud ning veebiliides on sisevõrgust
kättesaadav nime decidim.lan kaudu.

Organisatsiooni ei ole veel loodud ning süsteem
on Decidimi esmase kasutuselevõtu seisus.

## 10. Võrgukonfiguratsioon ja taristuseosed

- Vaikelüüs ja LAN-ruuter: OpenWrt, `192.168.2.1/24`
- LAN-võrk: `192.168.2.0/24`
- Võrgumask: `255.255.255.0`
- Serveri `decidim02` püsiv IPv4-aadress või DHCP staatiline rent: veel määramata

Serveri püsivat IPv4-aadressi ei tohi dokumenteerida oletuslikult. Aadress lisatakse pärast staatilise DHCP-rendi või serveripoolse püsiva võrgukonfiguratsiooni rakendamist ja kontrollimist.

Ruuteri tarkvarainventuur ja konfiguratsioon:

- [`OpenWrt_Router_Software_Inventory_and_Configuration.md`](OpenWrt_Router_Software_Inventory_and_Configuration.md)

Ruuteri turvalise halduse tegevusjuhend:

- [`OpenWrt_Router_Secure_Management_Runbook.md`](OpenWrt_Router_Secure_Management_Runbook.md)

## 11. Seotud failid Git-hoidlas

Soovitatav struktuur:

```text
it_com-infrastructure/
├── README.md
├── docs/
│   ├── Decidim02_Software_Inventory_and_Server_Configuration.md
│   ├── OpenWrt_Router_Software_Inventory_and_Configuration.md
│   └── OpenWrt_Router_Secure_Management_Runbook.md
├── decidim02/
│   ├── compose/
│   ├── systemd/
│   └── scripts/
└── openwrt/
    ├── scripts/
    │   └── configure-wireguard-management.sh
    └── sanitized-config/
```

Git-hoidlasse ei kanta paroole, SSH või WireGuardi privaatvõtmeid, WireGuardi eeljagatud võtmeid, Wi-Fi paroole, API-võtmeid ega saladusi sisaldavaid OpenWrt varukoopiaid.

## 12. Veel seadistamata või dokumenteerimata

- serveri püsiv LAN-aadress või DHCP staatiline rent;
- Restic-varundus;
- Decidimi Docker Compose'i keskkond;
- PostgreSQL-i varundus;
- PostgreSQL-i replikatsioon;
- wM-Bus tarkvara;
- Grafana;
- TimescaleDB;
- Traefik või Nginx;
- Decidimi rakendus;
- SSH-serveri turvakõvastuse lõplik konfiguratsioon;
- rakendus- ja konfiguratsioonifailide lõplik paigutus Git-hoidlas.

## 13. Kontrollkäsud

### Süsteemi identifitseerimine

```sh
hostnamectl
cat /etc/os-release
timedatectl
uname -a
sudo dmidecode -s system-product-name
```

### UEFI, SATA ja kettad

```sh
test -d /sys/firmware/efi && echo UEFI || echo BIOS
sudo efibootmgr
sudo dmesg | grep -E 'ahci|sata'
lsblk -f
df -h
swapon --show
```

### Mälu ja SSD

```sh
free -h
sudo smartctl -i /dev/sda
sudo smartctl -H /dev/sda
sudo smartctl -a /dev/sda
smartctl --version
```

### Docker ja Docker Compose

```sh
docker --version
docker compose version
docker-compose version
systemctl is-active docker
systemctl is-enabled docker
```

### SSH

```sh
systemctl is-active ssh
systemctl is-enabled ssh
sshd -T 2>/dev/null | grep -E '^(permitrootlogin|passwordauthentication|pubkeyauthentication)'
ls -la ~/.ssh
```

Faili `~/.ssh/authorized_keys` terviksisu ei tule dokumentatsiooni ega tavapärasesse kontrollväljundisse kopeerida. Vajaduse korral kontrollida ainult võtmete arvu ja sõrmejälgi.

Näiteks:

```sh
wc -l ~/.ssh/authorized_keys
ssh-keygen -lf ~/.ssh/authorized_keys
```

Kliendiarvutis:

```powershell
ssh abeek@decidim02
```

### Energiahaldus

```sh
systemctl is-enabled sleep.target suspend.target hibernate.target hybrid-sleep.target
systemd-analyze cat-config systemd/logind.conf
```

### Teenusekataloogid ja võrk

```sh
find /srv -maxdepth 1 -type d | sort
ip -brief address
ip route
```

## 14. Dokumendi haldus

- Dokumentida selles failis serveri tegelik ja kontrollitud seis, mitte pikk rakendus- või taastamisprotseduur.
- Eristada selgelt rakendatud, kontrollitud, kavandatud ja veel dokumenteerimata konfiguratsiooni.
- Lisada olulise muudatuse korral versiooniajaloo kirje.
- Viidata tegevusjuhenditele, skriptidele ja konfiguratsioonifailidele suhteliste Markdown-linkidega.
- Hoida üksikasjalikud käitus- ja taastamisprotseduurid eraldi tegevusjuhendites.
- Mitte salvestada dokumenti saladusi.
