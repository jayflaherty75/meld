
/''
 ' @requires module
 '/
 
/''
 ' @namespace Meld
 '/
 
/''
 ' Called by Meld during when required by another module.
 ' @function load
 ' @param {Module.Interface ptr} modulePtr - Used for calls to require() and export()
 ' @returns {short}
 '/
 
/''
 ' Used by Meld to disassociates a module from the rest of the system.
 ' @function unload
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
 '/
