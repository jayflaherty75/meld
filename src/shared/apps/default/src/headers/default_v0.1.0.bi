
/'
' Generated by Meld Framework, do not modify.  Any changes will be overwritten
' during the next build.
'/

namespace Default

type Interface
	startup as function cdecl () as short
	shutdown as function cdecl () as short
	construct as any ptr
	destruct as any ptr
	update as function cdecl (instancePtr as any ptr) as short
	test as function cdecl (describeFn as any ptr) as short
end type

end namespace