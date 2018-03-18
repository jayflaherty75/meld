@ECHO OFF

SET moduleName=%1
SET moduleVersion=%2

IF "%2"=="" (
    SET moduleVersion=1
)

xsltproc -o modules\headers\%moduleName%\%moduleName%-v%moduleVersion%.bi build\templates\header-fb.xslt modules\definitions\%moduleName%.xml
