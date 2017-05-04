{-# LANGUAGE OverloadedStrings #-}

module Lyrics.Scrape.HTTP
  ( openURL
  ) where

import Control.Lens (views)
import Control.Monad.Trans.Maybe
import Data.ByteString.Lazy.Char8 (ByteString)
import Network.Wreq (get, responseBody)
import Text.HTML.Scalpel.Core (Scraper, scrapeStringLike)

openURL :: String -> Scraper ByteString a -> MaybeT IO a
openURL url scraper = MaybeT $ views responseBody scrapeStringLike
                                <$> get url <*> pure scraper

