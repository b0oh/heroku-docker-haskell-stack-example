module Main where

import Data.Maybe (fromMaybe)
import System.Environment (lookupEnv)

import Api

main :: IO ()
main = do
  port <- fmap (fromMaybe "3000") (lookupEnv "PORT")
  runApi (read port)
