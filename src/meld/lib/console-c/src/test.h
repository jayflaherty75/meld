
#include "console-c.h"

namespace ConsoleC {

short testCreate (Tester::itCallback it) __attribute__((cdecl));
void test1 (Tester::doneFn done) __attribute__((cdecl));

short testCreate (Tester::itCallback it) {
	short result = TRUE;

	result = result && it("performs test 1 successfully", &test1);

	return result;
}

void test1 (Tester::doneFn done) {
	_tester->expect(TRUE, TRUE, "Invalid result from test1");
	done();
}

}