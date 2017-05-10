FROM blitznote/debootstrap-amd64:16.04

COPY ./bin/* /usr/local/bin/

ENV USER=user
ENV PASSWORD=password

RUN chmod u=rwx,go=rx /usr/local/bin/* \
 && mkdir /etc/dropbear \
 && curl -sL https://deb.nodesource.com/setup_7.x | bash - \
 && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
 && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
 && ln -s /usr/local/bin/* /usr/bin \
 && ln -s /sbin/ldconfig /usr/bin \
 && ln -s /sbin/start-stop-daemon /usr/bin \
 && apt-get update -qq \
 && apt-get install -yq nano dropbear-bin git nodejs yarn \
 && rm -rf /var/lib/apt/lists/* \
 && useradd --create-home $USER

VOLUME /home/user/.ssh /qwc2 /qwc2conf

EXPOSE 22

CMD ["/bin/sh", "-c", "/usr/local/bin/set-user"]
