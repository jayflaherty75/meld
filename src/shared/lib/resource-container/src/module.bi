
/'
 ' Generated by Meld Framework, do not modify.  Any changes will be overwritten
 ' during the next build.
 '/


#include once "crt.bi"
#include once "headers/resource-container_v0.1.0.bi"
#include once "resource-container.bi"

dim shared _moduleLocal as Module.Interface

Function exports cdecl Alias "exports" () As any ptr export
	
	moduleState.methods.startup = @ResourceContainer.startup
	moduleState.methods.shutdown = @ResourceContainer.shutdown
	moduleState.methods.test = @ResourceContainer.test
	moduleState.methods.construct = @ResourceContainer.construct
	moduleState.methods.destruct = @ResourceContainer.destruct
	moduleState.methods.initialize = @ResourceContainer.initialize
	moduleState.methods.request = @ResourceContainer.request
	moduleState.methods.release = @ResourceContainer.release
	moduleState.methods.getPtr = @ResourceContainer.getPtr

	return @moduleState.methods
End Function

Function load cdecl Alias "load" (modulePtr As Module.Interface ptr) As short export
	If modulePtr = NULL Then
		printf(!"**** ResourceContainer.load: Invalid Module interface pointer\n")
		return false
	End If

	If not moduleState.isLoaded Then
		moduleState.isStarted = false
		moduleState.isLoaded = true

		_moduleLocal = *modulePtr
		_module = @_moduleLocal

		_resourceContainer = exports()

		_console = modulePtr->require("console_v0.1.0")
		If _console = NULL then
			printf("**** ResourceContainer.load: Failed to load console dependency")
			Return false
		End If

		_fault = modulePtr->require("fault_v0.1.0")
		If _fault = NULL then
			printf("**** ResourceContainer.load: Failed to load fault dependency")
			Return false
		End If

		_errorHandling = modulePtr->require("error-handling_v0.1.0")
		If _errorHandling = NULL then
			printf("**** ResourceContainer.load: Failed to load error-handling dependency")
			Return false
		End If

		_tester = modulePtr->require("tester_v0.1.0")
		If _tester = NULL then
			printf("**** ResourceContainer.load: Failed to load tester dependency")
			Return false
		End If

		_pagedArray = modulePtr->require("paged-array_v0.1.0")
		If _pagedArray = NULL then
			printf("**** ResourceContainer.load: Failed to load paged-array dependency")
			Return false
		End If


		errors.invalidArgumentError = _fault->getCode("InvalidArgumentError")
		If errors.invalidArgumentError = NULL then
			printf(!"**** ResourceContainer.load: Missing error definition for InvalidArgumentError\n")
			Return false
		End If

		errors.nullReferenceError = _fault->getCode("NullReferenceError")
		If errors.nullReferenceError = NULL then
			printf(!"**** ResourceContainer.load: Missing error definition for NullReferenceError\n")
			Return false
		End If

		errors.releaseResourceError = _fault->getCode("ReleaseResourceError")
		If errors.releaseResourceError = NULL then
			printf(!"**** ResourceContainer.load: Missing error definition for ReleaseResourceError\n")
			Return false
		End If

		errors.resourceAllocationError = _fault->getCode("ResourceAllocationError")
		If errors.resourceAllocationError = NULL then
			printf(!"**** ResourceContainer.load: Missing error definition for ResourceAllocationError\n")
			Return false
		End If

		errors.resourceMissingError = _fault->getCode("ResourceMissingError")
		If errors.resourceMissingError = NULL then
			printf(!"**** ResourceContainer.load: Missing error definition for ResourceMissingError\n")
			Return false
		End If


	End If

	return true
End Function

Function unload cdecl Alias "unload" () As short export

	If moduleState.isStarted Then
		If moduleState.methods.shutdown <> NULL Then
			If not moduleState.methods.shutdown() Then
				printf(!"**** ResourceContainer.unload: Module shutdown handler failed\n")
				return false
			End If
		End If

		moduleState.isStarted = false
	End If

	moduleState.isLoaded = false

	return true
End Function


Function test cdecl Alias "test" () As short export
	dim As ResourceContainer.Interface ptr interfacePtr = exports()
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
				printf(!"**** ResourceContainer.startup: Module startup handler failed\n")
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
				printf(!"**** ResourceContainer.shutdown: Module shutdown handler failed\n")
			End If
		End If

		moduleState.isStarted = false
	End If

	return true
End Function
