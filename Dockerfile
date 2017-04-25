FROM blitznote/debootstrap-amd64:16.04

ENV PASSWORD=rancher

COPY ./bin/* /usr/local/bin/

RUN chmod u=rwx,go= /usr/local/bin/* \
 && usermod -p `perl -e "print crypt($PASSWORD,"Q4")"` root \
 && mkdir /etc/dropbear \
 && curl -sL https://deb.nodesource.com/setup_7.x | bash - \
 && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
 && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
 && ln -s /usr/local/bin/* /usr/bin \
 && ln -s /sbin/ldconfig /usr/bin \
 && ln -s /sbin/start-stop-daemon /usr/bin \
 && apt-get update -qq \
 && apt-get install -yq nano dropbear-bin git nodejs yarn \
 && dropbear -FR

VOLUME /root/.ssh /qwc2 /qwc2conf

EXPOSE 22

CMD dropbear -FR
