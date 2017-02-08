module Main where

import qualified Data.ByteString.Char8 as BS

import Data.Maybe (fromMaybe)
import System.Environment (getEnv, lookupEnv)

import Api
import Db

main :: IO ()
main = do
  port <- read . (fromMaybe "3000") <$> lookupEnv "PORT"
  dbUrl <- BS.pack <$> getEnv "DATABASE_URL"
  connection <- createConnection dbUrl
  migrate connection
  runApi port dbUrl
