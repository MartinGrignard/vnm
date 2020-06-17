# INSTALL DEPENDENCIES ----------------------------------------------------------------
FROM library/tomcat:9-jre11

ENV GUACAMOLE_HOME=/app/guacamole \
    GUAC_VER=1.1.0

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y \
        libcairo2-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        libtool-bin \
        libossp-uuid-dev \
        libavcodec-dev \
        libavutil-dev \
        libswscale-dev \
        freerdp2-dev \
        libpango1.0-dev \
        libssh2-1-dev \
        libtelnet-dev \
        libvncserver-dev \
        libwebsockets-dev \
        libssl-dev \
        libwebp-dev \
        curl \
        build-essential \
    && rm -rf /var/lib/apt/lists/* \
    && ln -s /usr/local/lib/freerdp /usr/lib/x86_64-linux-gnu/freerdp \
    && mkdir -p ${GUACAMOLE_HOME}/lib ${GUACAMOLE_HOME}/extensions

# INSTALL GUACAMOLE -------------------------------------------------------------------
WORKDIR ${GUACAMOLE_HOME}

# Install guacamole server
RUN curl -SLO "http://apache.org/dyn/closer.cgi?action=download&filename=guacamole/${GUAC_VER}/source/guacamole-server-${GUAC_VER}.tar.gz" \
    && tar -xzf guacamole-server-${GUAC_VER}.tar.gz \
    && cd guacamole-server-${GUAC_VER} \
    && ./configure \
    && make -j$(getconf _NPROCESSORS_ONLN) \
    && make install \
    && cd .. \
    && rm -rf guacamole-server-${GUAC_VER} guacamole-server-{GUAC_VER}.tar.gz \
    && ldconfig

# Install guacamole client
RUN rm -rf ${CATALINA_HOME}/webapps/ROOT \
    && curl -SLo ${CATALINA_HOME}/webapps/ROOT.war "http://apache.org/dyn/closer.cgi?action=download&filename=guacamole/${GUAC_VER}/binary/guacamole-${GUAC_VER}.war"

COPY root /
