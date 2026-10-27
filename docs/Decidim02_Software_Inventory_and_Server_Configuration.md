## 9.1. Decidimi teenuse tegelik seis

Decidim teenus on käivitatud ja kontrollitud sisevõrgus. Tegemist on Docker Compose'i poolt käivitatud rakendusega, mille konteineris töötab `decidim/decidim:latest` ja mille juurde pääseb sisevõrgus aadressil `http://192.168.2.191:3000`.

Kontrollitud märgised:

- `docker compose ps` näitab, et konteinerid `decidim-db`, `decidim-redis` ja `decidim-app` on aktiivsed.
- `docker compose logs -f app` näitab, et Railsi / Puma rakenduse käivitus on edukas ja server kuulab pordil `3000`.
- `curl -I http://127.0.0.1:3000` annab vastuse `HTTP/1.1 301 Moved Permanently` ja suunab ümber HTTPS-ile.
- `curl -I http://192.168.2.191:3000` annab sama vastuse, mis tähendab, et rakendus on sisevõrgus kättesaadav HTTP-juurdepääsu tasemel.

Praegune tegelik seis:

- Decidim teenus on tööle läinud ja on sisevõrgus kontrollitud.
- TLS-i lõpetamine ei ole veel seadistatud. HTTP-päringud suunatakse automaatselt HTTPS-ile, kuid pöördproxi TLS-i lõpetamine ei ole veel seadistatud. Terminit „TLS termination“ kasutatakse inglise keeles; eesti keeles on sobiv variant „TLS-i lõpetamine“.
- WAN-poolne juurdepääs pole lubatud.
- Teenuse toimimine sisevõrgus ei anna alust järeldada, et WAN-poolne juurdepääs oleks toimiv ega et Decidim teenus oleks välisvõrgust kasutuskõlblik.

See tähendab, et järgmine tööetapp on TLS-i lõpetamise seadistamine pöördproxi või muus turvalises kihtis ning seejärel WAN-poolne juurdepääs tuleb eraldi kontrollida ja dokumenteerida, enne kui seda tohib kasutada välisvõrgust.
