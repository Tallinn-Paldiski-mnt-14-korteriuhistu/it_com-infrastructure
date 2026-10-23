# OpenWrt Router – Secure Management Runbook

## Otstarve

Tegevusjuhend OpenWrt ruuteri turvalise haldusmudeli rakendamiseks ja kontrollimiseks. Püsiva konfiguratsiooni kirjeldus paikneb failis [`OpenWrt_Router_Software_Inventory_and_Configuration.md`](OpenWrt_Router_Software_Inventory_and_Configuration.md).

## Lähteandmed

- LAN-aadress: `192.168.2.1/24`
- LAN-võrk: `192.168.2.0/24`
- WireGuardi võrk: `10.14.0.0/24`
- Ruuteri WireGuardi aadress: `10.14.0.1/24`
- Esimene klient: `10.14.0.2/32`
- WireGuardi port: UDP `51820`

## Rakendamise järjekord

1. Ühendada haldusarvuti LAN-kaabliga ja hoida olemasolev seanss avatuna.
2. Määrata root-parool ning teha konfiguratsiooni varukoopia.
3. Luua ja lisada SSH Ed25519 avalik võti.
4. Kontrollida võtmega sisselogimist uues seansis.
5. Kontrollida LuCI HTTPS-i ja lülitada sisse HTTP ümbersuunamine.
6. Keelata SSH paroolautentimine.
7. Paigaldada WireGuard ja LuCI WireGuardi tugi.
8. Luua ruuteri ja kliendi võtmed.
9. Rakendada WireGuardi liidese ning piiratud tulemüüritsooni konfiguratsioon.
10. Kontrollida ühendust mobiilside või muu välisvõrgu kaudu.
11. Kontrollida, et WAN-ist on avatud ainult UDP `51820`.

## Olulised ohutusreeglid

- SSH paroolautentimist ei tohi keelata enne võtmega sisselogimise edukat katset.
- WAN-ist ei avata SSH-d ega LuCI-t.
- WireGuardi privaatvõtmeid ega eeljagatud võtit ei kanta Git-hoidlasse.
- Anonüümset UCI tulemüürireeglit `@rule[N]` ei kustutata enne täpse kirje kontrollimist.
- Esmane WireGuardi katse tehakse väljaspool ruuteri LAN-i.

## Käsustik ja skript

Täielik kontrollitud skript säilitatakse Git-hoidlas failina:

```text
openwrt/scripts/configure-wireguard-management.sh
```

Skripti nõutavad parameetrid:

```text
WG_IF=wg_mgmt
WG_PORT=51820
WG_ROUTER_ADDRESS=10.14.0.1/24
WG_CLIENT_ADDRESS=10.14.0.2/32
WG_CLIENT_PUBLIC_KEY=<Windowsi kliendi avalik võti>
```

### Root-parool ja varukoopia

```sh
passwd
sysupgrade -b /tmp/openwrt-before-secure-management.tar.gz
```

Varukoopia tuleb laadida LAN-i kaudu haldusarvutisse ja hoida väljaspool Git-hoidlat.

### SSH võtme kontroll

Windowsis:

```powershell
ssh -i "$env:USERPROFILE\.ssh\openwrt_router_ed25519" root@192.168.2.1
```

Pärast edukat kontrolli ruuteris:

```sh
uci set dropbear.@dropbear[0].PasswordAuth='off'
uci set dropbear.@dropbear[0].RootPasswordAuth='off'
uci commit dropbear
/etc/init.d/dropbear restart
```

### LuCI HTTPS

```sh
uci show uhttpd
ls -l /etc/uhttpd.crt /etc/uhttpd.key
ss -lntp | grep -E ':(80|443)[[:space:]]'
uci set uhttpd.main.redirect_https='1'
uci commit uhttpd
/etc/init.d/uhttpd restart
```

Kontrollaadress:

```text
https://192.168.2.1/
```

### WireGuardi paketid

```sh
opkg update
opkg install wireguard-tools luci-proto-wireguard qrencode
/etc/init.d/rpcd restart
```

### WireGuardi võtmed

```sh
umask 077
mkdir -p /etc/wireguard
wg genkey | tee /etc/wireguard/router-private.key   | wg pubkey > /etc/wireguard/router-public.key
wg genpsk > /etc/wireguard/windows-client.psk
chmod 600 /etc/wireguard/router-private.key
chmod 644 /etc/wireguard/router-public.key
chmod 600 /etc/wireguard/windows-client.psk
```

### Windowsi kliendi põhimõtteline konfiguratsioon

```ini
[Interface]
PrivateKey = <Windowsi kliendi privaatvõti>
Address = 10.14.0.2/32

[Peer]
PublicKey = <ruuteri avalik võti>
PresharedKey = <kliendi eeljagatud võti>
Endpoint = <avalik IP või DDNS-nimi>:51820
AllowedIPs = 10.14.0.1/32
PersistentKeepalive = 25
```

## Kontroll pärast rakendamist

Ruuteris:

```sh
uci show network.lan
uci show network.wg_mgmt
uci show network.windows_admin
uci show firewall.wg_mgmt_zone
uci show firewall.allow_wireguard_wan
uci show firewall.allow_ssh_wg
uci show firewall.allow_luci_https_wg
uci show dropbear
uci show uhttpd
wg show
ss -lntup | grep -E ':(22|80|443|51820)[[:space:]]'
```

Oodatavad LAN-i väärtused:

```text
network.lan.ipaddr='192.168.2.1'
network.lan.netmask='255.255.255.0'
```

Välisvõrku ühendatud Windowsi arvutis:

```powershell
ping 10.14.0.1
ssh -i "$env:USERPROFILE\.ssh\openwrt_router_ed25519" root@10.14.0.1
```

LuCI:

```text
https://10.14.0.1/
```

## Taastamine

WireGuardi konfiguratsiooni eemaldamine LAN-ist:

```sh
uci -q delete network.wg_mgmt
uci -q delete network.windows_admin
uci -q delete firewall.wg_mgmt_zone
uci -q delete firewall.allow_wireguard_wan
uci -q delete firewall.allow_ssh_wg
uci -q delete firewall.allow_luci_https_wg
uci -q delete firewall.allow_ping_wg
uci commit network
uci commit firewall
/etc/init.d/network restart
/etc/init.d/firewall restart
```

SSH paroolautentimise ajutine taastamine ainult LAN-ist:

```sh
uci set dropbear.@dropbear[0].PasswordAuth='on'
uci set dropbear.@dropbear[0].RootPasswordAuth='on'
uci commit dropbear
/etc/init.d/dropbear restart
```

Pärast võtmeprobleemi kõrvaldamist tuleb paroolautentimine uuesti keelata.

## Rakendamise protokoll

Pärast rakendamist lisada vähemalt:

- kuupäev ja rakendaja;
- OpenWrt täpne versioon;
- kasutatud skripti Git commit'i räsi;
- kontrollide tulemused;
- kõrvalekalded kavandist;
- taastamiskatse või varukoopia olemasolu kinnitus.
