
#include once "lib/core.bi"

dim as zstring*64 Config = command(1)
dim as integer test = 5

if meldInitialize(@config) then
    while (meldIsRunning() andalso test > 0)
        sleep(1000)
        test -= 1
    wend
else
    print ("Error: Failed to initialize Meld")
    meldUninitialize()
    end(1)
end if

meldUninitialize()

end(0)
