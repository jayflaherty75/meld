
#include once "template.bi"
#include once "module.bi"
#include once "errors.bi"

namespace Template

' Rename and copy template/template-v1.bi under move-to-headers to headers directory
'
' Add to Linux build:
'	fbc -mt -c "./src/fb/shared/lib/template/template.bas" || { echo; echo Failed to compile template, build terminated; exit 1; }
'	(add the following to both tester.bas and meld.bas compilations)
'	"./src/fb/shared/lib/template/template.o" \
'
' Add to Windows build:
'	fbc -mt -c "./src/fb/shared/lib/template/template.bas"
'
'	IF %ERRORLEVEL% NEQ 0 (
'		ECHO.
'		ECHO Failed to compile template, build terminated
'		EXIT /B 1
'	)
'	(add the following to both tester.bas and meld.bas compilations)
'	"./src/fb/shared/lib/template/template.o" ^
'
' Add to bootstrap.bi (hopefully this is very temporary)
'	Includes:		#include once "shared/lib/template/template.bi"
'	Dependencies:	template as Template.Interface ptr
'	run():			Template.load(@corePtr)
'					if not Template.register() then print "Bootstrap: Failed to register Template"
'	_register():	case "template":
'						deps.template = interface
'	_require():		case "template":
'						interface = deps.template
'
' Add to tester/includes.bi and increment TEST_COUNT:
'	#include once "../shared/lib/template/test.bi"
'	tests(9999) = @TemplateTest.testModule

/''
 ' Creates a map instance to manage named relationships to resources.
 ' @param {zstring} id
 ' @returns {TemplateObj ptr}
 '/
function construct(byref id as zstring) as TemplateObj ptr
	return NULL
end function

/''
 ' Lifecycle function removing instance from system.
 ' @param {templateObj ptr} templatePtr
 '/
sub destruct (templatePtr as TemplateObj ptr)
end sub

end namespace
