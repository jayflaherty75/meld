
#include once "../constants/constants-v1.bi"
#include once "../meld/meld-v1.bi"
#include once "../iterator/iterator-v1.bi"

namespace List

type Node
	nextPtr as List.Node ptr
	prevPtr as List.Node ptr
	element as any ptr
end type

type Instance
	first as List.Node ptr
	last as List.Node ptr
	length as integer
end type

type Interface
	construct as function () as List.Instance ptr
	destruct as sub (listPtr as List.Instance ptr)
	insert as function (listPtr as List.Instance ptr, element as any ptr, nodePtr as List.Node ptr = NULL) as List.Node ptr
	remove as sub (listPtr as List.Instance ptr, node as List.Node ptr)
	getFirst as function (listPtr as List.Instance ptr) as List.Node ptr
	getLast as function (listPtr as List.Instance ptr) as List.Node ptr
	getNext as function (listPtr as List.Instance ptr, node as List.Node ptr) as List.Node ptr
	getLength as function (listPtr as List.Instance ptr) as integer
	search as function (listPtr as List.Instance ptr, element as any ptr, compare as function(criteria as any ptr, current as any ptr) as integer) as List.Node ptr
	defaultCompare as function (criteria as any ptr, current as any ptr) as integer
	getIterator as function (listPtr as List.Instance ptr) as IteratorObj ptr
end type

end namespace

type ListObj as List.Instance
