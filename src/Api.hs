module Api (runApi) where

import Data.Text (Text)
import Data.Pool (Pool)
import Control.Monad.IO.Class (liftIO)
import Data.Aeson (ToJSON(..), (.=), object)
import qualified Data.Map as M
import Network.Wai.Middleware.Static ((>->), addBase, noDots, staticPolicy)
import Web.Spock.Safe

import Config
import qualified Db (runDb)
import Db hiding (runDb)

type ApiAction ctx a = SpockActionCtx ctx SqlBackend () () a

instance ToJSON ([Entity Artist]) where
  toJSON artists = object ["artists" .=  map toJSON artists]

instance ToJSON (Entity Artist) where
  toJSON (Entity key val) =
    object [
      "id" .= key,
      "name" .= artistName val
    ]

runDb action = runQuery $ \conn -> Db.runDb conn action

api = do
  get root $
    text "Hello World"
  get "artists" $ do
    artists <- runDb selectArtists
    json artists

runApi :: Config -> ConnectionPool -> IO ()
runApi config pool = do
  port <- liftIO (require config "port")
  runSpock (read port) spock'
  where
    spock' = spock spockConfig app
    spockConfig = defaultSpockCfg () (PCPool pool) ()
    app = do
      staticPath <- liftIO (lookupDefault "static" config "static_path")
      middleware $ staticPolicy (noDots >-> addBase staticPath)
      api
