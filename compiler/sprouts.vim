" Sprouts AS3/Flex Compiler Utility
" Maintainer: Endel Dreyer <endel.dreyer@gmail.com>
" Last Change: 2012-02-20

if exists("current_compiler")
    finish
endif

let current_compiler = "sprouts"
let sproutsCmd = 'rake'

if exists("g:sproutsOptions")
  let sproutsCmd = sproutsCmd . ' ' . g:sproutsOptions
endif

let &l:makeprg=sproutsCmd

setlocal errorformat=
            \%-GLoading\ configuration\ file,
            \%E%f(%l):\ \ Error:\ %m,
            \%W%f(%l):\ Warning:\ %m,
            \%+C%.%#
