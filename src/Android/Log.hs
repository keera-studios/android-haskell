{-# LANGUAGE ForeignFunctionInterface #-}
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
  | AndroidLogPrioDebug
  | AndroidLogPrioError
  | AndroidLogPrioInfo
  | AndroidLogPrioVerbose
  | AndroidLogPrioWarn

prioToCInt :: AndroidLogPriority -> CInt
prioToCInt AndroidLogPrioAssert  = 7
prioToCInt AndroidLogPrioDebug   = 3
prioToCInt AndroidLogPrioError   = 6
prioToCInt AndroidLogPrioInfo    = 4
prioToCInt AndroidLogPrioVerbose = 2
prioToCInt AndroidLogPrioWarn    = 5
