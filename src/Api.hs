module Api where

import Web.Spock.Safe

api = do
  get root $
    text "Hello World"

runApi port = runSpock port spock'
  where
    spock' = spock config api
    config = defaultSpockCfg Nothing PCNoDatabase ()
