
/'
' Generated by Meld Framework, do not modify.  Any changes will be overwritten
' during the next build.
'/


#include once "headers/list_v.bi"
#include once "list.bi"

dim shared _moduleLocal as Module.Interface

Function exports cdecl Alias "exports" () As any ptr export
	
	moduleState.methods.startup = @.startup
	moduleState.methods.shutdown = @.shutdown
	moduleState.methods.test = @.test
	moduleState.methods.construct = @.construct
	moduleState.methods.destruct = @.destruct
	moduleState.methods.insert = @.insert
	moduleState.methods.remove = @.remove
	moduleState.methods.getFirst = @.getFirst
	moduleState.methods.getLast = @.getLast
	moduleState.methods.getNext = @.getNext
	moduleState.methods.getLength = @.getLength
	moduleState.methods.search = @.search
	moduleState.methods.defaultCompare = @.defaultCompare
	moduleState.methods.getIterator = @.getIterator

	return @moduleState.methods
End Function

Function load cdecl Alias "load" (modulePtr As Module.Interface ptr) As short export
	If modulePtr = NULL Then
		print("**** .load: Invalid Module interface pointer")
		return false
	End If

	If not moduleState.isLoaded Then
		moduleState.isStarted = false
		moduleState.isLoaded = true

		_moduleLocal = *modulePtr
		_module = @_moduleLocal

		_list = exports()

		_console = modulePtr->require("console_v0.1.0")
		If _console = NULL then
			print("**** .load: Failed to load console dependency")
			Return false
		End If

		_fault = modulePtr->require("fault_v0.1.0")
		If _fault = NULL then
			print("**** .load: Failed to load fault dependency")
			Return false
		End If

		_errorHandling = modulePtr->require("error-handling_v0.1.0")
		If _errorHandling = NULL then
			print("**** .load: Failed to load error-handling dependency")
			Return false
		End If

		_tester = modulePtr->require("tester_v0.1.0")
		If _tester = NULL then
			print("**** .load: Failed to load tester dependency")
			Return false
		End If

		_iterator = modulePtr->require("iterator_v0.1.0")
		If _iterator = NULL then
			print("**** .load: Failed to load iterator dependency")
			Return false
		End If


		errors.invalidArgumentError = _fault->getCode("InvalidArgumentError")
		If errors.invalidArgumentError = NULL then
			print("**** .load: Missing error definition for InvalidArgumentError")
			Return false
		End If

		errors.nullReferenceError = _fault->getCode("NullReferenceError")
		If errors.nullReferenceError = NULL then
			print("**** .load: Missing error definition for NullReferenceError")
			Return false
		End If

		errors.releaseResourceError = _fault->getCode("ReleaseResourceError")
		If errors.releaseResourceError = NULL then
			print("**** .load: Missing error definition for ReleaseResourceError")
			Return false
		End If

		errors.resourceAllocationError = _fault->getCode("ResourceAllocationError")
		If errors.resourceAllocationError = NULL then
			print("**** .load: Missing error definition for ResourceAllocationError")
			Return false
		End If


	End If

	return true
End Function

Function unload cdecl Alias "unload" () As short export

	If moduleState.isStarted Then
		If moduleState.methods.shutdown <> NULL Then
			If not moduleState.methods.shutdown() Then
				print("**** .unload: Module shutdown handler failed")
				return false
			End If
		End If

		moduleState.isStarted = false
	End If

	moduleState.isLoaded = false

	return true
End Function


Function test cdecl Alias "test" () As short export
	dim As .Interface ptr interfacePtr = exports()
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
				print("**** .startup: Module startup handler failed")
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
				print("**** .shutdown: Module shutdown handler failed")
			End If
		End If

		moduleState.isStarted = false
	End If

	return true
End Function
