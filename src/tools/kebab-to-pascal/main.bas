
declare function parseKebab(ByRef source As String, ByRef result As String, start as short = 0) As Short
declare function capitalize(byval source as string) as string

function main() As integer
	dim as string moduleName = command(1)
	dim as string result = ""
	dim as string words(20)
	dim as integer position = 0
	dim as integer count = 0
	dim as integer i

	if moduleName = "" then
		print("kebab-to-pascal: Module name must be provided as the first argument")
		return 1
	end if

	do
		position = parseKebab(moduleName, words(count), position)
		count += 1
	loop while position <> 0

	for i = 0 to count - 1
		result &= capitalize(words(i))
	next

	print(result)

	return 0
end function

Function parseKebab(ByRef source As String, ByRef result As String, start as short = 0) As Short
	dim as short wordEnd

	start += 1
	wordEnd = instr(start, source, "-")

	if wordEnd = 0 then
		result = trim(mid(source, start))
	else
		result = trim(mid(source, start, wordEnd - start))
	end if

	return wordEnd
End Function

function capitalize(byval source as string) as string
	mid(source, 1, 1) = ucase(left(source, 1))

	return source
end function

end main()
