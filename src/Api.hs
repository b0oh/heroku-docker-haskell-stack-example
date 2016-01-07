module Api where

import Data.Text (Text)
import Data.Aeson (ToJSON(..), (.=), object)
import qualified Data.Map as M
import Web.Spock.Safe

import qualified Db (runDb)
import Db hiding (runDb)

type ApiAction ctx a = SpockActionCtx ctx SqlBackend () () a

instance ToJSON (Entity Artist) where
  toJSON (Entity key val) =
    object [
      "id" .= key,
      "name" .= artistName val
    ]

runDb action = runQuery $ \conn -> Db.runDb conn action

respond :: ToJSON o => Text -> o -> ApiAction ctx a
respond root object = json $ M.fromList [(root, object)]

api = do
  get root $
    text "Hello World"
  get "artists" $ do
    artists <- runDb selectArtists
    respond "artists" artists

runApi port pool = runSpock port spock'
  where
    spock' = spock (config pool) api
    config pool = defaultSpockCfg () (PCPool pool) ()
