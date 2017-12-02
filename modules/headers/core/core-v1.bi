
#include once "../constants/constants-v1.bi"

namespace Core

type Interface
	load as function (corePtr as Core.Interface ptr) as integer
	unload as sub ()
	initialize as function (config as zstring ptr) as integer
	uninitialize as sub()
    isRunning as function () as integer
	getStatus as function () as integer
	register as function (moduleName as zstring, interface as any ptr) as integer
	require as function (moduleName as zstring) as any ptr
    shutdown as sub(status as integer)
	getNewline as function() as zstring ptr
	getDirSep as function() as zstring ptr
end type

end namespace
