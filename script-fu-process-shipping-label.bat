set str=%1
set str=%str:\=/%
set str=%str:"=\"%
"C:\Program Files\GIMP-2.0\bin\gimp-2.6.exe" -dfi --verbose -b "(script-fu-process-shipping-label %str%)" -b "(gimp-quit 0)"