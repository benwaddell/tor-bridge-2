# docker run -p 80:80 -p 9080:9080 -v tor-bridge-2-keys:/var/lib/tor/keys -d --pull always --restart always --name tor-bridge-2 benwaddell/tor-bridge-2

# ubuntu base image
FROM ubuntu:22.04

# ports used by tor
EXPOSE 80 9080

# install tor repo dependencies
RUN apt-get update \
&& apt-get install apt-transport-https wget gpg -y \
&& wget -qO- https://deb.torproject.org/torproject.org/A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89.asc \
| gpg --dearmor | tee /usr/share/keyrings/tor-archive-keyring.gpg >/dev/null \
&& echo 'deb [signed-by=/usr/share/keyrings/tor-archive-keyring.gpg] https://deb.torproject.org/torproject.org jammy main' \
>> /etc/apt/sources.list.d/tor.list \
&& echo 'deb-src [signed-by=/usr/share/keyrings/tor-archive-keyring.gpg] https://deb.torproject.org/torproject.org jammy main' \
>> /etc/apt/sources.list.d/tor.list

# install tor, obfs4proxy, and nyx
RUN apt-get update \
&& apt-get install tor deb.torproject.org-keyring obfs4proxy nyx -y

# copy config file
COPY --chown=debian-tor:debian-tor torrc /etc/tor/

# set permissions on docker volume
RUN mkdir -p /var/lib/tor/keys \
&& chmod 2700 /var/lib/tor/keys \
&& chown -R debian-tor:debian-tor /var/lib/tor

# change to debian-tor
USER debian-tor

# run startup script
ENTRYPOINT tor
