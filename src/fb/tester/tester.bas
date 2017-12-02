
#include once "includes.bi"
#include once "../bootstrap.bi"

dim as zstring*64 Config = command(1)
dim as integer result = 0
dim as Bootstrap.Dependencies ptr bootDeps = Bootstrap.run()

dim as Tester.Interface ptr _tester = bootDeps->tester

if not _tester->run(@tests(0), TEST_COUNT) then
	print ("TEST FAILED!")
	end(1)
end if

end(0)
