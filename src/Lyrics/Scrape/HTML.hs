{-# LANGUAGE OverloadedStrings, TupleSections #-}

module Lyrics.Scrape.HTML
  ( getArtists
  , getSongLinks
  , getSongLyrics
  ) where

import Data.ByteString.Lazy.Char8 (ByteString)
import Text.HTML.Scalpel.Core

import Lyrics.Scrape.Entities (Artist, Song)
import Lyrics.Scrape.Parse (buildArtist, buildSongLinks, buildSong)
import Lyrics.Scrape.Reg (anyPat, songLinksPat)
import Lyrics.Utils (bsToText, prefixRoot)

getArtists :: Scraper ByteString [Artist]
getArtists = chroots ("div" @: [hasClass "artist-col"] // "a") $ do
  name <- text anySelector
  url <- attr "href" anySelector
  return $ buildArtist name url

getSongLinks :: Artist -> Scraper ByteString (Artist, [String])
getSongLinks ar = (ar,) <$> getLinks
  where getLinks = chroots ("a" @: ["href" @=~ songLinksPat]) $
                    buildSongLinks (attr "href" anySelector)

getSongLyrics :: Artist -> String -> Scraper ByteString Song
getSongLyrics artist url = do
  t <- text $ "div" @: [hasClass "div-share"] // "h1"
  ls <- text $ "div" @: [notP $ "class" @=~ anyPat,
                         notP $ "id" @=~ anyPat]
  al <- text $ "div" @: [hasClass "album-panel"] // "a"
  return $ buildSong artist url t ls al

