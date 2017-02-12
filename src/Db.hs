module Db (Band(..), Connection, createConnection, destroyConnection, migrate, selectBands) where

import Data.Text (Text)
import Database.PostgreSQL.Simple (Connection, close, connectPostgreSQL, query_, withTransaction)
import Database.PostgreSQL.Simple.FromRow (FromRow, fromRow, field)
import Database.PostgreSQL.Simple.Migration (MigrationCommand(..), MigrationContext(..), MigrationResult(..),
                                             runMigration)

import Config

data Band = Band {
  bandId :: Int,
  bandName :: Text
} deriving Show

instance FromRow Band where
  fromRow = Band <$> field <*> field

createConnection dbConfig = do
  url <- require dbConfig "url"
  connectPostgreSQL url

destroyConnection = close

migrate :: Config -> Connection -> IO (MigrationResult String)
migrate config connection =
  do
    migrationsPath <- require config "migrations_path"

    withTransaction connection $ runMigration $
      MigrationContext MigrationInitialization True connection

    withTransaction connection $ runMigration $
      MigrationContext (MigrationDirectory migrationsPath) True connection

selectBands :: Connection -> IO [Band]
selectBands connection =
  query_ connection "SELECT id, name FROM bands"
