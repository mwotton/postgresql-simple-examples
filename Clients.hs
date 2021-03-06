-- source: http://www.stephendiehl.com/posts/haskell_web.html
{-# LANGUAGE OverloadedStrings #-}

module Clients where

import Data.Text
import Data.ByteString (ByteString)
import Control.Applicative
import Control.Monad
import Database.PostgreSQL.Simple
import Database.PostgreSQL.Simple.FromRow

data Client = Client { firstName :: Text
                     , lastName :: Text
                     , clientLocation :: Location
                     } deriving (Show)

data Location = Location { address :: Text
                         , location :: Text
                         } deriving (Show)

uri :: ByteString
uri = "postgres://natxo@localhost/helloworld"

instance FromRow Location where
  fromRow = Location <$> field <*> field

instance FromRow Client where
  fromRow = Client <$> field <*> field <*> liftM2 Location field field


queryClients :: Connection -> IO [Client]
queryClients c = query_ c
    "SELECT c.firstname, c.lastname, l.address, l.location \
\    FROM clients c, locations l \
\    WHERE c.location = l.id"


main :: IO ()
main = do
  conn <- connectPostgreSQL uri
  clients <- queryClients conn
  mapM_ (putStrLn . show) clients
