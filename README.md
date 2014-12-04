**pfvim**
=========

Description
-----------

Based on [sudo.vim](https://github.com/vim-scripts/sudo.vim).

This script eases use of vim with pfexec by adding the ability to
edit one file with root privleges without running the whole
session that way.

Platforms
---------

SunOS distributions (Solaris, OpenIndiana, ...)

Usage
-----

Put it in the plugin directory, and

command line: `$ vim pf:/etc/hosts`

  within vim: `:e pf:/etc/hosts`
          or: `:PfEdit /etc/hosts`

