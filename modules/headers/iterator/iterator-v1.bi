
#include once "../constants/constants-v1.bi"
#include once "../core/core-v1.bi"
#include once "../fault/fault-v1.bi"

namespace Iterator

type Instance
	dataSet as any ptr
	index as integer
	length as integer
	current as any ptr
	handler as function (iter as Iterator.Instance ptr, target as any ptr) as integer
end type

type Interface
	load as function (corePtr as Core.Interface ptr) as integer
	unload as sub ()
	register as function () as integer
	unregister as sub ()
	construct as function (dataSet as any ptr = NULL, length as integer = -1) as Iterator.Instance ptr
	destruct as sub (iter as Iterator.Instance ptr)
	setHandler as sub (iter as Iterator.Instance ptr, cb as function(iter as Iterator.Instance ptr, target as any ptr) as integer)
	setData as sub (iter as Iterator.Instance ptr, dataSet as any ptr, length as integer = -1)
	getNext as function (iter as Iterator.Instance ptr, target as any ptr) as integer
	reset as sub (iter as Iterator.Instance ptr)
end type

end namespace

type IteratorObj as Iterator.Instance
