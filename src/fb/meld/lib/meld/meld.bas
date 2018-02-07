
/''
 ' @requires module
 '/
 
/''
 ' @namespace Meld
 '/
 
/''
 ' Called by Meld during when required by another module.
 ' @function exports
 ' @returns {any ptr}
 '/
 
/''
 ' Called by Meld during when required by another module.
 ' @function load
 ' @param {Module.Interface ptr} modulePtr
 ' @returns {short}
 '/
 
/''
 ' Used by Meld to disassociates a module from the rest of the system.
 ' @function unload
 ' @returns {short}
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
