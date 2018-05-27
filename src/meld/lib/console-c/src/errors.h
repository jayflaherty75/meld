
#pragma once

namespace ConsoleC {
	void _throwConsoleCGeneralError (char *filename, int lineNum) {
		(*_fault->throwErr)(
			errors.generalError,
			"ConcoleCGeneralError", "Testing errors",
			filename, lineNum
		);
	}
}


