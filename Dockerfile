FROM heroku/cedar:14

RUN wget -q -O- https://s3.amazonaws.com/download.fpcomplete.com/ubuntu/fpco.key | apt-key add -
RUN echo 'deb http://download.fpcomplete.com/ubuntu trusty main' | tee /etc/apt/sources.list.d/fpco.list
RUN apt-get update && apt-get install stack -y

RUN stack build http-types wai warp --install-ghc --resolver=lts-7.19
RUN stack build Spock --resolver=lts-7.19
COPY stack.yaml /app/src/
RUN stack build postgresql-simple postgresql-simple-migration --resolver=lts-7.19

RUN mkdir -p /app/src

ADD . /app/src
WORKDIR /app/src

RUN stack build
RUN mkdir /app/user
RUN cp -r ./migrations /app/user
RUN cp $(stack path --dist-dir)/build/docker-haskell/docker-haskell /app/user/docker-haskell
