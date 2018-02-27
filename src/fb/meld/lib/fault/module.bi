

/'
 ' Generated by Meld Framework, do not modify.  Any changes will be overwritten
 ' during the next build.
 '/

#include once "../../../../../modules/headers/fault/fault-v1.bi"
#include once "fault.bi"

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
		print("**** Fault.load: Invalid Module interface pointer")
		return false
	End If

	If not moduleState.isLoaded Then
		moduleState.references = 0
		moduleState.startups = 0
		moduleState.isLoaded = true

		_fault = exports()

		_console = modulePtr->require("console")
		If _console = NULL then
			print("**** Fault.load: Failed to load console dependency")
			Return false
		End If


		errors.internalSystemError = _fault->getCode("InternalSystemError")
		If errors.internalSystemError = NULL then
			print("**** Fault.load: Missing error definition for InternalSystemError")
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



Function startup cdecl Alias "startup" () As short export
	If moduleState.startups = 0 Then
		If moduleState.methods.startup <> NULL Then
			If not moduleState.methods.startup() Then
				print("**** Fault.startup: Module startup handler failed")
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
				print("**** Fault.startup: Module shutdown handler failed")
			End If
		End If
	End If

	return true
End Function
