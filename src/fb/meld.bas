
#include once "meld/lib/module/module.bi"

function main() As Integer
	dim as zstring*64 app = command(1)
	dim as Meld.Interface ptr appPtr

	if not Module.initialize() then
		print("**** main: Failed to initialize Module")
		return 1
	end if

	appPtr = Module.require(app)

	if appPtr = NULL then
		print("**** main: Failed to obtain " & app & " interface")
		return 1
	end if

	if not Module.uninitialize() then
		print("**** main: An error occurred while attempting to uninitialize Meld")
		return 1
	end if

	return 0
end function

end main()
