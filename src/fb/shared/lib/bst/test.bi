
#include once "bst.bi"

namespace Bst

declare function testCreate (it as Tester.itCallback) as short
declare sub test1 (done as Tester.doneFn)
declare sub test2 (done as Tester.doneFn)
declare sub test3 (done as Tester.doneFn)
declare sub test4 (done as Tester.doneFn)
declare sub test5 (done as Tester.doneFn)
declare sub test6 (done as Tester.doneFn)
declare sub test7 (done as Tester.doneFn)
declare sub test30 (done as Tester.doneFn)

const as integer dataLen = 15

dim shared as integer testData(dataLen-1) = { 8, 4, 12, 2, 1, 3, 6, 5, 7, 10, 9, 11, 14, 13, 15 }
dim shared as Bst.Instance ptr btreePtr
dim shared as Bst.Node ptr nodePtr

function testCreate (it as Tester.itCallback) as short
	dim as short result = true

	result = result ANDALSO it ("creates a BST instance", @test1)
	result = result ANDALSO it ("inserts a set of nodes", @test2)
	result = result ANDALSO it ("returns the correct tree size", @test3)
	result = result ANDALSO it ("successfully searches a node inside the tree", @test4)
	result = result ANDALSO it ("removes node from search", @test5)
	result = result ANDALSO it ("removes root node", @test6)
	result = result ANDALSO it ("creates a working iterator", @test7)

	result = result ANDALSO it ("releases remaining nodes when tree deleted", @test30)

	return result
end function

sub test1 (done as Tester.doneFn)
	btreePtr = _bst->construct()

	_tester->expectPtrNot(btreePtr, NULL, "Constructor returned NULL")

	done()
end sub

sub test2 (done as Tester.doneFn)
	dim as integer i
	dim as integer result = true

	for i = 0 to dataLen-1
		nodePtr = _bst->insert(btreePtr, @testData(i))

		_tester->expectPtrNot(nodePtr, NULL, "Insert returned NULL")
		_tester->expect(_bst->getLength(btreePtr), i + 1, "Length of tree incorrect")
	next

	done()
end sub

sub test3 (done as Tester.doneFn)
	_tester->expect(_bst->getLength(btreePtr), dataLen, "Length of tree incorrect")

	done()
end sub

sub test4(done as Tester.doneFn)
	nodePtr = _bst->search(btreePtr, @testData(3))

	_tester->expectPtrNot(nodePtr, NULL, "Search returned NULL")
	_tester->expect(*cptr(integer ptr, nodePtr->element), testData(3), "Search returned the wrong value")

	done()
end sub

sub test5 (done as Tester.doneFn)
	_bst->remove(btreePtr, nodePtr)
	nodePtr = NULL

	_tester->expect(_bst->getLength(btreePtr), dataLen-1, "Removing a node yields the wrong length")

	done()
end sub

sub test6 (done as Tester.doneFn)
	_bst->remove(btreePtr, btreePtr->root)

	_tester->expect(_bst->getLength(btreePtr), dataLen-2, "Removing the root node yields the wrong length")

	done()
end sub

sub test7 (done as Tester.doneFn)
	dim as Iterator.Instance ptr iter = _bst->getIterator(btreePtr)
	dim as integer ptr valPtr

	_tester->expectPtrNot(iter, NULL, "Call to getIterator() returned NULL")

	_iterator->getNext(iter, @valPtr)
	_tester->expect(*valPtr, 1, "Call to getNext() returned the incorrect value")

	_iterator->getNext(iter, @valPtr)
	_tester->expect(*valPtr, 3, "Call to getNext() returned the incorrect value")

	_iterator->getNext(iter, @valPtr)
	_tester->expect(*valPtr, 4, "Call to getNext() returned the incorrect value")

	_iterator->getNext(iter, @valPtr)
	_tester->expect(*valPtr, 5, "Call to getNext() returned the incorrect value")

	_iterator->getNext(iter, @valPtr)
	_tester->expect(*valPtr, 6, "Call to getNext() returned the incorrect value")

	_iterator->getNext(iter, @valPtr)
	_tester->expect(*valPtr, 7, "Call to getNext() returned the incorrect value")

	_iterator->getNext(iter, @valPtr)
	_tester->expect(*valPtr, 9, "Call to getNext() returned the incorrect value")

	_iterator->getNext(iter, @valPtr)
	_tester->expect(*valPtr, 10, "Call to getNext() returned the incorrect value")

	_iterator->getNext(iter, @valPtr)
	_tester->expect(*valPtr, 11, "Call to getNext() returned the incorrect value")

	_iterator->getNext(iter, @valPtr)
	_tester->expect(*valPtr, 12, "Call to getNext() returned the incorrect value")

	_iterator->getNext(iter, @valPtr)
	_tester->expect(*valPtr, 13, "Call to getNext() returned the incorrect value")

	_iterator->getNext(iter, @valPtr)
	_tester->expect(*valPtr, 14, "Call to getNext() returned the incorrect value")

	_iterator->getNext(iter, @valPtr)
	_tester->expect(*valPtr, 15, "Call to getNext() returned the incorrect value")

	_iterator->destruct(iter)
	iter = NULL

	done()
end sub

sub test30 (done as Tester.doneFn)
	dim as integer length

	_bst->destruct (btreePtr)
	btreePtr = NULL

	done()
end sub

end namespace

