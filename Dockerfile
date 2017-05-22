FROM blitznote/debootstrap-amd64:16.04

COPY ./bin/* /usr/local/bin/

RUN chmod u=rwx,go=rx /usr/local/bin/* \
 && cp /etc/shadow /etc/shadow.org \
 && adduser --gecos '' user \
 && mkdir -p /etc/dropbear /qwc2 /qwc2conf /run/secrets /home/user/.ssh \
 && touch /run/secrets/ssh-key /run/secrets/user-pw \
 #&& echo `perl -e "print crypt(\`date\`,'Q4')"` > /run/secrets/user-pw \
 && chown user:user /home/user/.ssh /run/secrets/ssh-key /run/secrets/user-pw \
 && chmod u=rwX,go= /home/user/.ssh \
 && chmod u=r,go= /run/secrets/ssh-key /run/secrets/user-pw \
 && ln -s /run/secrets/ssh-key /home/user/.ssh/id_rsa \
 && curl -sL https://deb.nodesource.com/setup_7.x | bash - \
 && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
 && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
 && ln -s /usr/local/bin/* /usr/bin \
 && ln -s /sbin/ldconfig /usr/bin \
 && ln -s /sbin/start-stop-daemon /usr/bin \
 && apt-get update -qq \
 && apt-get install -yq nano dropbear-bin git nodejs yarn \
 && rm -rf /var/lib/apt/lists/* \

VOLUME /qwc2 /qwc2conf /run/secrets

ENV USER=user
ENV SSH_PORT=22
ENV QWC2_GIT_REPOSITORY=https://github.com/qgis/qwc2-demo-app.git
ENV QWC2_GIT_BRANCH=master
EXPOSE $SSH_PORT

CMD ["/bin/sh", "-c", "/usr/local/bin/entrypoint.sh"]
