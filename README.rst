LLVM packages for Windows
=========================

.. image:: https://github.com/vovkos/llvm-package-windows/actions/workflows/ci.yml/badge.svg
	:target: https://github.com/vovkos/llvm-package-windows/actions/workflows/ci.yml
.. image:: https://img.shields.io/badge/donate-@jancy.org-blue.svg
	:align: right
	:target: http://jancy.org/donate.html?donate=llvm-package

Releases
--------

.. list-table::

	*	- LLVM Date
		- LLVM Version
		- Clang Version
		- Remarks

	*	- 2023-Jun-14
		- `LLVM 16.0.6 <https://github.com/vovkos/llvm-package-windows/releases/llvm-16.0.6>`_
		-
		- The latest LLVM that still can be compiled with MSVC 2019

	*	- 2023-Jan-12
		- `LLVM 15.0.7 <https://github.com/vovkos/llvm-package-windows/releases/llvm-15.0.7>`_
		-
		- Starting with this release, LLVM requires the external `cmake` folder

	*	- 2022-Jun-25
		- `LLVM 14.0.6 <https://github.com/vovkos/llvm-package-windows/releases/llvm-14.0.6>`_
		-
		-

	*	- 2022-Feb-02
		- `LLVM 13.0.1 <https://github.com/vovkos/llvm-package-windows/releases/llvm-13.0.1>`_
		-
		-

	*	- 2021-Jul-08
		- `LLVM 12.0.1 <https://github.com/vovkos/llvm-package-windows/releases/llvm-12.0.1>`_
		- `Clang 12.0.1 <https://github.com/vovkos/llvm-package-windows/releases/clang-12.0.1>`_
		-

	*	- 2021-Feb-25
		- `LLVM 11.1.0 <https://github.com/vovkos/llvm-package-windows/releases/llvm-11.1.0>`_
		- `Clang 11.1.0 <https://github.com/vovkos/llvm-package-windows/releases/clang-11.1.0>`_
		-

	*	- 2020-Aug-06
		- `LLVM 10.0.1 <https://github.com/vovkos/llvm-package-windows/releases/llvm-10.0.1>`_
		- `Clang 10.0.1 <https://github.com/vovkos/llvm-package-windows/releases/clang-10.0.1>`_
		-

	*	- 2019-Dec-20
		- `LLVM 9.0.1 <https://github.com/vovkos/llvm-package-windows/releases/llvm-9.0.1>`_
		- `Clang 9.0.1 <https://github.com/vovkos/llvm-package-windows/releases/clang-9.0.1>`_
		-

	*	- 2019-Jul-19
		- `LLVM 8.0.1 <https://github.com/vovkos/llvm-package-windows/releases/llvm-8.0.1>`_
		- `Clang 8.0.1 <https://github.com/vovkos/llvm-package-windows/releases/clang-8.0.1>`_
		- The latest LLVM that still can be compiled with MSVC 2015

	*	- 2019-May-10
		- `LLVM 7.1.0 <https://github.com/vovkos/llvm-package-windows/releases/llvm-7.1.0>`_
		- `Clang 7.1.0 <https://github.com/vovkos/llvm-package-windows/releases/clang-7.1.0>`_
		- The ABI compatibility with GCC fix for LLVM 7

	*	- 2016-Dec-23
		- `LLVM 3.9.1 <https://github.com/vovkos/llvm-package-windows/releases/llvm-3.9.1>`_
		- `Clang 3.9.1 <https://github.com/vovkos/llvm-package-windows/releases/clang-3.9.1>`_
		- The latest LLVM that still can be compiled with MSVC 2013

	*	- 2014-Jun-19
		- `LLVM 3.4.2 <https://github.com/vovkos/llvm-package-windows/releases/llvm-3.4.2>`_
		- `Clang 3.4.2 <https://github.com/vovkos/llvm-package-windows/releases/clang-3.4.2>`_
		- The latest LLVM that still can be compiled with MSVC 2010

	*	-
		- LLVM x.x.x
		- Clang x.x.x
		- Create a `new issue <https://github.com/vovkos/llvm-package-windows/issues/new>`__ to request a particular LLVM version

Abstract
--------

LLVM is huge, and it's getting bigger with each and every release. Building it together with a project that depends on it (e.g., a programming language) during a CI build is **not an option** -- building *just LLVM* eats most (earlier LLVM releases), and all (recent LLVM releases) of the allotted CI build time.

So why not use pre-built packages from the official `LLVM download page <http://releases.llvm.org>`__? Unfortunately, the official binaries cover just a *tiny fraction* of possible build configurations on Microsoft Windows. There are no Debug libraries, no builds for the static LIBCMT, and only a single toolchain per LLVM release.

The ``llvm-package-windows`` project builds all major versions of LLVM on **GitHub Actions** for the following, much more complete matrix:

* Toolchain:
	- Visual Studio 2017
	- Visual Studio 2015 (LLVM 3.4.2 to 8.0.0)
	- Visual Studio 2013 (LLVM 3.4.2 to 3.9.1)
	- Visual Studio 2010 (LLVM 3.4.2 only)

* Configuration:
	- Debug
	- Release

* Target CPU:
	- IA32 (a.k.a. x86)
	- AMD64 (a.k.a. x86_64)

* C/C++ Runtime:
	- LIBCMT (static)
	- MSVCRT (dynamic)

The resulting LLVM binary packages are uploaded as GitHub Release artifacts. Compiler developers can now thoroughly test their LLVM-dependent projects on GitHub CI or AppVeyor CI simply by downloading and unpacking an archive with the required LLVM prebuilt binaries during the CI installation stage.

Sample
------

* `Jancy <https://github.com/vovkos/jancy>`__ uses ``llvm-package-windows`` for CI testing on a range of configurations and LLVM versions. See `build logs <https://github.com/vovkos/jancy/actions>`__ for more details.
