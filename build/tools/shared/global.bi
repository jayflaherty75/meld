
#define NULL					0

declare sub logError(byref message as string)

sub logError(byref message as string)
	dim as ulong current = color()

	color 4
	print(message)
	color(current)
end sub
