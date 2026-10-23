# Decidim02 – Software Inventory and Server Configuration

## Dokumendi otstarve

Dokument kirjeldab serveri `decidim02` riistvara, paigaldatud tarkvara, püsivat konfiguratsiooni, rolli, kontrollitavat hetkeseisu ja seoseid muu taristuga. Üksikasjalikud paigaldus- ja käitusprotseduurid paiknevad eraldi tegevusjuhendites.

## Versiooniajalugu

| Versioon | Kuupäev | Muudatus |
|---|---|---|
| 1.0 | 2026-10-22 | Koostatud algne tarkvarainventuur ja serveri konfiguratsiooni kirjeldus. |
| 1.1 | 2026-10-23 | Lisatud võrgutaristu seos ja OpenWrt haldusmudeli kavand. |
| 1.2 | 2026-10-23 | Eemaldatud ruuteri üksikasjalik seadistusprotseduur; ruuteri konfiguratsioon ja tegevusjuhend viidud eraldi failidesse. |

## 1. Identifitseerimine ja roll

- Hostinimi: `decidim02`
- Roll: Decidimi varuserver (warm standby)
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

- Alglaadimisrežiim: UEFI
- Secure Boot: väljas
- SATA-režiim: AHCI
- Fast BIOS Mode: väljas
- PXE OPROM: väljas
- Alglaadimiskirjed: `debian` ja `UEFI OS`

## 4. Kettajaotus

```text
sda1   EFI      512 MB   /boot/efi
sda2   ext4      26 GB   /
sda3   swap       4 GB
sda4   ext4      88 GB   /srv
```

## 5. Mälu ja SSD teadaolev seis

Viimati dokumenteeritud mälu seis:

- RAM kokku: 3,3 GiB
- kasutusel: 485 MiB
- saadaval: 2,8 GiB
- swap kasutusel: 0 B

Viimati dokumenteeritud SSD seis:

- SMART üldhinnang: PASSED
- Power_On_Hours: 6628
- Power_Cycle_Count: 7738
- SMART Error Log: No Errors Logged

Need väärtused on hetkeseisu kirjed, mitte püsikonfiguratsioon. Uue kontrolli järel tuleb märkida kontrollimise kuupäev ja tulemus.

## 6. Tarkvarainventuur

- Docker: `26.1.5+dfsg1`
- Docker Compose: `2.26.1-4`
- OpenSSH Server
- smartmontools

## 7. SSH konfiguratsioon

- Halduskasutaja: `abeek`
- Autentimine: Ed25519 SSH-võti
- Võtmepõhine sisselogimine on kontrollitud.

SSH serveri täpsed aktiivsed sätted tuleb pärast turvakõvastuse lõpetamist siia lisada konfiguratsioonifailide või kontrollväljundite alusel.

## 8. Energiahaldus

Serverikasutuseks on maskeeritud:

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

Kataloogide tegelik olemasolu, omanikud ja õigused tuleb dokumenteerida pärast loomist.

## 10. Võrgukonfiguratsioon ja taristuseosed

- Vaikelüüs ja LAN-ruuter: OpenWrt, `192.168.2.1/24`
- LAN-võrk: `192.168.2.0/24`
- Võrgumask: `255.255.255.0`
- Serveri `decidim02` püsiv IPv4-aadress või DHCP staatiline rent: veel määramata

Ruuteri üksikasjalik inventuur ja püsikonfiguratsioon on failis:

- [`OpenWrt_Router_Software_Inventory_and_Configuration.md`](OpenWrt_Router_Software_Inventory_and_Configuration.md)

Ruuteri rakendus- ja kontrollprotseduur on failis:

- [`OpenWrt_Router_Secure_Management_Runbook.md`](OpenWrt_Router_Secure_Management_Runbook.md)

## 11. Seotud konfiguratsioonifailid Git-hoidlas

Soovitatav struktuur:

```text
infrastructure/
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

Git-hoidlasse ei kanta paroole, privaatvõtmeid, WireGuardi eeljagatud võtmeid ega saladusi sisaldavaid OpenWrt varukoopiaid.

## 12. Veel seadistamata või dokumenteerimata

- serveri püsiv LAN-aadress või DHCP staatiline rent;
- Restic-varundus;
- Decidimi Docker Compose'i keskkond;
- PostgreSQL-i varundus ja replikatsioon;
- wM-Bus tarkvara;
- Grafana ja TimescaleDB;
- Traefik või Nginx;
- Decidimi rakendus;
- konfiguratsioonifailide lõplik Git-hoidla.

## 13. Kontrollkäsud

```sh
hostnamectl
cat /etc/os-release
timedatectl
uname -a
lsblk -f
df -h
swapon --show
free -h
sudo smartctl -H /dev/sda
sudo smartctl -a /dev/sda
docker --version
docker compose version
systemctl is-active docker
systemctl is-enabled docker
systemctl is-active ssh
systemctl is-enabled sleep.target suspend.target hibernate.target hybrid-sleep.target
find /srv -maxdepth 1 -type d | sort
ip -brief address
ip route
```

## 14. Dokumendi haldus

- Dokumentida siin serveri tegelik ja kontrollitud seis, mitte pikk käitusprotseduur.
- Eristada selgelt rakendatud ja kavandatud konfiguratsioon.
- Lisada olulise muudatuse korral versiooniajaloo kirje.
- Viidata protseduuridele ja konfiguratsioonifailidele suhteliste Git-linkidega.
- Mitte salvestada dokumenti saladusi.
