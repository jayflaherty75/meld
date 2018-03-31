
/''
 ' @requires sys_v0.1.0
 '/

#include once "module.bi"
#include once "file.bi"
#include once "dir.bi"

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
	dim as short versionPos = instr(_entry->moduleName, "_v")
	dim as string dirSep = *_sys->getDirsep()
	dim as string modExt = *_sys->getModuleExt()
	dim as string searchName
	dim as string moduleName
	dim as string fileResult
	dim as string version
	dim as string memName
	dim as short miscPos

	' foo-bar + 0.1.0 + xxxx
	if versionPos = 0 then
		searchName = _entry->moduleName & "_v*"
	else
		moduleName = left(_entry->moduleName, versionPos - 1)
		version = mid(_entry->moduleName, versionPos + 2)
		miscPos = instr(version, "-")

		if miscPos > 0 then
			memName = right(version, miscPos + 1)
			version = left(version, miscPos - 1)
		end if

		searchName = moduleName & "_v" + version
	end if

	' Look up listing and sorting directories
	' Try to refactor current implementation with directories (empty result throws)
	'	Read modules directory with module name as file mask, use fbDirectory flag
	'	Return false if result is empty
	'	Take last module in result and load it
	' Full implementation
	'	If no version, append '_v*'
	'	Split out extra characters from version (full name -> moduleId, partial -> filename)
	'	Read modules directory with module name as file mask, use fbDirectory flag
	'	Return false if result is empty
	'	Check sorting, sort if necessary
	'	Take last module in result and load it

	moduleName = _getLatestVersion(searchName)

	if moduleName = "" then
		return false
	end if

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

	_entry->filename = "meld_modules" & dirSep _
		& _entry->moduleId & dirSep _
		& "module." & modExt

	if not fileexists(_entry->filename) then
		return false
	end if

	return true
end function

/''
 ' @function _getLatestVersion
 ' @param {byref string} search
 ' @returns {string}
 ' @private
 '/
function _getLatestVersion(byref search as string) as string
	dim as string dirName
	dim as string result
	dim as string prevDir = curdir()

	if instr(search, "*") = 0 then return search

	if chdir("meld_modules") then
		return ""
	end if

	dirName = dir(search, fbDirectory)

	do while len(dirName) > 0
		result = dirName
		dirName = dir()
	loop

	chdir(prevDir)

	return result
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

