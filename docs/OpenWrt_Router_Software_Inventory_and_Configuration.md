# OpenWrt Router – Software Inventory and Configuration

## Dokumendi otstarve

Dokument kirjeldab OpenWrt ruuteri tarkvarainventuuri, püsivat võrgukonfiguratsiooni, haldusmudelit ja seoseid serveritaristuga. Üksikasjalikud rakendus-, kontroll- ja taastamiskäsud paiknevad eraldi tegevusjuhendis.

## Versiooniajalugu

| Versioon | Kuupäev | Muudatus |
|---|---|---|
| 0.1 | 2026-10-23 | Koostatud ruuteri esialgne inventuuri- ja konfiguratsioonikirjeldus. |

## 1. Seadme identifitseerimine

- Seade: OpenWrt ruuter
- Püsivara: OpenWrt 25.12.6
- LuCI: pildil kuvatud haru `HEAD detached at 75a306df`
- Varasem püsivara: OpenWrt 21.02.1
- Riistvara jääb püsivara uuendamisel samaks.

Ruuteri täpne mudel, arhitektuur, sihtplatvorm, kerneli versioon ja paigaldatud pakettide loend tuleb pärast seadistamist lisada tegelike kontrollväljundite alusel.

## 2. LAN

- LAN IPv4-aadress: `192.168.2.1`
- Võrgumask: `255.255.255.0`
- CIDR: `192.168.2.1/24`
- LAN-võrk: `192.168.2.0/24`
- Leviaadress: `192.168.2.255`

## 3. Haldusmudel

### LAN-ist

- LuCI: HTTPS, `https://192.168.2.1/`
- LuCI autentimine: root-kasutaja tugev ja ainulaadne parool
- HTTP: suunatakse HTTPS-ile
- SSH: ainult avaliku võtmega
- SSH paroolautentimine: keelatud pärast võtmega juurdepääsu kontrollimist

### WAN-ist

- Avatud ainult WireGuardi UDP-port `51820`
- SSH TCP `22`: suletud
- LuCI HTTP TCP `80`: suletud
- LuCI HTTPS TCP `443`: suletud
- SSH ja LuCI kasutamine toimub WireGuardi tunneli kaudu.

## 4. WireGuardi haldusvõrk

- Liides: `wg_mgmt`
- Võrk: `10.14.0.0/24`
- Ruuteri VPN-aadress: `10.14.0.1/24`
- Esimese Windowsi halduskliendi aadress: `10.14.0.2/32`
- Kuulamisport: UDP `51820`
- võti root@drahobudice:~# cat /etc/wireguard/server.pub
QnBXN/5NUGCETE66ZlLCeKJffWNPLCng+xd2FuesTV0=
- Lubatud haldusteenused VPN-ist ruuterisse:
  - ICMP echo;
  - SSH TCP `22`;
  - LuCI HTTPS TCP `443`.
- VPN-ist LAN-i edasisuunamine: keelatud
- Windowsi kliendi `AllowedIPs`: `10.14.0.1/32`

Võrk `10.14.0.0/24` ei kattu LAN-võrguga `192.168.2.0/24`.

## 5. Tulemüüri kavandatud püsiseisund

- Tsoon `wan`: lubab ruuterisse UDP `51820`.
- Tsoon `wan`: ei luba ruuterisse TCP porte `22`, `80` ega `443`.
- Tsoon `wg_mgmt`: sisendpoliitika `REJECT`.
- Tsoon `wg_mgmt`: lubab erireeglitega ainult ICMP echo, TCP `22` ja TCP `443`.
- Tsoon `wg_mgmt`: edastuspoliitika `REJECT`.
- Tsoon `wg_mgmt`: masquerading ei ole kasutusel.

## 6. SSH

- Server: Dropbear
- Halduskasutaja: `root`
- Avalike võtmete fail: `/etc/dropbear/authorized_keys`
- Võtmetüüp: Ed25519
- `PasswordAuth`: kavandatud `off`
- `RootPasswordAuth`: kavandatud `off`

