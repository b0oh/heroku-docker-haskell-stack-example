module Main where

import Config
import Db
import Api

main :: IO ()
main = do
  config <- loadConfig
  pool <- createPool (subconfig "db" config)
  runDb pool runMigrations
  runApi (subconfig "api" config) pool
