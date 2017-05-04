{-# LANGUAGE OverloadedStrings #-}

module Lyrics.Scrape
  ( handleArtistsPage
  , handleDiscographyPage
  , handleSongPage
  , scrape
  ) where

import Control.Lens ((<&>))
import Control.Monad.Trans.Maybe

import Lyrics.Scrape.HTML (getArtists, getSongLinks, getSongLyrics)
import Lyrics.Scrape.HTTP (openURL)
import Lyrics.Scrape.Entities (Artist(..), Song)
import Lyrics.Utils (prefixRoot)

artistLetters :: [String]
artistLetters = "19" : map pure ['A'..'Z']

linkFromLetter :: String -> String
linkFromLetter = prefixRoot . (++".html")

handleArtistsPage :: String -> MaybeT IO [Artist]
handleArtistsPage url = openURL url getArtists

handleDiscographyPage :: Artist -> MaybeT IO (Artist, [String])
handleDiscographyPage ar@(Artist _ url) = openURL url (getSongLinks ar)

handleSongPage :: Artist -> String -> MaybeT IO Song
handleSongPage ar url = openURL url (getSongLyrics ar url)

makeSongs :: (Artist, [String]) -> MaybeT IO [Song]
makeSongs (a, ss) = traverse (handleSongPage a) ss

scrape :: String -> MaybeT IO [Song]
scrape s = (handleArtistsPage s >>=
            traverse handleDiscographyPage >>=
            traverse makeSongs) <&> concat
