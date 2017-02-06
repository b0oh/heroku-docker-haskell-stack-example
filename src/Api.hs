module Api where

import Web.Spock (get, root, runSpock, spock, text)
import Web.Spock.Config (PoolOrConn(..), defaultSpockCfg)

api =
  get root $ text "Piu."

runApi port =
  do
    spockConfig <- defaultSpockCfg () PCNoDatabase ()
    runSpock port (spock spockConfig api)
