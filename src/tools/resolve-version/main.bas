
#include once "../../fb/meld/lib/module/resolve-version.bi"

function main(argc As Integer, argv As ZString Ptr Ptr) As Integer
	dim as String moduleName = *argv[1]
	dim as string result = Version.resolve(moduleName)

	if moduleName = "" then
		print("resolve-version: Module not found or invalid")
		return 1
	end if

	print result;

	return 0
end function

end main(__FB_ARGC__, __FB_ARGV__)
