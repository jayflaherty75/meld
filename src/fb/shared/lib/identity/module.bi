
/'
' Generated by Meld Framework, do not modify.  Any changes will be overwritten
' during the next build.
'/


#include once "../../../../../modules/headers/identity/identity-v1.bi"
#include once "identity.bi"

dim shared _moduleLocal as Module.Interface

Function exports cdecl Alias "exports" () As any ptr export
	
	moduleState.methods.startup = @Identity.startup
	moduleState.methods.shutdown = @Identity.shutdown
	moduleState.methods.test = @Identity.test
	moduleState.methods.construct = @Identity.construct
	moduleState.methods.destruct = @Identity.destruct
	moduleState.methods.getAutoInc = @Identity.getAutoInc
	moduleState.methods.generate = @Identity.generate
	moduleState.methods.encode = @Identity.encode
	moduleState.methods.decode = @Identity.decode

	return @moduleState.methods
End Function

Function load cdecl Alias "load" (modulePtr As Module.Interface ptr) As short export
	If modulePtr = NULL Then
		print("**** Identity.load: Invalid Module interface pointer")
		return false
	End If

	If not moduleState.isLoaded Then
		moduleState.isStarted = false
		moduleState.isLoaded = true

		_moduleLocal = *modulePtr
		_module = @_moduleLocal

		_identity = exports()

		_console = modulePtr->require("console")
		If _console = NULL then
			print("**** Identity.load: Failed to load console dependency")
			Return false
		End If

		_fault = modulePtr->require("fault")
		If _fault = NULL then
			print("**** Identity.load: Failed to load fault dependency")
			Return false
		End If

		_errorHandling = modulePtr->require("error-handling")
		If _errorHandling = NULL then
			print("**** Identity.load: Failed to load error-handling dependency")
			Return false
		End If

		_tester = modulePtr->require("tester")
		If _tester = NULL then
			print("**** Identity.load: Failed to load tester dependency")
			Return false
		End If

		_sys = modulePtr->require("sys")
		If _sys = NULL then
			print("**** Identity.load: Failed to load sys dependency")
			Return false
		End If


		errors.nullReferenceError = _fault->getCode("NullReferenceError")
		If errors.nullReferenceError = NULL then
			print("**** Identity.load: Missing error definition for NullReferenceError")
			Return false
		End If

		errors.resourceAllocationError = _fault->getCode("ResourceAllocationError")
		If errors.resourceAllocationError = NULL then
			print("**** Identity.load: Missing error definition for ResourceAllocationError")
			Return false
		End If


	End If

	return true
End Function

Function unload cdecl Alias "unload" () As short export

	If moduleState.isStarted Then
		If moduleState.methods.shutdown <> NULL Then
			If not moduleState.methods.shutdown() Then
				print("**** Identity.unload: Module shutdown handler failed")
				return false
			End If
		End If

		moduleState.isStarted = false
	End If

	moduleState.isLoaded = false

	return true
End Function


Function test cdecl Alias "test" () As short export
	dim As Identity.Interface ptr interfacePtr = exports()
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
				print("**** Identity.startup: Module startup handler failed")
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
				print("**** Identity.shutdown: Module shutdown handler failed")
			End If
		End If

		moduleState.isStarted = false
	End If

	return true
End Function