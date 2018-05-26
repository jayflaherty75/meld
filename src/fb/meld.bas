
#include once "crt.bi"
#include once "meld/lib/module/module.bi"

function main(argc As Integer, argv As ZString Ptr Ptr) As Integer
	dim as String app = *argv[1]
	dim as Meld.Interface ptr appPtr

	if app = "" then
		app = "default"
	end if

	if not Module.initialize(argc, argv) then
		printf("**** main: Failed to initialize Module" & NEW_LINE)
		return 1
	end if

	appPtr = Module.require(app)

	if appPtr = NULL then
		printf("**** main: Failed to obtain " & app & " interface" & NEW_LINE)
		return 1
	end if

	if not Module.testModule(app) then
		printf("**** main: " & app & " unit test failed\n")
		Module.uninitialize()
		return 1
	end if

	if appPtr->update <> NULL andalso not appPtr->update(NULL) then
		printf("**** main: An error occurred while running " & app & NEW_LINE)
		return 1
	end if

	if not Module.uninitialize() then
		printf("**** main: An error occurred while attempting to uninitialize Meld" & NEW_LINE)
		return 1
	end if

	print:print

	return 0
end function

end main(__FB_ARGC__, __FB_ARGV__)
