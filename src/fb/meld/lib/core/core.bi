
#include once "../../../../../modules/headers/core/core-v1.bi"

namespace Core

declare function load (config as zstring ptr) as integer
declare sub unload ()
declare function initialize (config as zstring ptr) as integer
declare sub uninitialize()

declare function isRunning() as integer
declare function getStatus() as integer
declare function register (byref moduleName as zstring, interface as any ptr) as integer
declare function require (byref moduleName as zstring) as any ptr
declare sub shutdown(status as integer)
declare function getNewline() as zstring ptr
declare function getDirSep() as zstring ptr

end namespace
