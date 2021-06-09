FROM frolvlad/alpine-glibc:latest

ENV PATH /usr/local/texlive/2021/bin/x86_64-linuxmusl:$PATH

RUN apk add --no-cache curl perl fontconfig-dev freetype-dev inkscape && \
    apk add --no-cache --virtual .fetch-deps xz tar wget && \
    mkdir /tmp/install-tl-unx && \
    curl -L ftp://tug.org/historic/systems/texlive/2021/install-tl-unx.tar.gz | \
      tar -xz -C /tmp/install-tl-unx --strip-components=1 && \
    printf "%s\n" \
      "selected_scheme scheme-basic" \
      "tlpdbopt_install_docfiles 0" \
      "tlpdbopt_install_srcfiles 0" \
      > /tmp/install-tl-unx/texlive.profile && \
    /tmp/install-tl-unx/install-tl \
      --profile=/tmp/install-tl-unx/texlive.profile && \
    tlmgr install \
      collection-latexextra \
      collection-fontsrecommended \
      collection-langjapanese \
      latexmk && \
    rm -fr /tmp/install-tl-unx && \
    apk del .fetch-deps

# RUN apk add --no-cache font-noto-cjk

ENV TEXMFLOCAL /usr/local/texlive/texmf-local
COPY fonts/* $TEXMFLOCAL/fonts/truetype/public/
COPY maps/* $TEXMFLOCAL/fonts/map/dvipdfmx/genshin/
RUN mktexlsr && \
  kanji-config-updmap-sys genshin

WORKDIR /workdir

CMD ["sh"]
