-- | Interface to Android's Logging system.
--
-- Copyright   : (C) Keera Studios Ltd, 2014
-- License     : GPL-3
-- Maintainer  : support@keera.co.uk
module Android.OpenURL where

import Android.Log
import Control.Concurrent (forkIO)
import Control.Monad      (void)
import System.Process     (rawSystem)

-- | Throw an Android intent to visit a URL
openURL :: String -> IO ()
openURL url = void $ forkIO $ do
  e <- rawSystem "am" ["start", "-a", "android.intent.action.VIEW", "-d", url]
  void $ androidLogPrint AndroidLogPrioDebug
                         "uk.co.keera.android.openurl"
                         ("Opening URL " ++ url ++ ", received a " ++ show e)
