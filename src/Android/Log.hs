{-# LANGUAGE ForeignFunctionInterface #-}
-- | Interface to Android's Logging system.
--
-- Copyright   : (C) Keera Studios Ltd, 2014
-- License     : GPL-3
-- Maintainer  : support@keera.co.uk
module Android.Log
   ( AndroidLogPriority(..)
   , androidLogPrint
   , android_log_print
   )
  where

import Control.Applicative ((<$>))
import Foreign.C.Types (CInt(..))
import Foreign.C.String
import Foreign.Marshal.Alloc

-- extern int __android_log_print(int prio, const char *tag, const char *fmt, ...);
foreign import ccall "__android_log_print" android_log_print :: CInt -> CString -> CString -> IO CInt

androidLogPrint :: AndroidLogPriority -> String -> String -> IO Int
androidLogPrint prio tag msg = do
  -- Priority
  let v = prioToCInt prio
  -- Create new strings
  tagStr <- newCString tag
  msgStr <- newCString msg

  -- Print to locat
  res <- fromIntegral <$> android_log_print v tagStr msgStr
  res `seq` return ()

  -- Free strings
  free tagStr
  free msgStr

  return res

data AndroidLogPriority =
    AndroidLogPrioAssert
  | AndroidLogPrioError
  | AndroidLogPrioWarn
  | AndroidLogPrioInfo
  | AndroidLogPrioDebug
  | AndroidLogPrioVerbose

prioToCInt :: AndroidLogPriority -> CInt
prioToCInt AndroidLogPrioAssert  = 7
prioToCInt AndroidLogPrioError   = 6
prioToCInt AndroidLogPrioWarn    = 5
prioToCInt AndroidLogPrioInfo    = 4
prioToCInt AndroidLogPrioDebug   = 3
prioToCInt AndroidLogPrioVerbose = 2
