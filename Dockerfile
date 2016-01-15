FROM heroku/cedar:14

RUN wget -q -O- https://s3.amazonaws.com/download.fpcomplete.com/ubuntu/fpco.key | apt-key add -
RUN echo 'deb http://download.fpcomplete.com/ubuntu trusty main' | tee /etc/apt/sources.list.d/fpco.list
RUN apt-get update && apt-get install stack -y

RUN mkdir -p /app/user /app/build

ADD docker-haskell.cabal /app/build
ADD stack.yaml /app/build
WORKDIR /app/build

RUN stack build configurator persistent persistent-postgresql persistent-template Spock --install-ghc --resolver=lts-3.17

ADD . /app/build

RUN stack build --resolver=lts-3.17
RUN cp $(stack path --dist-dir)/build/docker-haskell/docker-haskell /app/user/docker-haskell
