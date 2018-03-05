
/'
' Generated by Meld Framework, do not modify.  Any changes will be overwritten
' during the next build.
'/


#include once "../../../../../modules/headers/identity/identity-v1.bi"
#include once "identity.bi"

Function exports cdecl Alias "exports" () As any ptr export
	
	moduleState.methods.startup = @Identity.startup
	moduleState.methods.shutdown = @Identity.shutdown
	moduleState.methods.test = @Identity.test
	moduleState.methods.construct = @Identity.construct
	moduleState.methods.destruct = @Identity.destruct
	moduleState.methods.getAutoInc = @Identity.getAutoInc

	return @moduleState.methods
End Function

Function load cdecl Alias "load" (modulePtr As Module.Interface ptr) As short export
	If modulePtr = NULL Then
		print("**** Identity.load: Invalid Module interface pointer")
		return false
	End If

	If not moduleState.isLoaded Then
		moduleState.references = 0
		moduleState.startups = 0
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

	moduleState.references += 1

	return true
End Function

Function unload cdecl Alias "unload" () As short export
	moduleState.references -= 1

	If moduleState.references <= 0 Then
		moduleState.references = 0
		moduleState.startups = 0
		moduleState.isLoaded = false
	End If

	return moduleState.isLoaded
End Function


Function test () As short export
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
	If moduleState.startups = 0 Then
		If moduleState.methods.startup <> NULL Then
			If not moduleState.methods.startup() Then
				print("**** Identity.startup: Module startup handler failed")
				return false
			
			ElseIf not test() Then
				' TODO: Remove test from startup and move startup function to
				' end of boilerplate
				print("**** Identity.start: Unit test failed")
				return false
			
			End If
		End If
	End If

	moduleState.startups += 1

	return true
End Function

Function shutdown cdecl Alias "shutdown" () As short export
	moduleState.startups -= 1

	If moduleState.startups <= 0 Then
		moduleState.startups = 0

		If moduleState.methods.shutdown <> NULL Then
			If not moduleState.methods.shutdown() Then
				print("**** Identity.startup: Module shutdown handler failed")
			End If
		End If
	End If

	return true
End Function
