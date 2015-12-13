FROM heroku/cedar:14

RUN apt-get install wget -y
RUN wget -q -O- https://s3.amazonaws.com/download.fpcomplete.com/ubuntu/fpco.key | apt-key add -
RUN echo 'deb http://download.fpcomplete.com/ubuntu trusty main' | tee /etc/apt/sources.list.d/fpco.list
RUN apt-get update && apt-get install stack -y

RUN mkdir -p /app/src
ADD docker-haskell.cabal /app/src
ADD stack.yaml /app/src
WORKDIR /app/src

RUN stack setup --resolver=lts-3.17
RUN stack install Spock --resolver=lts-3.17

ADD . /app/src

RUN stack build --resolver=lts-3.17
RUN mkdir -p /app/user && cp $(stack path --dist-dir)/build/docker-haskell/docker-haskell /app/user/docker-haskell
