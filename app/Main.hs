module Main where

import Data.Monoid ((<>))
import Data.Maybe (fromMaybe)
import System.Environment (lookupEnv)

import Api

main :: IO ()
main = do
  mport <- lookupEnv "PORT"
  let port = fromMaybe "3000" mport
  runApi (read port)
