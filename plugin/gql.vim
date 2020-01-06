" gql
" Version: 0.0.1
" Author: skanehira
" License: MIT

if exists('g:loaded_gql')
  finish
endif
let g:loaded_gql = 1

let s:save_cpo = &cpo
set cpo&vim

command! -nargs=1 -range GraphQL call gql#execute(<f-args>, <line1>, <line2>)

let &cpo = s:save_cpo
unlet s:save_cpo

" vim:set et:
