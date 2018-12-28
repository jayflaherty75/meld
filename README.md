# meld
Bringing the ease and convenience of modern package management to compiled languages.

* Versioned management for shared libraries (.dll, .so)
* Extensible language support (currently providing C++ and FreeBASIC)
* Write once, use anywhere
* Runs on Linux and Windows
* Get reflection for free (even in C++)
* Designed for test-driven development, run any module individually from the command-line and get test output
* Hot module reloading at run-time (in development)

## Planned features

* Language support for C, Rust and Go
* Mac support
* Node Add-On for integration with Node and Electron
* Bindings to Lua

## Requirements

* Relevant compiler(s): g++ and fbc supported
* xsltproc

## Usage

Initialize the current directory with a new C module.
```
meld init c
```

Build the module from it's project root.
```
meld build
```

Launch a module, running any tests that were included.
```
meld launch module-name [...]
```

Link a local module in development.
```
meld link module-name
```

Unlink a previously linked local module.
```
meld unlink module-name
```

Install a module from the Meld repo.
```
meld install module-name
```

Publish out to the world!
```
meld publish
```

Get help.
```
meld help
```
