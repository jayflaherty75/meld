
/'
 ' Generated by Meld Framework, do not modify.  Any changes will be overwritten
 ' during the next build.
 '/


#include once "crt.bi"
#include once "headers/fault_v0.1.0.bi"
#include once "fault.bi"

dim shared _moduleLocal as Module.Interface

Function exports cdecl Alias "exports" () As any ptr export
	
	moduleState.methods.startup = @Fault.startup
	moduleState.methods.shutdown = @Fault.shutdown
	moduleState.methods.registerType = @Fault.registerType
	moduleState.methods.assignHandler = @Fault.assignHandler
	moduleState.methods.getCode = @Fault.getCode
	moduleState.methods.throw = @Fault.throw
	moduleState.methods.defaultFatalHandler = @Fault.defaultFatalHandler
	moduleState.methods.defaultErrorHandler = @Fault.defaultErrorHandler
	moduleState.methods.defaultWarningHandler = @Fault.defaultWarningHandler

	return @moduleState.methods
End Function

Function load cdecl Alias "load" (modulePtr As Module.Interface ptr) As short export
	If modulePtr = NULL Then
		printf(!"**** Fault.load: Invalid Module interface pointer\n")
		return false
	End If

	If not moduleState.isLoaded Then
		moduleState.isStarted = false
		moduleState.isLoaded = true

		_moduleLocal = *modulePtr
		_module = @_moduleLocal

		_fault = exports()

		_console = modulePtr->require("console_v0.1.0")
		If _console = NULL then
			printf("**** Fault.load: Failed to load console dependency")
			Return false
		End If


		errors.internalSystemError = _fault->getCode("InternalSystemError")
		If errors.internalSystemError = NULL then
			printf(!"**** Fault.load: Missing error definition for InternalSystemError\n")
			Return false
		End If


	End If

	return true
End Function

Function unload cdecl Alias "unload" () As short export

	If moduleState.isStarted Then
		If moduleState.methods.shutdown <> NULL Then
			If not moduleState.methods.shutdown() Then
				printf(!"**** Fault.unload: Module shutdown handler failed\n")
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
				printf(!"**** Fault.startup: Module startup handler failed\n")
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
				printf(!"**** Fault.shutdown: Module shutdown handler failed\n")
			End If
		End If

		moduleState.isStarted = false
	End If

	return true
End Function
