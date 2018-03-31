
#include once "meld/lib/module/module.bi"

function main(argc As Integer, argv As ZString Ptr Ptr) As Integer
	dim as String app = *argv[1]
	dim as Meld.Interface ptr appPtr

	if app = "" then
		app = "default"
	end if

	if not Module.initialize(argc, argv) then
		print("**** main: Failed to initialize Module")
		return 1
	end if

	appPtr = Module.require(app)

	if appPtr = NULL then
		print("**** main: Failed to obtain " & app & " interface")
		return 1
	end if

	if not Module.testModule(app) then
		print("**** main: " & app & " unit test failed")
		Module.uninitialize()
		return 1
	end if

	if appPtr->update <> NULL andalso not appPtr->update(NULL) then
		print("**** main: An error occurred while running " & app)
		return 1
	end if

	if not Module.uninitialize() then
		print("**** main: An error occurred while attempting to uninitialize Meld")
		return 1
	end if

	return 0
end function

end main(__FB_ARGC__, __FB_ARGV__)
