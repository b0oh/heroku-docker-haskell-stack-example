module Config (Config, loadConfig, lookupDefault, require, subconfig) where

import System.Environment (getArgs)
import Data.Configurator.Types (Config)
import Data.Configurator (Worth(..), load, lookupDefault, require, subconfig)

loadConfig :: IO Config
loadConfig = do
  args <- getArgs
  case args of
    (configPath : _) ->
      load [Required configPath]
    _ ->
      error "Usage: docker-haskell path/to/config"
