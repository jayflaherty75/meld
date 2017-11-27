
#include once "../constants/constants-v1.bi"
#include once "../meld/meld-v1.bi"

namespace Iterator

type Instance
	dataSet as any ptr
	index as integer
	length as integer
	current as any ptr
	handler as function (iter as Iterator.Instance ptr, target as any ptr) as integer
end type

type Interface
	construct as function (dataSet as any ptr = NULL) as Iterator.Instance ptr
	destruct as sub (iPtr as Iterator.Instance ptr)
	setHandler as sub (iPtr as Iterator.Instance ptr, cb as function(iPtr as Iterator.Instance ptr) as any ptr)
	setDataSet as sub (iPtr as Iterator.Instance ptr, dataSet as any ptr)
	setCurrent as sub (iPtr as Iterator.Instance ptr, current as any ptr)
	getNext as function (iPtr as Iterator.Instance ptr, target as any ptr ptr) as BOOLEAN
end type

end namespace

type IteratorObj as Iterator.Instance
