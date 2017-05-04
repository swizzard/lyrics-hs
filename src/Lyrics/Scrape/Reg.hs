{-# LANGUAGE OverloadedStrings #-}
module Lyrics.Scrape.Reg
  ( albumPat
  , anyPat
  , songLinksPat
  , titlePat
  ) where

import Data.ByteString.Lazy.Char8 (ByteString)
import Text.Regex.PCRE as Re

albumPat :: Re.Regex
albumPat = Re.makeRegex ("\"([^\"]*)\" \\(([0-9]+)\\)" :: ByteString)

anyPat :: Re.Regex
anyPat = Re.makeRegex (".*" :: ByteString)

songLinksPat :: Re.Regex
songLinksPat = Re.makeRegex ("^\\.\\./lyrics" :: ByteString)

titlePat :: Re.Regex
titlePat = Re.makeRegex ("\"([^\"]+)\" lyrics" :: ByteString)

