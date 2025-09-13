services:
  wireguard:
    image: linuxserver/wireguard:latest
    container_name: nas.vpn
    cap_add:
      - NET_ADMIN
      - SYS_MODULE
    environment:
      - PUID=1000
      - PGID=1000
      - SERVERURL={$SRV_URL}
      - PEERS=1
      - INTERNAL_SUBNET=10.99.99.0
    volumes:
      - ./config/wireguard:/config
      - /lib/modules:/lib/modules
    ports:
      - 51820:51820/udp
    sysctls:
      - net.ipv4.conf.all.src_valid_mark=1
    restart: unless-stopped
    networks:
      nas_net:

  duckdns:
    image: linuxserver/duckdns:latest
    container_name: nas.dns
    environment:
      - PUID=1000
      - PGID=1000
      - SUBDOMAINS={$SUBDOMAINS}
      - TOKEN=
      - LOG_FILE=true
    restart: unless-stopped
    networks:
      nas_net:

  samba:
    build: ./image/samba
    image: samba:latest
    container_name: nas.samba
    environment:
      - PUID=1000
      - PGID=1000
      - SAMBA_WORKGROUP=WORKGROUP
      - SAMBA_LOG_LEVEL=0
    volumes:
      - ~/docker-nas/shared:{$SHARE}
      - samba_data:/etc
      - samba_lib:/var/lib/samba
    ports:
      - "445:445"
      - "139:139"
      - "10000:10000"
    restart: unless-stopped
    networks:
      nas_net:

volumes:
  samba_data:
  samba_lib:

networks:
  nas_net:
    driver: bridge
