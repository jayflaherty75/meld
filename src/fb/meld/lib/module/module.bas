
/''
 ' @requires constants
 ' @requires core
 '/

#include once "module.bi"

/''
 ' @namespace Module
 '/
namespace Module

/''
 ' @class Entry
 ' @property {string} moduleName
 ' @property {any ptr} interfacePtr
 ' @property {any ptr} library
 '/

/''
 ' @typedef {function} SetEntryFnc
 ' @param {byref zstring} moduleName
 ' @param {Entry ptr} module
 ' @returns {short}
 '/

/''
 ' @typedef {function} GetEntryFnc
 ' @param {byref zstring} moduleName
 ' @returns {Entry ptr}
 '/

type StateType
	entries(MODULE_MAX_ENTRIES) as Entry
	entryCount as short
	setEntry as SetEntryFnc
	getEntry as GetEntryFnc
end type

dim shared as StateType state
dim shared as Interface api

/''
 ' Initializes (or reinitializes) base module system.
 ' @function initialize
 '/
sub initialize cdecl()
	dim as Interface ptr apiPtr = @api
	dim as Interface ptr testPtr
	dim as any ptr library

	state.entryCount = 0
	state.setEntry = NULL
	state.getEntry = @_getEntryDefault

	apiPtr->initialize = @initialize
	apiPtr->exports = @exports
	apiPtr->require = @require
	apiPtr->setHandlers = @setHandlers
	apiPtr->test = @test

	if not apiPtr->exports("module", apiPtr) then
		print ("**** Module.initialize: Failed to register module interface")
		exit sub
	end if

	testPtr = apiPtr->require("module")

	if testPtr = NULL then
		print ("**** Module.initialize: Failed to load module interface")
		exit sub
	end if

	if testPtr->test(21) <> 42 then
		print ("**** Module.initialize: Module test failed")
	else
		print ("Meld loaded successfully!")
	end if
end sub

/''
 ' Export a named module interface.
 ' @function exports
 ' @param {byref zstring} moduleName
 ' @param {any ptr} interfacePtr
 ' @returns {short}
 '/
function exports cdecl (byref moduleName as zstring, interfacePtr as any ptr) as short
	dim as Entry ptr entryPtr = @state.entries(state.entryCount)

	if moduleName = "" then
		print ("**** Module.exports: Missing moduleName argument")
		return false
	end if

	if interfacePtr = NULL then
		print ("**** Module.exports: Missing interfacePtr argument")
		return false
	end if

	if state.setEntry <> NULL then
		if not state.setEntry(moduleName, entryPtr) then
			print("**** Module.exports: Call to setEntry handler failed for " _
				& moduleName)
			return false
		end if
	end if

	state.entryCount += 1

	entryPtr->moduleName = moduleName
	entryPtr->interfacePtr = interfacePtr

	return true
end function

/''
 ' Returns a pointer to the required interface.
 ' @function require
 ' @param {byref zstring} moduleName
 ' @returns {any ptr}
 '/
function require cdecl (byref moduleName as zstring) as any ptr
	dim as Entry ptr entryPtr
	dim as string filename
	dim as any ptr library
	dim as any ptr loadFn

	if moduleName = "" then
		print ("**** Module.require: Missing moduleName argument")
		return NULL
	end if

	entryPtr = state.getEntry(moduleName)

	if entryPtr <> NULL then
		return entryPtr
	end if

	filename = "modules" & DIR_SEP & moduleName & "." & EXTERNAL_MODULE_EXTENSION

	if not fileexists(filename) then
		print("**** Module.exports: Missing module: " & filename)
		return false
	end if

	library = dylibload(filename)

	if library = NULL then
		print("**** Module.exports: Failed to load module: " & filename)
		return false
	end if

	loadFn = dylibsymbol (library, "moduleLoader")

	if loadFn = NULL then
		print("**** Module.exports: Missing moduleLoader function: " & filename)
		return false
	end if

	' TODO: Write a simple test module as kick off RM-9
	'if entryPtr = NULL then
	'	print ("**** Module.require: Failed to find interface for " & moduleName)
	'end if

	return entryPtr
end function

/''
 ' Override search functions.
 ' @function setHandlers
 ' @param {SetEntryFnc} [setEntry=NULL]
 ' @param {GetEntryFnc} getEntry required
 '/
sub setHandlers cdecl (setEntry as SetEntryFnc = NULL, getEntry as GetEntryFnc)
	if getEntry = NULL then
		print ("**** Module.setHandlers: Missing getEntry argument")
		exit sub
	end if

	state.setEntry = setEntry
	state.getEntry = getEntry
end sub

/''
 ' Simple test function to ensure module libraries are working.
 ' @function test
 ' @param {short} value
 ' @returns {short}
 '/
function test cdecl (value as short) as short
	return value * 2
end function

/''
 ' Default interface search handler.
 ' @function _getEntryDefault
 ' @param {byref zstring} moduleName
 ' @returns {any ptr}
 ' @private
 '/
function _getEntryDefault (byref moduleName as zstring) as Entry ptr
	dim as Entry ptr entryPtr = NULL
	dim as short index = 0

	do
		if state.entries(index).moduleName = moduleName then
			entryPtr = @state.entries(index)
		end if

		index += 1
	loop while entryPtr = NULL andalso index < state.entryCount

	if entryPtr = NULL then
		return NULL
	end if

	return entryPtr->interfacePtr
end function

end namespace
