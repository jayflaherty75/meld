<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output indent="yes" omit-xml-declaration="yes" />
	<xsl:template match="/">
	#include once "../constants/constants-v1.bi"
	#include once "../core/core-v1.bi"
	#include once "../fault/fault-v1.bi"
	#include once "../iterator/iterator-v1.bi"

	namespace Bst

	type Node
		rightPtr as Bst.Node ptr
		leftPtr as Bst.Node ptr
		parent as Bst.Node ptr
		element as any ptr
	end type

	type Instance
		id as zstring*64
		root as Bst.Node ptr
		length as integer
		compare as function(criteria as any ptr, element as any ptr) as integer
	end type

	type Interface
		load as function cdecl (corePtr as Core.Interface ptr) as integer
		unload as sub cdecl ()
		register as function () as integer
		unregister as sub ()
		construct as function(byref id as zstring) as Bst.Instance ptr
		destruct as sub (btreePtr as Bst.Instance ptr)
		insert as function (btreePtr as Bst.Instance ptr, element as any ptr) as Bst.Node ptr
		remove as sub (btreePtr as Bst.Instance ptr, nodePtr as Bst.Node ptr)
		purge as sub (btreePtr as Bst.Instance ptr)
		search as function (btreePtr as Bst.Instance ptr, element as any ptr, start as Bst.Node ptr = NULL) as Bst.Node ptr
		getLength as function (btreePtr as Bst.Instance ptr) as integer
		getIterator as function (btreePtr as Bst.Instance ptr) as IteratorObj ptr
		defaultCompare as function (criteria as any ptr, element as any ptr) as integer
	end type

	end namespace

	type BstObj as Bst.Instance
	</xsl:template>
</xsl:stylesheet>
