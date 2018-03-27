
/'
' Generated by Meld Framework, do not modify.  Any changes will be overwritten
' during the next build.
'/


#include once "headers/sem-ver_v0.1.0.bi"
#include once "sem-ver.bi"

dim shared _moduleLocal as Module.Interface

Function exports cdecl Alias "exports" () As any ptr export
	
	moduleState.methods.startup = @SemVer.startup
	moduleState.methods.shutdown = @SemVer.shutdown

	return @moduleState.methods
End Function

Function load cdecl Alias "load" (modulePtr As Module.Interface ptr) As short export
	If modulePtr = NULL Then
		print("**** SemVer.load: Invalid Module interface pointer")
		return false
	End If

	If not moduleState.isLoaded Then
		moduleState.isStarted = false
		moduleState.isLoaded = true

		_moduleLocal = *modulePtr
		_module = @_moduleLocal

		_semVer = exports()

		_sys = modulePtr->require("sys")
		If _sys = NULL then
			print("**** SemVer.load: Failed to load sys dependency")
			Return false
		End If



	End If

	return true
End Function

Function unload cdecl Alias "unload" () As short export

	If moduleState.isStarted Then
		If moduleState.methods.shutdown <> NULL Then
			If not moduleState.methods.shutdown() Then
				print("**** SemVer.unload: Module shutdown handler failed")
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
				print("**** SemVer.startup: Module startup handler failed")
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
				print("**** SemVer.shutdown: Module shutdown handler failed")
			End If
		End If

		moduleState.isStarted = false
	End If

	return true
End Function
