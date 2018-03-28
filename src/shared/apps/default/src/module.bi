
/'
' Generated by Meld Framework, do not modify.  Any changes will be overwritten
' during the next build.
'/


#include once "headers/default_v0.1.0.bi"
#include once "default.bi"

dim shared _moduleLocal as Module.Interface

Function exports cdecl Alias "exports" () As any ptr export
	
	moduleState.methods.startup = @Default.startup
	moduleState.methods.shutdown = @Default.shutdown
	moduleState.methods.update = @Default.update
	moduleState.methods.test = @Default.test

	return @moduleState.methods
End Function

Function load cdecl Alias "load" (modulePtr As Module.Interface ptr) As short export
	If modulePtr = NULL Then
		print("**** Default.load: Invalid Module interface pointer")
		return false
	End If

	If not moduleState.isLoaded Then
		moduleState.isStarted = false
		moduleState.isLoaded = true

		_moduleLocal = *modulePtr
		_module = @_moduleLocal

		_default = exports()

		_sys = modulePtr->require("sys_v0.1.0")
		If _sys = NULL then
			print("**** Default.load: Failed to load sys dependency")
			Return false
		End If

		_console = modulePtr->require("console_v0.1.0")
		If _console = NULL then
			print("**** Default.load: Failed to load console dependency")
			Return false
		End If

		_fault = modulePtr->require("fault_v0.1.0")
		If _fault = NULL then
			print("**** Default.load: Failed to load fault dependency")
			Return false
		End If

		_errorHandling = modulePtr->require("error-handling_v0.1.0")
		If _errorHandling = NULL then
			print("**** Default.load: Failed to load error-handling dependency")
			Return false
		End If

		_tester = modulePtr->require("tester_v0.1.0")
		If _tester = NULL then
			print("**** Default.load: Failed to load tester dependency")
			Return false
		End If


		errors.generalError = _fault->getCode("GeneralError")
		If errors.generalError = NULL then
			print("**** Default.load: Missing error definition for GeneralError")
			Return false
		End If


	End If

	return true
End Function

Function unload cdecl Alias "unload" () As short export

	If moduleState.isStarted Then
		If moduleState.methods.shutdown <> NULL Then
			If not moduleState.methods.shutdown() Then
				print("**** Default.unload: Module shutdown handler failed")
				return false
			End If
		End If

		moduleState.isStarted = false
	End If

	moduleState.isLoaded = false

	return true
End Function


Function test cdecl Alias "test" () As short export
	dim As Default.Interface ptr interfacePtr = exports()
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
				print("**** Default.startup: Module startup handler failed")
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
				print("**** Default.shutdown: Module shutdown handler failed")
			End If
		End If

		moduleState.isStarted = false
	End If

	return true
End Function