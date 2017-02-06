FROM heroku/cedar:14

RUN wget -q -O- https://s3.amazonaws.com/download.fpcomplete.com/ubuntu/fpco.key | apt-key add -
RUN echo 'deb http://download.fpcomplete.com/ubuntu trusty main' | tee /etc/apt/sources.list.d/fpco.list
RUN apt-get update && apt-get install stack -y

RUN stack build http-types wai warp --install-ghc --resolver=lts-7.19

ADD . /app/src
WORKDIR /app/src

RUN stack build --resolver=lts-7.19
RUN mkdir -p /app/user && cp $(stack path --dist-dir)/build/docker-haskell/docker-haskell /app/user/docker-haskell
