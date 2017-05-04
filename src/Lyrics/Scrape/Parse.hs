{-# LANGUAGE OverloadedStrings #-}
module Lyrics.Scrape.Parse
  ( buildSongLinks
  , buildArtist
  , buildSong
  ) where

import Control.Applicative ((<|>))
import Data.ByteString.Lazy.Char8 (ByteString)
import qualified Data.ByteString.Lazy.Char8 as BS
import Data.Text (Text, split)
import Text.Read (readMaybe)
import qualified Text.Regex.PCRE as Re

import Lyrics.Scrape.Entities
import Lyrics.Scrape.Reg
import Lyrics.Utils (bsToText, prefixRoot)

parseLyrics :: BS.ByteString -> [Text]
parseLyrics = split splitPred . bsToText
  where splitPred c = not (c == '\r' || c == '\n')

buildSong :: Artist -> String -> BS.ByteString -> BS.ByteString -> BS.ByteString -> Song
buildSong ar url rawTitle rawLyrics rawAlbum =
  Song title artistName albumTitle albumYear lyrics url
    where
      title = case Re.mrSubList (Re.match titlePat rawTitle) of
                        [m] -> Just (bsToText m)
                        [] -> Nothing
      (albumTitle, albumYear) =
            case Re.mrSubList (Re.match albumPat rawAlbum) :: [BS.ByteString] of
                  (t:y:_) -> (if BS.length t > 0 then Just (bsToText t) else Nothing,
                              (readMaybe . BS.unpack) y :: Maybe Int)
                  [] -> (Nothing, Nothing)
      artistName = Just $ arName ar
      lyrics = parseLyrics rawLyrics

buildArtist :: BS.ByteString -> BS.ByteString -> Artist
buildArtist name url = Artist (bsToText name) (prefixRoot $ BS.unpack url)

buildSongLinks :: (Functor f) => f BS.ByteString -> f String
buildSongLinks = fmap (prefixRoot . drop 3 . BS.unpack)

