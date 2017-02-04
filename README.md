# Docker Haskell

Example of web application on Haskell

## Prerequisites

* Stack

On macOS all dependencies can be installed by brew:

```
$ brew install haskell-stack
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
