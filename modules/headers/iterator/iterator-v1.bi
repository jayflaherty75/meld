
type IteratorInterface
	construct as function (dataSet as any ptr = NULL) as Iterator ptr
	destruct as sub (iPtr as Iterator ptr)
	setHandler as sub (iPtr as Iterator ptr, cb as function(iPtr as Iterator ptr) as any ptr)
	setDataSet as sub (iPtr as Iterator ptr, dataSet as any ptr)
	setCurrent as sub (iPtr as Iterator ptr, current as any ptr)
	getNext as function (iPtr as Iterator ptr, target as any ptr ptr) as BOOLEAN
end type

dim as IteratorInterface ptr IteratorPtr
