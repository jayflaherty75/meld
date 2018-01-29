
#include once "meld/lib/module/module.bi"

function main() As Integer
	dim as zstring*64 config = command(1)
	dim as Module.Interface ptr modulePtr
	dim as any ptr bstPtr

	Module.initialize()

	modulePtr = Module.require("module")

	if modulePtr = NULL then
		print("**** main: Failed to obtain Module interface")
		return 1
	end if

	bstPtr = modulePtr->require("bst")

	if bstPtr = NULL then
		print("**** main: Failed to obtain Bst interface")
		return 1
	end if

	return 0
end function

end main()
