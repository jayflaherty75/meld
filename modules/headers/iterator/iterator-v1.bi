
/'
' Generated by Meld Framework, do not modify.  Any changes will be overwritten
' during the next build.
'/

#include once "../constants/constants-v1.bi"
#include once "../module/module-v1.bi"
#include once "../console/console-v1.bi"
#include once "../fault/fault-v1.bi"
#include once "../error-handling/error-handling-v1.bi"
#include once "../tester/tester-v1.bi"

namespace Iterator

type Instance
	dataSet as any ptr
	index as long
	length as long
	current as any ptr
	handler as any ptr
end type

type IteratorHandler as function cdecl (result as Iterator.Instance ptr, expected as any ptr) as short

type Interface
	startup as function cdecl () as short
	shutdown as function cdecl () as short
	construct as function cdecl () as Instance ptr
	destruct as sub cdecl (instancePtr as Instance ptr)
	test as function cdecl (describe as Tester.describeCallback) as short
	setHandler as sub cdecl (iter as Iterator.Instance ptr, cb as IteratorHandler)
	setData as sub cdecl (iter as Iterator.Instance ptr, dataSet as any ptr, setLength as long = -1)
	length as function cdecl (iter as Iterator.Instance ptr) as long
	getNext as function cdecl (iter as Iterator.Instance ptr, target as any ptr) as short
	reset as sub cdecl (iter as Iterator.Instance ptr)
end type

end namespace
