{-# LANGUAGE TemplateHaskell #-}
module Lyrics.Scrape.Entities
  ( Artist(..)
  , Song(..)
  , songTitle
  , songArtist
  , songAlbum
  , songYear
  , songLyrics
  , songURL
  ) where

import Control.Lens.TH
import Data.Text (Text)

data Artist = Artist { arName :: Text
                     , arURL :: String
                     } deriving (Eq, Show)

data Song = Song { _songTitle :: Maybe Text
                 , _songArtist :: Maybe Text
                 , _songAlbum :: Maybe Text
                 , _songYear :: Maybe Int
                 , _songLyrics :: [Text]
                 , _songURL :: String
                 } deriving (Eq, Show)
makeLenses ''Song

