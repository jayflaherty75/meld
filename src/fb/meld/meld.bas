
#include once "lib/core.bi"

dim as zstring*64 Config = command(1)
' TODO: remove test code once there's a proper shutdown in place.
dim as integer secondsToLive = 5

if meldInitialize(@config) then
	while (meldIsRunning() andalso secondsToLive > 0)
		sleep(1000)
		secondsToLive -= 1
	wend
else
	' TODO: Use Meld error handling
	print ("Error: Failed to initialize Meld")
	meldUninitialize()
	meldShutdown(1)
end if

meldUninitialize()

end(meldGetStatus())
