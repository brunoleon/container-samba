#!BuildTag: my_container

FROM opensuse/tumbleweed
LABEL maintainer="Bruno Leon <bruno.leon@suse.com>"

RUN zypper --non-interactive install tini shadow samba

COPY docker-entrypoint.sh /entrypoint.sh
COPY smb.conf /etc/samba/smb.conf

EXPOSE 137/udp 138/udp 139 445

HEALTHCHECK --interval=60s --timeout=15s \
            CMD smbclient -L \\localhost -U % -m SMB3

ENTRYPOINT ["/tini", "--", "/entrypoint.sh"]
