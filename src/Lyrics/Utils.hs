module Lyrics.Utils
  ( bsToText
  , justText
  , prefixRoot
  , surroundString
  ) where

import qualified Data.ByteString.Lazy.Char8 as BS
import Data.ByteString.Lazy.Char8 (ByteString)
import qualified Data.Text as T
import Data.Text (Text)

bsToText :: ByteString -> Text
bsToText = T.pack . BS.unpack

justText :: String -> Maybe Text
justText = Just . T.pack

surroundString :: String -> String -> String -> String
surroundString pref suf = (pref ++) . (++ suf)

prefixRoot :: String -> String
prefixRoot = ("http://www.azlyrics.com/" ++)
