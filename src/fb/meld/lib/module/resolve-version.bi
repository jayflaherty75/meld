
#include once "dir.bi"
#include once "file.bi"

namespace Version

function convertToInt(byref numStr as string) as long
	dim as long result = 0
	dim as long mult = 1
	dim as short i

	for i = len(numStr) to 1 step -1
		result += val(mid(numStr, i, 1)) * mult
		mult *= 10
	next

	return result
end function

function getModule(byref search as string) as string
	dim as short versionPos = instr(search, "_v")

	if versionPos = 0 then return search

	return left(search, versionPos - 1)
end function

function getVersion(byref search as string) as string
	dim as short versionPos = instr(search, "_v")
	dim as string result
	dim as short extraPos

	if versionPos = 0 then return ""

	extraPos = instr(versionPos, search, "-")

	if extraPos = 0 then
		result = mid(search, versionPos + 2)
	else
		result = mid(search, versionPos + 2, extraPos - 1)
	end if

	return result
end function

function getMajor(byref version as string) as long
	dim as short startPos = instr(version, ".")

	if startPos = 0 then return -1

	return convertToInt(left(version, startPos - 1))
end function

function getMinor(byref version as string) as long
	dim as short startPos = instr(version, ".")
	dim as short endPos = instrrev(version, ".")

	if startPos = 0 then return -1
	if endPos = startPos then return -1

	return convertToInt(mid(version, startPos + 1, endPos - 1))
end function

function getPatch(byref version as string) as long
	dim as short endPos = instrrev(version, ".")

	if endPos = 0 then return -1

	return convertToInt(right(version, endPos + 1))
end function

function compare(byref version1 as string, byref version2 as string) as short
	dim as long diff

	diff = getMajor(version2) - getMajor(version1)
	if diff <> 0 then return sgn(diff)

	diff = getMinor(version2) - getMinor(version1)
	if diff <> 0 then return sgn(diff)

	diff = getPatch(version2) - getPatch(version1)
	if diff <> 0 then return sgn(diff)

	return 0
end function

function getExtra(byref search as string) as string
	dim as short versionPos = instr(search, "_v")
	dim as string result = ""
	dim as short extraPos

	if versionPos = 0 then return ""

	extraPos = instr(versionPos, search, "-")

	if extraPos > 0 then
		result = mid(search, extraPos + 1)
	end if

	return result
end function

function formatModule(byref moduleName as string, byref version as string = "", byref extra as string = "") as string
	if moduleName = "" then return ""
	if version = "" then return moduleName
	if extra = "" then return moduleName & "_v" & version

	return moduleName & "_v" & version & "-" & extra
end function

function resolve(byref fullName as string) as string
	dim as string moduleName = getModule(fullName)
	dim as string moduleVersion = getVersion(fullName)
	dim as string search
	dim as string dirName
	dim as string result
	dim as string prevDir = curdir()

	if moduleVersion = "" then moduleVersion = "*"

	search = formatModule(moduleName, moduleVersion)

	if chdir("meld_modules") then
		return ""
	end if

	if instr(search, "*") = 0 then
		if fileexists(search) then
			chdir(prevDir)
			return search
		end if

		chdir(prevDir)
		return ""
	end if

	dirName = dir(search, fbDirectory)

	do while len(dirName) > 0
		if result = "" orelse compare(getVersion(result), getVersion(dirName)) > 0 then
			result = dirName
		end if

		dirName = dir()
	loop

	chdir(prevDir)

	return result
end function

end namespace
