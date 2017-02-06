# Docker Haskell

Example of web application on Haskell

## Prerequisites

* Stack
* VirtualBox
* Docker, docker-machine, docker-compose
* Heroku CLI

On macOS all dependencies except VirtualBox can be installed by brew:

```
$ brew install haskell-stack docker docker-machine docker-compose heroku
```

## Instalation

```
$ git clone git@github.com:meatmachine/heroku-docker-haskell-stack-example.git docker-haskell
$ cd docker-haskell
$ stack build --install-ghc
```

## Running

```
$ stack exec docker-haskell
$ open http://localhost:3000
```

## Docker

### Initial setup

```
$ docker-machine create -d virtualbox docker-default
```
### Setup per terminal session

```
$ eval "$(docker-machine env docker-default)"
```

### Run

```
$ docker-compose up -d web
$ open "http://$(docker-machine ip docker-default):3000"
```

### Stop

```
$ docker-compose stop web
```

## Deploy

### Initial setup

```
$ heroku login
$ heroku create
$ heroku plugins:install heroku-container-tools
```

### Release

```
$ heroku container:release
```
