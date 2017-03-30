LLVM packages for Windows
=========================

.. image:: https://ci.appveyor.com/api/projects/status/ucw3sn0e80cd1hc9?svg=true
	:target: https://ci.appveyor.com/project/vovkos/llvm-package-windows

Abstract
--------

Unfortunately, pre-built packages on the official `LLVM download page <http://releases.llvm.org>`_ cover but a tiny fraction of the possible build configuration matrix on Microsoft Windows.

**llvm-package-windows** project builds all major versions of LLVM for the following, much more complete matrix:

* Toolchain:
	- Visual Studio 2010
	- Visual Studio 2013
	- Visual Studio 2015

* Configuration:
	- Debug
	- Release

* Target CPU:
	- IA32 (a.k.a. x86)
	- AMD64 (a.k.a. x86_64)

* C/C++ Runtime:
	- libcmt (static)
	- msvcrt (dynamic)

The resulting LLVM binary packages are made publicly available as GitHub release artifacts. Other projects can then download LLVM package archives and unpack LLVM binaries, instead of building LLVM locally.

Releases
--------

* `LLVM 3.4.2 <https://github.com/vovkos/llvm-package-windows/releases/llvm-3.4.2>`_
