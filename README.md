# Template Project

Modify README.md, LICENSE, .gitignore and Makefile.

* `src/` contains source code
* `lib/` contains .so and .a files
* `out/` contains built projects
* `tst/` contains test code

There are 5 different build products you can create:

* `$(NAME)`         - dev build
* `$(NAME)_release` - release
* `lib$(NAME).so`   - shared object
* `lib$(NAME).a`    - static lib
* `$(NAME)-$(VERSION).tar.gz` - library tar

Use `make install_so` and `make install_a` to install as shared/static
respectively. Run them as root or with `make INSTALLTO=~/foo`.  
`sudo make uninstall` or `make uninstall INSTALLTO=~/foo` to uninstall.

src/libbin.h should be removed if an app not library, and renamed to libname.h
if making a shared or static library. Alteratively, you can make it auto-generated
