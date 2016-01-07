module Main where

import Data.Maybe (fromMaybe)
import qualified Data.ByteString.Char8 as BS
import System.Environment (getEnv, lookupEnv)

import Db
import Api hiding (runDb)

main :: IO ()
main = do
  port <- fmap (fromMaybe "3000") (lookupEnv "PORT")
  dbUrl <- getEnv "DATABASE_URL"
  pool <- createPool (BS.pack dbUrl) 10
  runDb pool runMigrations
  runApi (read port) pool
