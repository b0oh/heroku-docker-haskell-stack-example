module Db (Band(..), Connection, createConnection, destroyConnection, migrate, selectBands) where

import Data.Text (Text)
import Database.PostgreSQL.Simple (Connection, close, connectPostgreSQL, query_, withTransaction)
import Database.PostgreSQL.Simple.FromRow (FromRow, fromRow, field)
import Database.PostgreSQL.Simple.Migration (MigrationCommand(..), MigrationContext(..), MigrationResult(..),
                                             runMigration)

data Band = Band {
  bandId :: Int,
  bandName :: Text
} deriving Show

instance FromRow Band where
  fromRow = Band <$> field <*> field


createConnection = connectPostgreSQL
destroyConnection = close

migrate :: Connection -> IO (MigrationResult String)
migrate connection =
  do
    withTransaction connection $ runMigration $
      MigrationContext MigrationInitialization True connection

    withTransaction connection $ runMigration $
      MigrationContext (MigrationDirectory "./migrations") True connection

selectBands :: Connection -> IO [Band]
selectBands connection =
  query_ connection "SELECT id, name FROM bands"
