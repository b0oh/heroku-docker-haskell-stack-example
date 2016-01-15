module Db (ConnectionPool, SqlBackend, Entity(..), Artist(..), runDb, createPool, runMigrations, selectArtists) where

import Data.Text (Text)
import Data.Pool (Pool)
import Control.Monad.Logger (runStdoutLoggingT)
import Control.Monad.IO.Class (MonadIO)
import Control.Monad.Trans.Control (MonadBaseControl)
import Database.Persist.TH (mkPersist, sqlSettings, persistLowerCase, mkMigrate, share)
import Database.Persist.Sql (ConnectionPool, Entity(..), SqlBackend, SqlPersist, SqlPersistM, SqlPersistT,
                             runSqlPersistM, runSqlPersistMPool, selectList)
import Database.Persist.Postgresql (ConnectionString, createPostgresqlPool, runMigration)

import Config

share [mkPersist sqlSettings, mkMigrate "migrateAll"] [persistLowerCase|
Artist
  name Text
  deriving Show
|]

class DbBackend b where
  runDb :: b -> SqlPersistM a -> IO a

instance DbBackend SqlBackend where
  runDb = flip runSqlPersistM

instance DbBackend (Pool SqlBackend) where
  runDb = flip runSqlPersistMPool

createPool :: Config -> IO ConnectionPool
createPool config = do
  connStr <- require config "url"
  poolSize <- lookupDefault 10 config "pool_size"
  runStdoutLoggingT (createPostgresqlPool connStr poolSize)

runMigrations :: SqlPersistM ()
runMigrations = runMigration migrateAll

selectArtists :: MonadIO m => SqlPersistT m [Entity Artist]
selectArtists = selectList [] []
