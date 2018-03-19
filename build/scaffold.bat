@ECHO OFF

SET moduleName=%1
SET moduleType=%2
SET moduleSystem=%3

IF "%2"=="" (
    SET moduleType=lib
)

IF "%3"=="" (
    SET moduleSystem=shared
)

REM Generate shorthand build script (requires only module name, not path)
ECHO @ECHO OFF> build\m\%moduleName%.bat
ECHO. >> build\m\%moduleName%.bat
ECHO build\module %moduleName% %moduleType% %moduleSystem%>> build\m\%moduleName%.bat

REM Initialize XML file so templates have data to work off of
if not exist modules\definitions\%moduleName%.xml (
    ECHO ^<?xml version="1.0" encoding="UTF-8"?^>^<module name="%moduleName%"^>^<namespace^>>> modules\definitions\%moduleName%.xml
    build\kebab-to-pascal %moduleName%>> modules\definitions\%moduleName%.xml
    ECHO ^</namespace^>^</module^>>> modules\definitions\%moduleName%.xml
)

REM Generate one-time, user modifiable boilerplate
if not exist src\fb\%moduleSystem%\%moduleType%\%moduleName%\%moduleName%.bas (
    xsltproc -o src\fb\%moduleSystem%\%moduleType%\%moduleName%\%moduleName%.bas build\templates\source-fb.xslt modules\definitions\%moduleName%.xml
    xsltproc -o src\fb\%moduleSystem%\%moduleType%\%moduleName%\test.bi build\templates\test-fb.xslt modules\definitions\%moduleName%.xml
    xsltproc -o src\fb\%moduleSystem%\%moduleType%\%moduleName%\errors.bi build\templates\errors-fb.xslt modules\definitions\%moduleName%.xml
)

REM Generate dynamic source files, not modifiable by the user
xsltproc -o src\fb\%moduleSystem%\%moduleType%\%moduleName%\module.bi build\templates\module-fb.xslt modules\definitions\%moduleName%.xml
xsltproc -o src\fb\%moduleSystem%\%moduleType%\%moduleName%\%moduleName%.bi build\templates\include-fb.xslt modules\definitions\%moduleName%.xml
