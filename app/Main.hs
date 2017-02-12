module Main where

import Data.Maybe (fromMaybe)
import System.Environment (getEnv, lookupEnv)

import Config
import Api
import Db

main :: IO ()
main =
  do
    config <- loadConfig
    let dbConfig = subconfig "db" config
    connection <- createConnection dbConfig
    migrate dbConfig connection
    runApi config
