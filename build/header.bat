@echo off

set moduleName=%1
set moduleVersion=%2

if "%2"=="" (
    SET moduleVersion=1
)

xsltproc -o modules\headers\%moduleName%\%moduleName%-v%moduleVersion%.bi build\templates\header-fb.xslt modules\definitions\%moduleName%.xml
