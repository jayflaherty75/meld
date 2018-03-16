
/''
 ' @requires tester
 '/
 
/''
 ' @namespace Meld
 '/
 
/''
 ' @class Instance
 ' @member {ulong} references
 '/

/''
 ' Startup lifecycle function called by Meld framework after the module has
 ' been loaded.
 ' @function startup
 ' @returns {short}
 ' @throws {ModuleLoadingError}
 '/
 
/''
 ' Shutdown lifecycle function called by Meld to disassociates a module from
 ' the rest of the system before unloading.
 ' @function shutdown
 ' @returns {short}
 '/

/''
 ' Constructor
 ' @function construct
 ' @returns {Instance ptr}
 '/

/''
 ' Destructor
 ' @function destruct
 ' @param {Instance ptr} instancePtr
 '/

/''
 ' Run or update an instance or pass NULL to run statically.
 ' @function update
 ' @param {any ptr} instancePtr
 ' @returns {short}
 '/

/''
 ' Standard test runner for modules.
 ' @function test
 ' @param {Tester.describeCallback} describe
 ' @returns {short}
 '/
