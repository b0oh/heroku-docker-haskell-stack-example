module Api (runApi) where

import qualified Data.Map as M

import Control.Monad.IO.Class (liftIO)
import Data.ByteString (ByteString)
import Data.Text (Text)
import Data.Aeson (ToJSON(..), (.=), object)
import Web.Spock (SpockM, SpockActionCtx, get, json, middleware, root, runSpock, runQuery, spock, text)
import Web.Spock.Config (PoolOrConn(..), ConnBuilder(..), PoolCfg(..), defaultSpockCfg)

import Config
import Db

type ApiAction ctx a = SpockActionCtx ctx Connection () () a

instance ToJSON Band where
  toJSON band =
    object [
      "id" .= bandId band,
      "name" .= bandName band
    ]

respond :: ToJSON o => Text -> o -> ApiAction ctx a
respond root object =
  json $ M.fromList [(root, object)]

api :: SpockM Connection () () ()
api =
  do
    get root $
      text "Piu."

    get "bands" $ do
      bands <- runQuery selectBands
      respond "bands" bands

runApi :: Config -> IO ()
runApi config =
  do
    let apiConfig = subconfig "api" config
    let dbConfig = subconfig "db" config
    port <- require apiConfig "port"
    spockDbConfig <- makeSpockDbConf dbConfig
    spockConfig <- defaultSpockCfg () spockDbConfig ()
    runSpock (read port) (spock spockConfig api)

makeSpockDbConf :: Config -> IO (PoolOrConn Connection)
makeSpockDbConf dbConfig =
  do
    poolSize <- require dbConfig "pool_size"
    return $ PCConn (ConnBuilder (createConnection dbConfig) destroyConnection (poolCfg poolSize))
  where
    poolCfg poolSize = PoolCfg { pc_stripes = poolSize, pc_resPerStripe = 5, pc_keepOpenTime = 60 }
