FROM heroku/cedar:14

RUN mkdir -p /app/user/bin /app/.profile.d /app/build

ENV HOME /app/user
ENV STACK_VERSION 1.0.0
ENV STACK_PATH $HOME/bin
ENV PATH $STACK_PATH:$PATH

RUN echo export HOME=/app/user > /app/.profile.d/home
RUN echo export PATH=$STACK_PATH:\$PATH > /app/.profile.d/path

RUN apt-get update
RUN apt-get install libgmp-dev zlib1g-dev -y
RUN wget -qO- https://github.com/commercialhaskell/stack/releases/download/v$STACK_VERSION/stack-$STACK_VERSION-linux-x86_64.tar.gz | tar zxf -  --wildcards '*/stack' --to-stdout > $STACK_PATH/stack && \
    chmod a+x $STACK_PATH/stack

ADD docker-haskell.cabal /app/build
ADD stack.yaml /app/build
WORKDIR /app/build

RUN stack install Spock persistent persistent-postgresql persistent-template --install-ghc --resolver=lts-3.17

ADD . /app/build

RUN stack build --resolver=lts-3.17
RUN cp $(stack path --dist-dir)/build/docker-haskell/docker-haskell /app/user/docker-haskell
