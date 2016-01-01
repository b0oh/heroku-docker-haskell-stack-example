module Db where
import Data.Text (Text)
import Data.Pool (Pool)
import Control.Monad.Logger (runStdoutLoggingT)
import Database.Persist.TH (mkPersist, sqlSettings, persistLowerCase, mkMigrate, share)
import Database.Persist.Sql (Entity(..), SqlBackend, SqlPersist, SqlPersistM,
                             runSqlPersistM, runSqlPersistMPool)
import Database.Persist.Postgresql (createPostgresqlPool)

share [mkPersist sqlSettings, mkMigrate "migrateAll"] [persistLowerCase|
Todo
  description Text
  completed Bool
  deriving Show
|]

class DbBackend b where
  runDb :: b -> SqlPersistM a -> IO a

instance DbBackend SqlBackend where
  runDb = flip runSqlPersistM

instance DbBackend (Pool SqlBackend) where
  runDb = flip runSqlPersistMPool

createPool connStr poolSize = runStdoutLoggingT (createPostgresqlPool connStr poolSize)
