
/'
' Generated by Meld Framework, do not modify.  Any changes will be overwritten
' during the next build.
'/


#include once "../../../../../modules/headers/sys/sys-v1.bi"
#include once "sys.bi"

Function exports cdecl Alias "exports" () As any ptr export
	
	moduleState.methods.startup = @Sys.startup
	moduleState.methods.shutdown = @Sys.shutdown
	moduleState.methods.getNewline = @Sys.getNewline
	moduleState.methods.getDirsep = @Sys.getDirsep
	moduleState.methods.getModuleExt = @Sys.getModuleExt
	moduleState.methods.getTimestamp = @Sys.getTimestamp
	moduleState.methods.getMacAddress = @Sys.getMacAddress

	return @moduleState.methods
End Function

Function load cdecl Alias "load" (modulePtr As Module.Interface ptr) As short export
	If modulePtr = NULL Then
		print("**** Sys.load: Invalid Module interface pointer")
		return false
	End If

	If not moduleState.isLoaded Then
		moduleState.isStarted = false
		moduleState.isLoaded = true

		_moduleLocal = *modulePtr
		_module = @_moduleLocal

		_sys = exports()



	End If

	return true
End Function

Function unload cdecl Alias "unload" () As short export

	If moduleState.isStarted Then
		If moduleState.methods.shutdown <> NULL Then
			If not moduleState.methods.shutdown() Then
				print("**** Sys.unload: Module shutdown handler failed")
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
				print("**** Sys.startup: Module startup handler failed")
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
				print("**** Sys.shutdown: Module shutdown handler failed")
			End If
		End If

		moduleState.isStarted = false
	End If

	return true
End Function
