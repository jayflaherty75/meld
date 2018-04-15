
/'
 ' Generated by Meld Framework, do not modify.  Any changes will be overwritten
 ' during the next build.
 '/


#include once "crt.bi"
#include once "headers/console_v0.1.0.bi"
#include once "console.bi"

dim shared _moduleLocal as Module.Interface

Function exports cdecl Alias "exports" () As any ptr export
	
	moduleState.methods.startup = @Console.startup
	moduleState.methods.shutdown = @Console.shutdown
	moduleState.methods.logMessage = @Console.logMessage
	moduleState.methods.logWarning = @Console.logWarning
	moduleState.methods.logError = @Console.logError
	moduleState.methods.logSuccess = @Console.logSuccess

	return @moduleState.methods
End Function

Function load cdecl Alias "load" (modulePtr As Module.Interface ptr) As short export
	If modulePtr = NULL Then
		printf(!"**** Console.load: Invalid Module interface pointer\n")
		return false
	End If

	If not moduleState.isLoaded Then
		moduleState.isStarted = false
		moduleState.isLoaded = true

		_moduleLocal = *modulePtr
		_module = @_moduleLocal

		_console = exports()

		_fault = modulePtr->require("fault_v0.1.0")
		If _fault = NULL then
			printf("**** Console.load: Failed to load fault dependency")
			Return false
		End If

		_sys = modulePtr->require("sys_v0.1.0")
		If _sys = NULL then
			printf("**** Console.load: Failed to load sys dependency")
			Return false
		End If



	End If

	return true
End Function

Function unload cdecl Alias "unload" () As short export

	If moduleState.isStarted Then
		If moduleState.methods.shutdown <> NULL Then
			If not moduleState.methods.shutdown() Then
				printf(!"**** Console.unload: Module shutdown handler failed\n")
				return false
			End If
		End If

		moduleState.isStarted = false
	End If

	moduleState.isLoaded = false

	return true
End Function



Function startup cdecl Alias "startup" () As short export
	If not moduleState.isStarted Then
		If moduleState.methods.startup <> NULL Then
			If not moduleState.methods.startup() Then
				printf(!"**** Console.startup: Module startup handler failed\n")
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
				printf(!"**** Console.shutdown: Module shutdown handler failed\n")
			End If
		End If

		moduleState.isStarted = false
	End If

	return true
End Function
