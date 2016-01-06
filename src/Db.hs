module Db where

import Data.Text (Text)
import Data.Pool (Pool)
import Control.Monad.Logger (runStdoutLoggingT)
import Control.Monad.IO.Class (MonadIO)
import Control.Monad.Trans.Control (MonadBaseControl)
import Database.Persist.TH (mkPersist, sqlSettings, persistLowerCase, mkMigrate, share)
import Database.Persist.Sql (ConnectionPool, Entity(..), SqlBackend, SqlPersist, SqlPersistM,
                             runSqlPersistM, runSqlPersistMPool)
import Database.Persist.Postgresql (ConnectionString, createPostgresqlPool, runMigration)

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

createPool :: (MonadBaseControl IO m, MonadIO m) => ConnectionString -> Int -> m ConnectionPool
createPool connStr poolSize = runStdoutLoggingT (createPostgresqlPool connStr poolSize)

runMigrations :: SqlPersistM ()
runMigrations = runMigration migrateAll
