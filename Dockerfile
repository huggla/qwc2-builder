FROM blitznote/debootstrap-amd64:16.04

COPY ./bin/* /usr/local/bin/

RUN chmod u=rwx,go=rx /usr/local/bin/* \
 && mkdir /etc/dropbear /qwc2 /qwc2conf /run/secrets \
 && curl -sL https://deb.nodesource.com/setup_7.x | bash - \
 && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
 && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
 && ln -s /usr/local/bin/* /usr/bin \
 && ln -s /sbin/ldconfig /usr/bin \
 && ln -s /sbin/start-stop-daemon /usr/bin \
 && apt-get update -qq \
 && apt-get install -yq nano dropbear-bin git nodejs yarn \
 && rm -rf /var/lib/apt/lists/* \
 && useradd --create-home user \
 && touch /home/user/.ssh /run/secrets/ssh-key \
 && chown user:user /home/user/.ssh /run/secrets/ssh-key \
 && chmod u=r,go= /home/user/.ssh /run/secrets/ssh-key \
 && ln -s /run/secrets/ssh-key /home/user/.ssh/id_rsa

VOLUME /qwc2 /qwc2conf /run/secrets

EXPOSE 22

ENV USER=user
ENV PASSWORD=password

CMD ["/bin/sh", "-c", "/usr/local/bin/set-user"]
