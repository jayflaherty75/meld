
/'
 ' Generated by Meld Framework, do not modify.  Any changes will be overwritten
 ' during the next build.
 '/


#include once "headers/state_v0.1.0.bi"
#include once "state.bi"

dim shared _moduleLocal as Module.Interface

Function exports cdecl Alias "exports" () As any ptr export
	
	moduleState.methods.startup = @State.startup
	moduleState.methods.shutdown = @State.shutdown
	moduleState.methods.test = @State.test
	moduleState.methods.construct = @State.construct
	moduleState.methods.destruct = @State.destruct
	moduleState.methods.initialize = @State.initialize
	moduleState.methods.setAllocator = @State.setAllocator
	moduleState.methods.request = @State.request
	moduleState.methods.release = @State.release
	moduleState.methods.assign = @State.assign
	moduleState.methods.assignFromContainer = @State.assignFromContainer
	moduleState.methods.unassign = @State.unassign

	return @moduleState.methods
End Function

Function load cdecl Alias "load" (modulePtr As Module.Interface ptr) As short export
	If modulePtr = NULL Then
		print("**** State.load: Invalid Module interface pointer")
		return false
	End If

	If not moduleState.isLoaded Then
		moduleState.isStarted = false
		moduleState.isLoaded = true

		_moduleLocal = *modulePtr
		_module = @_moduleLocal

		_state = exports()

		_console = modulePtr->require("console_v0.1.0")
		If _console = NULL then
			print("**** State.load: Failed to load console dependency")
			Return false
		End If

		_fault = modulePtr->require("fault_v0.1.0")
		If _fault = NULL then
			print("**** State.load: Failed to load fault dependency")
			Return false
		End If

		_tester = modulePtr->require("tester_v0.1.0")
		If _tester = NULL then
			print("**** State.load: Failed to load tester dependency")
			Return false
		End If

		_resourceContainer = modulePtr->require("resource-container_v0.1.0")
		If _resourceContainer = NULL then
			print("**** State.load: Failed to load resource-container dependency")
			Return false
		End If

		_map = modulePtr->require("map_v0.1.0")
		If _map = NULL then
			print("**** State.load: Failed to load map dependency")
			Return false
		End If


		errors.allocationError = _fault->getCode("AllocationError")
		If errors.allocationError = NULL then
			print("**** State.load: Missing error definition for AllocationError")
			Return false
		End If

		errors.nullReferenceError = _fault->getCode("NullReferenceError")
		If errors.nullReferenceError = NULL then
			print("**** State.load: Missing error definition for NullReferenceError")
			Return false
		End If

		errors.releaseResourceError = _fault->getCode("ReleaseResourceError")
		If errors.releaseResourceError = NULL then
			print("**** State.load: Missing error definition for ReleaseResourceError")
			Return false
		End If

		errors.resourceAllocationError = _fault->getCode("ResourceAllocationError")
		If errors.resourceAllocationError = NULL then
			print("**** State.load: Missing error definition for ResourceAllocationError")
			Return false
		End If

		errors.resourceInitializationError = _fault->getCode("ResourceInitializationError")
		If errors.resourceInitializationError = NULL then
			print("**** State.load: Missing error definition for ResourceInitializationError")
			Return false
		End If

		errors.resourceMissingError = _fault->getCode("ResourceMissingError")
		If errors.resourceMissingError = NULL then
			print("**** State.load: Missing error definition for ResourceMissingError")
			Return false
		End If


	End If

	return true
End Function

Function unload cdecl Alias "unload" () As short export

	If moduleState.isStarted Then
		If moduleState.methods.shutdown <> NULL Then
			If not moduleState.methods.shutdown() Then
				print("**** State.unload: Module shutdown handler failed")
				return false
			End If
		End If

		moduleState.isStarted = false
	End If

	moduleState.isLoaded = false

	return true
End Function


Function test cdecl Alias "test" () As short export
	dim As State.Interface ptr interfacePtr = exports()
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
				print("**** State.startup: Module startup handler failed")
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
				print("**** State.shutdown: Module shutdown handler failed")
			End If
		End If

		moduleState.isStarted = false
	End If

	return true
End Function
