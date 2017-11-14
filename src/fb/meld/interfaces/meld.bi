
#include once "../../../modules/headers/meld/meld.bi"

type MeldFuncInitialize
	header as FunctionHeader
	arg1 as ArgumentHeader
end type

type MeldFuncUninitialize
	header as FunctionHeader
end type

type MeldFuncIsRunning
	header as FunctionHeader
end type

type MeldFuncGetStatus
	header as FunctionHeader
end type

type MeldFuncShutdown
	header as FunctionHeader
	arg1 as ArgumentHeader
end type

type MeldInterfaceDescriptorType
	header as InterfaceHeader
	func1 as MeldFuncInitialize
	func2 as MeldFuncUninitialize
	func3 as MeldFuncIsRunning
	func4 as MeldFuncGetStatus
	func5 as MeldFuncShutdown
end type

dim shared as MeldInterfaceDescriptorType meldInterfaceDescriptor

meldInterfaceDescriptor.header.name = "Meld"
meldInterfaceDescriptor.header.extends = NULL
meldInterfaceDescriptor.header.access = 0
meldInterfaceDescriptor.header.funcCount = 5
meldInterfaceDescriptor.func1.name = "initialize"
meldInterfaceDescriptor.func1.returnType = ''
meldInterfaceDescriptor.func1.argCount = 1
meldInterfaceDescriptor.func1.arg1.name = "status"
meldInterfaceDescriptor.func1.arg1.argType = "integer"
meldInterfaceDescriptor.func2.name = "uninitialize"
meldInterfaceDescriptor.func2.returnType = ''
meldInterfaceDescriptor.func2.argCount = 0
meldInterfaceDescriptor.func3.name = "isRunning"
meldInterfaceDescriptor.func3.returnType = ''
meldInterfaceDescriptor.func3.argCount = 0
meldInterfaceDescriptor.func4.name = "getStatus"
meldInterfaceDescriptor.func4.returnType = ''
meldInterfaceDescriptor.func4.argCount = 0
meldInterfaceDescriptor.func5.name = "shutdown"
meldInterfaceDescriptor.func5.returnType = ''
meldInterfaceDescriptor.func5.argCount = 1
meldInterfaceDescriptor.func5.arg1.name = "status"
meldInterfaceDescriptor.func5.arg1.argType = "integer"
'type MeldInterface
'    initialize as function (config as zstring ptr) as integer
'    uninitialize as sub()
'    isRunning as function() as integer
'	getStatus as function() as integer
'    shutdown as sub(status as integer)
'end type
