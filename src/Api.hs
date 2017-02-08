module Api (runApi) where

import Data.ByteString (ByteString)
import Data.Text (Text)
import Data.Aeson (ToJSON(..), (.=), object)
import Web.Spock (SpockM, SpockActionCtx, get, json, middleware, root, runSpock, runQuery, spock, text)
import Web.Spock.Config (PoolOrConn(..), ConnBuilder(..), PoolCfg(..), defaultSpockCfg)

import qualified Data.Map as M

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

runApi :: Int -> ByteString -> IO ()
runApi port dbUrl =
  do
    spockConfig <- defaultSpockCfg () (spockDbConf dbUrl) ()
    runSpock port (spock spockConfig api)

spockDbConf :: ByteString -> PoolOrConn Connection
spockDbConf dbUrl =
  PCConn (ConnBuilder (createConnection dbUrl) destroyConnection poolCfg)
  where
    poolCfg = PoolCfg { pc_stripes = 5, pc_resPerStripe = 5, pc_keepOpenTime = 60 }
