LLVM packages for Windows
=========================

.. image:: https://github.com/vovkos/llvm-package-windows/actions/workflows/ci.yml/badge.svg
	:target: https://github.com/vovkos/llvm-package-windows/actions/workflows/ci.yml

Releases
--------

.. list-table::

	*	- Date
		- LLVM
		- Clang
		- Remarks

	*	- 2025-09-10
		- `LLVM 21.1.1 <https://github.com/vovkos/llvm-package-windows/releases/llvm-21.1.1>`_
		-
		- The latest official LLVM release

	*	- 2025-07-09
		- `LLVM 20.1.8 <https://github.com/vovkos/llvm-package-windows/releases/llvm-20.1.8>`_
		-
		-

	*	- 2025-01-14
		- `LLVM 19.1.7 <https://github.com/vovkos/llvm-package-windows/releases/llvm-19.1.7>`_
		-
		-

	*	- 2024-06-19
		- `LLVM 18.1.8 <https://github.com/vovkos/llvm-package-windows/releases/llvm-18.1.8>`_
		- `Clang 18.1.8 <https://github.com/vovkos/llvm-package-windows/releases/clang-18.1.8>`_
		-

	*	- 2023-11-28
		- `LLVM 17.0.6 <https://github.com/vovkos/llvm-package-windows/releases/llvm-17.0.6>`_
		- `Clang 17.0.6 <https://github.com/vovkos/llvm-package-windows/releases/clang-17.0.6>`_
		-

	*	- 2023-06-14
		- `LLVM 16.0.6 <https://github.com/vovkos/llvm-package-windows/releases/llvm-16.0.6>`_
		- `Clang 16.0.6 <https://github.com/vovkos/llvm-package-windows/releases/clang-16.0.6>`_
		- The latest LLVM that still can be compiled with MSVC 16 2019

	*	- 2023-01-12
		- `LLVM 15.0.7 <https://github.com/vovkos/llvm-package-windows/releases/llvm-15.0.7>`_
		- `Clang 15.0.7 <https://github.com/vovkos/llvm-package-windows/releases/clang-15.0.7>`_
		- Starting with this release, LLVM requires the external `cmake` folder

	*	- 2022-06-25
		- `LLVM 14.0.6 <https://github.com/vovkos/llvm-package-windows/releases/llvm-14.0.6>`_
		- `Clang 14.0.6 <https://github.com/vovkos/llvm-package-windows/releases/clang-14.0.6>`_
		-

	*	- 2022-02-02
		- `LLVM 13.0.1 <https://github.com/vovkos/llvm-package-windows/releases/llvm-13.0.1>`_
		- `Clang 13.0.1 <https://github.com/vovkos/llvm-package-windows/releases/clang-13.0.1>`_
		- The latest LLVM that still can be compiled with MSVC 15 2017

	*	- 2021-07-08
		- `LLVM 12.0.1 <https://github.com/vovkos/llvm-package-windows/releases/llvm-12.0.1>`_
		- `Clang 12.0.1 <https://github.com/vovkos/llvm-package-windows/releases/clang-12.0.1>`_
		-

	*	- 2021-02-25
		- `LLVM 11.1.0 <https://github.com/vovkos/llvm-package-windows/releases/llvm-11.1.0>`_
		- `Clang 11.1.0 <https://github.com/vovkos/llvm-package-windows/releases/clang-11.1.0>`_
		-

	*	- 2020-08-06
		- `LLVM 10.0.1 <https://github.com/vovkos/llvm-package-windows/releases/llvm-10.0.1>`_
		- `Clang 10.0.1 <https://github.com/vovkos/llvm-package-windows/releases/clang-10.0.1>`_
		-

	*	- 2019-12-20
		- `LLVM 9.0.1 <https://github.com/vovkos/llvm-package-windows/releases/llvm-9.0.1>`_
		- `Clang 9.0.1 <https://github.com/vovkos/llvm-package-windows/releases/clang-9.0.1>`_
		-

	*	- 2019-07-19
		- `LLVM 8.0.1 <https://github.com/vovkos/llvm-package-windows/releases/llvm-8.0.1>`_
		- `Clang 8.0.1 <https://github.com/vovkos/llvm-package-windows/releases/clang-8.0.1>`_
		- The latest LLVM that still can be compiled with MSVC 14 2015

	*	- 2019-05-10
		- `LLVM 7.1.0 <https://github.com/vovkos/llvm-package-windows/releases/llvm-7.1.0>`_
		- `Clang 7.1.0 <https://github.com/vovkos/llvm-package-windows/releases/clang-7.1.0>`_
		- The ABI compatibility with GCC fix for LLVM 7

	*	- 2016-12-23
		- `LLVM 3.9.1 <https://github.com/vovkos/llvm-package-windows/releases/llvm-3.9.1>`_
		- `Clang 3.9.1 <https://github.com/vovkos/llvm-package-windows/releases/clang-3.9.1>`_
		- The latest LLVM that still can be compiled with MSVC 12 2013

	*	- 2014-06-19
		- `LLVM 3.4.2 <https://github.com/vovkos/llvm-package-windows/releases/llvm-3.4.2>`_
		- `Clang 3.4.2 <https://github.com/vovkos/llvm-package-windows/releases/clang-3.4.2>`_
		- The latest LLVM that still can be compiled with MSVC 10 2010

	*	-
		- LLVM x.x.x
		- Clang x.x.x
		- Create a `new issue <https://github.com/vovkos/llvm-package-windows/issues/new>`__ to request a particular LLVM version

Abstract
--------

LLVM is huge, and it's getting bigger with each and every release. Building it together with a project that depends on it (e.g., a programming language) during a CI build stage is not a good option -- building LLVM alone takes hours!

So why not use pre-built packages from the official `LLVM download page <http://releases.llvm.org>`__? Unfortunately, the official Windows binaries only include the ``LLVM-C.dll``, Clang, and *some* tools -- there are no LLVM headers, C++ libraries, and many essential LLVM tools such as ``lli``.

The ``llvm-package-windows`` project builds all major versions of the LLVM and Clang libraries on **GitHub Actions** for the following matrix:

* Configuration:
	- Debug
	- Release

* Target CPU:
	- IA32 (a.k.a. x86)
	- AMD64 (a.k.a. x86_64)

* C/C++ Runtime:
	- LIBCMT (static)
	- MSVCRT (dynamic)

The resulting LLVM binary packages are uploaded as GitHub Release artifacts. Compiler developers can now thoroughly test their LLVM-dependent projects on GitHub CI or AppVeyor CI simply by downloading and unpacking an archive with the required LLVM prebuilt libraries and tools during the CI installation stage.

Sample
------

* `Jancy <https://github.com/vovkos/jancy>`__ uses ``llvm-package-windows`` for CI testing on a range of configurations and LLVM versions. See `build logs <https://github.com/vovkos/jancy/actions>`__ for more details.
