
/''
 ' @requires console
 ' @requires fault
 ' @requires error-handling
 ' @requires sys
 '/

#include once "../../../../../modules/headers/constants/constants-v1.bi"
#include once "module.bi"
#include once "errors.bi"
#include once "file.bi"

/''
 ' @namespace SemVer
 '/
namespace SemVer

/''
 ' Application main routine.
 ' @function startup
 ' @returns {short}
 '/
function startup cdecl () as short
	_console->logMessage("Starting sem-ver module")

	_module->setModuleWillLoad(@_handleModuleWillLoad)
	_module->setModuleHasUnloaded(@_handleModuleHasUnloaded)

	return true
end function

/''
 ' Application main routine.
 ' @function shutdown
 ' @returns {short}
 '/
function shutdown cdecl () as short
	_console->logMessage("Shutting down sem-ver module")

	_module->setModuleWillLoad(NULL)
	_module->setModuleHasUnloaded(NULL)

	return true
end function

/''
 ' @function _handleModuleWillLoad
 ' @param {any ptr} entryPtr
 ' @returns {short}
 ' @private
 '/
function _handleModuleWillLoad cdecl (entryPtr as any ptr) as short
	dim as Module.LibraryEntry ptr _entry = entryPtr

	_entry->moduleId = _entry->moduleName
	_entry->moduleFullName = _entry->moduleName
	_entry->moduleVersion = "0.1.0"
	_entry->filename = "modules" & *_sys->getDirsep() & _entry->moduleId & "." & *_sys->getModuleExt()

	if not fileexists(_entry->filename) then
		return false
	end if

	return true
end function

/''
 ' @function _handleModuleHasUnloaded
 ' @param {any ptr} entryPtr
 ' @returns {short}
 ' @private
 '/
function _handleModuleHasUnloaded cdecl (entryPtr as any ptr) as short
	return true
end function

end namespace

