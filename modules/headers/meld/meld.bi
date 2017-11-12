
#define MELD_INTERFACE_NAME_LENGTH      64
#define MELD_FUNCTION_NAME_LENGTH       64
#define MELD_ARGUMENT_NAME_LENGTH       32

type ArgumentHeader
    name as zstring*MELD_ARGUMENT_NAME_LENGTH
    argType as zstring*MELD_INTERFACE_NAME_LENGTH
end type

type FunctionHeader
    name as zstring*MELD_FUNCTION_NAME_LENGTH
	returnType as zstring*MELD_INTERFACE_NAME_LENGTH
	argCount as integer
end type

type InterfaceHeader
    name as zstring*MELD_INTERFACE_NAME_LENGTH
    extends as any ptr
    access as integer
    funcCount as integer
end type

type MeldInterface
    initialize as function (config as zstring ptr) as integer
    uninitialize as sub()
    isRunning as function() as integer
    shutdown as sub()
end type

dim shared as MeldInterface PTR meldPtr