## 7. LuCI ja HTTPS

- Veebiserver: uHTTPd
- HTTPS-port: TCP `443`
- HTTP-port TCP `80` võib LAN-is jääda ainult HTTPS-ile ümbersuunamiseks.
- Sertifikaadi ja võtme tavapärased asukohad:
  - `/etc/uhttpd.crt`
  - `/etc/uhttpd.key`
- Sertifikaadi usalduslahendus on veel otsustamata.

## 8. Wi-Fi lähteandmed

Kavandatud SSID-d:

- `ENAY`, 2,4 GHz;
- `EestiNoorteAdvokaatideYhing`, 5 GHz;
- `PrettyBluePlanet`, 2,4 ja 5 GHz;
- `ELISA_2.4G_9F2958`, 2,4 GHz;
- `ELISA_5G_9F2958`, 5 GHz.

Mitte kasutada SSID-sid:

- `Gratuluji!`;
- `svet_veci`.

Wi-Fi paroolid ja muud saladused ei kuulu sellesse dokumenti ega Git-hoidlasse.

## 9. Seos serveriga Decidim02

- Ruuter on serveri `decidim02` LAN-i vaikelüüs ja võrgutaristu osa.
- Serveri püsiv LAN-aadress või DHCP staatiline rent on veel määramata.
- WireGuardi halduskliendile ei anta esialgu ligipääsu LAN-võrgule ega serverile `decidim02`.
- Serveri kaugjuurdepääsu lisamine otsustatakse eraldi pärast serveri püsiva aadressi ja minimaalselt vajalike tulemüürireeglite määramist.

Seotud serveridokument:

- [`Decidim02_Software_Inventory_and_Server_Configuration.md`](Decidim02_Software_Inventory_and_Server_Configuration.md)

Seotud tegevusjuhend:

- [`OpenWrt_Router_Secure_Management_Runbook.md`](OpenWrt_Router_Secure_Management_Runbook.md)

## 10. Git-hoidla seosed

Soovitatavad failid:

```text
openwrt/
├── scripts/
│   └── configure-wireguard-management.sh
└── sanitized-config/
    ├── network
    ├── firewall
    ├── dropbear
    ├── uhttpd
    └── wireless
```

Failid kataloogis `sanitized-config` peavad olema puhastatud privaatvõtmetest, eeljagatud võtmetest, paroolidest ja muudest saladustest.

## 11. Kontrollkäsud

```sh
ubus call system board
cat /etc/openwrt_release
opkg list-installed
uci show network.lan
uci show network.wg_mgmt
uci show network.windows_admin
uci show firewall
uci show dropbear
uci show uhttpd
uci show wireless
wg show
ip -brief address
ip route
ss -lntup
```

## 12. Veel rakendamata või kontrollimata

- root-parooli määramine;
- LuCI HTTPS-i lõplik kontroll;
- SSH võtmeautentimise kontroll ja paroolautentimise keelamine;
- WireGuardi paigaldamine ja kliendi lisamine;
- WAN-i suletuse kontroll välisvõrgust;
- avaliku IP-aadressi, CGNAT-i või IPv6 kasutatavuse kontroll;
- DDNS, kui avalik aadress on dünaamiline;
- LuCI sertifikaadi usalduslahendus;
- Wi-Fi lõplik konfiguratsioon;
- serveri `decidim02` DHCP staatiline rent või muu püsiaadress.

## 13. Dokumendi haldus

- Märkida konfiguratsioon rakendatuks alles pärast kontrolli.
- Hoida üksikasjalikud toimingud eraldi tegevusjuhendis.
- Viidata skriptidele ja puhastatud konfiguratsioonidele suhteliste Git-linkidega.
- Mitte kanda Git-hoidlasse saladusi ega terviklikku OpenWrt varukoopiat.
