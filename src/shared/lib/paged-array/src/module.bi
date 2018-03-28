
/'
' Generated by Meld Framework, do not modify.  Any changes will be overwritten
' during the next build.
'/


#include once "headers/paged-array_v0.1.0.bi"
#include once "paged-array.bi"

dim shared _moduleLocal as Module.Interface

Function exports cdecl Alias "exports" () As any ptr export
	
	moduleState.methods.startup = @PagedArray.startup
	moduleState.methods.shutdown = @PagedArray.shutdown
	moduleState.methods.test = @PagedArray.test
	moduleState.methods.construct = @PagedArray.construct
	moduleState.methods.destruct = @PagedArray.destruct
	moduleState.methods.initialize = @PagedArray.initialize
	moduleState.methods.createIndex = @PagedArray.createIndex
	moduleState.methods.getIndex = @PagedArray.getIndex
	moduleState.methods.pop = @PagedArray.pop
	moduleState.methods.isEmpty = @PagedArray.isEmpty

	return @moduleState.methods
End Function

Function load cdecl Alias "load" (modulePtr As Module.Interface ptr) As short export
	If modulePtr = NULL Then
		print("**** PagedArray.load: Invalid Module interface pointer")
		return false
	End If

	If not moduleState.isLoaded Then
		moduleState.isStarted = false
		moduleState.isLoaded = true

		_moduleLocal = *modulePtr
		_module = @_moduleLocal

		_pagedArray = exports()

		_console = modulePtr->require("console_v0.1.0")
		If _console = NULL then
			print("**** PagedArray.load: Failed to load console dependency")
			Return false
		End If

		_fault = modulePtr->require("fault_v0.1.0")
		If _fault = NULL then
			print("**** PagedArray.load: Failed to load fault dependency")
			Return false
		End If

		_errorHandling = modulePtr->require("error-handling_v0.1.0")
		If _errorHandling = NULL then
			print("**** PagedArray.load: Failed to load error-handling dependency")
			Return false
		End If

		_tester = modulePtr->require("tester_v0.1.0")
		If _tester = NULL then
			print("**** PagedArray.load: Failed to load tester dependency")
			Return false
		End If


		errors.nullReferenceError = _fault->getCode("NullReferenceError")
		If errors.nullReferenceError = NULL then
			print("**** PagedArray.load: Missing error definition for NullReferenceError")
			Return false
		End If

		errors.outOfBoundsError = _fault->getCode("OutOfBoundsError")
		If errors.outOfBoundsError = NULL then
			print("**** PagedArray.load: Missing error definition for OutOfBoundsError")
			Return false
		End If

		errors.resourceAllocationError = _fault->getCode("ResourceAllocationError")
		If errors.resourceAllocationError = NULL then
			print("**** PagedArray.load: Missing error definition for ResourceAllocationError")
			Return false
		End If

		errors.resourceLimitSurpassed = _fault->getCode("ResourceLimitSurpassed")
		If errors.resourceLimitSurpassed = NULL then
			print("**** PagedArray.load: Missing error definition for ResourceLimitSurpassed")
			Return false
		End If


	End If

	return true
End Function

Function unload cdecl Alias "unload" () As short export

	If moduleState.isStarted Then
		If moduleState.methods.shutdown <> NULL Then
			If not moduleState.methods.shutdown() Then
				print("**** PagedArray.unload: Module shutdown handler failed")
				return false
			End If
		End If

		moduleState.isStarted = false
	End If

	moduleState.isLoaded = false

	return true
End Function


Function test cdecl Alias "test" () As short export
	dim As PagedArray.Interface ptr interfacePtr = exports()
	dim As Tester.testModule tests(1)

	If interfacePtr->test = NULL Then return true

	tests(0) = interfacePtr->test

	If not _tester->run(@tests(0), 1) Then
		return false
	End If

	return true
End Function


Function startup cdecl Alias "startup" () As short export
	If not moduleState.isStarted Then
		If moduleState.methods.startup <> NULL Then
			If not moduleState.methods.startup() Then
				print("**** PagedArray.startup: Module startup handler failed")
				return false
			End If
		End If

		moduleState.isStarted = true
	End If

	return true
End Function

Function shutdown cdecl Alias "shutdown" () As short export
	If moduleState.isStarted Then
		If moduleState.methods.shutdown <> NULL Then
			If not moduleState.methods.shutdown() Then
				print("**** PagedArray.shutdown: Module shutdown handler failed")
			End If
		End If

		moduleState.isStarted = false
	End If

	return true
End Function
