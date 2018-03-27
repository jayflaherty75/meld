
/''
 ' @requires sys_v0.1.0
 '/

#include once "module.bi"
#include once "file.bi"

/''
 ' @namespace SemVer
 ' @version 0.1.0
 '/
namespace SemVer

/''
 ' Application main routine.
 ' @function startup
 ' @returns {short}
 '/
function startup cdecl () as short
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
	dim as string moduleName = _entry->moduleName
	dim as short versionPos = instr(moduleName, "_v")
	dim as short miscPos
	dim as string version

	if versionPos = 0 then
		_entry->moduleId = moduleName
		_entry->moduleFullName = moduleName
		_entry->moduleVersion = "0.1.0"
	else
		version = mid(moduleName, versionPos + 2)
		miscPos = instr(version, "-")

		_entry->moduleId = moduleName
		_entry->moduleName = left(moduleName, versionPos - 1)
		_entry->moduleFullName = moduleName

		if miscPos = 0 then
			_entry->moduleVersion = version
		else
			_entry->moduleVersion = left(version, miscPos - 1)
		end if
	end if

	_entry->filename = "modules" & *_sys->getDirsep() & _entry->moduleName & "." & *_sys->getModuleExt()

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

