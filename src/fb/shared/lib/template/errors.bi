
namespace Template

'declare sub _throwTemplateAllocationError (byref id as zstring, byref filename as zstring, lineNum as integer)
'declare sub _throwTemplateDestructNullReferenceError (byref filename as zstring, lineNum as integer)
'declare sub _throwTemplateDestructReleaseError (btreePtrbstPtr as TemplateObj ptr, byref filename as zstring, lineNum as integer)

'sub _throwTemplateAllocationError (byref id as zstring, byref filename as zstring, lineNum as integer)
'	_fault->throw(_
'		errors.resourceAllocationError, _
'		"TemplateAllocationError", "Failed to allocate Template instance: " & id, _
'		filename, lineNum _
'	)
'end sub

'sub _throwTemplateDestructNullReferenceError (byref filename as zstring, lineNum as integer)
'	_fault->throw(_
'		errors.nullReferenceError, _
'		"TemplateDestructNullReferenceError", "Attempt to reference a NULL Template", _
'		filename, lineNum _
'	)
'end sub

'sub _throwTemplateDestructReleaseError (btreePtr as TemplateObj ptr, byref filename as zstring, lineNum as integer)
'	_fault->throw(_
'		errors.releaseResourceError, _
'		"TemplateDestructReleaseError", "Failed to correctly release all resources from Template: " & btreePtr->id, _
'		filename, lineNum _
'	)
'end sub

end namespace
