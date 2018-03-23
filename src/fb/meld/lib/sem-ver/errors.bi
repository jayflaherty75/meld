
namespace SemVer

/'
declare sub _throwDefaultGeneralError (byref id as zstring, byref filename as zstring, lineNum as integer)

sub _throwDefaultGeneralError (byref id as zstring, byref filename as zstring, lineNum as integer)
	_fault->throw(_
		errors.generalError, _
		"DefaultGeneralError", "Testing errors: " & id, _
		filename, lineNum _
	)
end sub
'/

end namespace

