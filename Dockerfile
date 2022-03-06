# docker run -p 443:443 -p 9999:9999 -v /docker/tor-bridge/keys:/var/lib/tor/keys -d --restart always --name tor-bridge btw1217/tor-bridge

# ubuntu base image
FROM ubuntu

# install tor repo dependencies
RUN apt-get update \
&& apt-get install apt-transport-https wget gpg -y \
&& wget -qO- https://deb.torproject.org/torproject.org/A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89.asc \
| gpg --dearmor | tee /usr/share/keyrings/tor-archive-keyring.gpg >/dev/null \
&& echo 'deb [signed-by=/usr/share/keyrings/tor-archive-keyring.gpg] https://deb.torproject.org/torproject.org focal main' \
>> /etc/apt/sources.list.d/tor.list \
&& echo 'deb-src [signed-by=/usr/share/keyrings/tor-archive-keyring.gpg] https://deb.torproject.org/torproject.org focal main' \
>> /etc/apt/sources.list.d/tor.list

# install tor and obfs4proxy
RUN apt-get update \
&& apt-get install tor deb.torproject.org-keyring obfs4proxy nyx -y

# copy config file
COPY --chown=debian-tor:debian-tor torrc /etc/tor/

# change to debian-tor
USER debian-tor

# run startup script
ENTRYPOINT tor

# ports used by tor
EXPOSE 443 9999