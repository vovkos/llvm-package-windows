LLVM packages for Windows
=========================

.. image:: https://ci.appveyor.com/api/projects/status/ucw3sn0e80cd1hc9?svg=true
	:target: https://ci.appveyor.com/project/vovkos/llvm-package-windows
.. image:: https://img.shields.io/badge/donate-@jancy.org-blue.svg
	:align: right
	:target: http://jancy.org/donate.html?donate=llvm-package

Releases
--------

.. list-table::

	*	- LLVM Version
		- Clang Version
		- Remarks

	*	- `LLVM 8.0.0 <https://github.com/vovkos/llvm-package-windows/releases/llvm-8.0.0>`_
		- `Clang 8.0.0 <https://github.com/vovkos/llvm-package-windows/releases/clang-8.0.0>`_
		- The latest and greatest LLVM

	*	- `LLVM 3.4.2 <https://github.com/vovkos/llvm-package-windows/releases/llvm-3.9.1>`_
		- `Clang 3.4.2 <https://github.com/vovkos/llvm-package-windows/releases/clang-3.9.1>`_
		- The latest LLVM which still can be compiled with MSVC 2013

	*	- `LLVM 3.4.2 <https://github.com/vovkos/llvm-package-windows/releases/llvm-3.4.2-a>`_
		- `Clang 3.4.2 <https://github.com/vovkos/llvm-package-windows/releases/clang-3.4.2>`_
		- The latest LLVM which still can be compiled with MSVC 2010

	*	- LLVM x.x.x
		- Clang x.x.x
		- Create a :ref:`new issue <https://github.com/vovkos/llvm-package-windows/issues/new>` to request a particular LLVM version

Abstract
--------

LLVM is huge, and it's getting bigger with each and every release. Building it together with a project which depends on it (e.g. an LLVM-targeting programming language) during a CI build is **not an option** -- building *LLVM itself* eats most (earlier LLVM releases) and all (recent LLVM releases) of the allotted CI build time.

So why not using pre-built packages from the official `LLVM download page <http://releases.llvm.org>`_? Unfortunately, the official binaries cover just a *tiny fraction* of possible build configurations on Microsoft Windows. There are no Debug libraries, no builds for the static LIBCMT, and only a single toolchain per LLVM release.

The ``llvm-package-travis`` project builds all major versions of LLVM on AppVeyor CI for the following, much more complete matrix:

* Toolchain:
	- Visual Studio 2010 (LLVM 3.4.2 only)
	- Visual Studio 2013 (LLVM 3.4.2 to 3.9.1)
	- Visual Studio 2015 (LLVM 3.4.2 to 8.0.0)
	- Visual Studio 2017 (LLVM 3.4.2 to 8.0.0)

* Configuration:
	- Debug
	- Release

* Target CPU:
	- IA32 (a.k.a. x86)
	- AMD64 (a.k.a. x86_64)

* C/C++ Runtime:
	- LIBCMT (static)
	- MSVCRT (dynamic)

The resulting LLVM binary packages are made publicly available as GitHub release artifacts. Compiler developers can now fully test their LLVM-dependent projects on AppVeyor CI simply by downloading and unpacking a corresponding LLVM binary archive during the CI installation phase.

	Big thanks to the AppVeyor CI team for increasing the allotted build time for ``llvm-package-windows``!
