
#include once "includes.bi"
#include once "../bootstrap.bi"

dim as zstring*64 Config = command(1)
dim as integer result = 0
dim as Bootstrap.Dependencies ptr bootDeps = Bootstrap.run()

if not testRunner(@tests(0), TEST_COUNT) then
	print ("TEST FAILED!")
	end(1)
end if

end(0)
