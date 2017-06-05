FROM blitznote/debootstrap-amd64:16.04

COPY ./bin/* /usr/local/bin/

RUN chmod u=rwx,go=rx /usr/local/bin/* \
 && cp /etc/shadow /etc/shadow.org \
 && adduser --gecos '' user \
 && mkdir -p /usr/local/src/qwc2-demo-app /etc/dropbear /qwc2 /qwc2conf /run/secrets /home/user/.ssh /root/.config \
 && touch /run/secrets/id_rsa /run/secrets/user-pw /usr/local/src/qwc2-demo-app/yarnrc /var/log/stdout+stderr.log \
 && echo -e "Host github.com\n\tStrictHostKeyChecking no\n" > /home/user/.ssh/config \
 && chown -R user:user /usr/local/src /qwc2 /qwc2conf /home/user /run/secrets/id_rsa /run/secrets/user-pw /var/log/stdout+stderr.log \
 && chmod u=rwX,go= /home/user/.ssh \
 && chmod u=r,go= /run/secrets/id_rsa /run/secrets/user-pw /home/user/.ssh/config \
 && ln -s /run/secrets/id_rsa /home/user/.ssh/ \
 && ln -s /usr/local/src/qwc2-demo-app /root/.config/yarn \
 && ln -s /usr/local/src/qwc2-demo-app/yarnrc /root/ \
 && curl -sL https://deb.nodesource.com/setup_7.x | bash - \
 && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
 && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
 && ln -s /usr/local/bin/* /usr/bin \
 && ln -s /sbin/ldconfig /usr/bin \
 && ln -s /sbin/start-stop-daemon /usr/bin \
 && apt-get update -qq \
 && apt-get install -yq nano dropbear-bin git nodejs yarn \
 && rm -rf /var/lib/apt/lists/* /usr/local/src/qwc2-demo-app

VOLUME /qwc2 /qwc2conf /run/secrets

ENV USER=user
ENV SSH_PORT=22
ENV QWC2_GIT_REPOSITORY=https://github.com/qgis/qwc2-demo-app.git
ENV QWC2_GIT_BRANCH=master
ENV XDG_CONFIG_HOME=/home/user/.config
EXPOSE $SSH_PORT

CMD ["/bin/sh", "-c", "/usr/local/bin/entrypoint.sh"]
