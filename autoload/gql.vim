" gql
" Author: skanehira
" License: MIT

let s:save_cpo = &cpo
set cpo&vim

let s:bufname = 'GRAPHQL OUTPUT'

function! s:echo_err(msg) abort
  echohl ErrorMsg
  echom 'gql.vim: ' .. a:msg
  echohl None
endfunction

function! gql#execute(endpoint, start, end) abort
  if !executable('curl')
    call s:echo_err('not found curl, please install curl: https://curl.haxx.se/')
    return
  endif
  if a:start == a:end
    let contens = join(getline(1, "$"), " ")
  else
    let contens = join(getline(a:start, a:end), " ")
  endif

  if bufexists(s:bufname)
    let buf = bufnr(s:bufname)
    let winid = win_findbuf(buf)
    if empty(winid)
      silent exec 'new | e' s:bufname '| %d_'
    endif
    call win_execute(winid[0], '%d_')
  else
    silent exec 'new' s:bufname '| %d_'
    set buftype=nofile | set ft=json | nnoremap <buffer> q :bw<CR>
  endif

  let base_cmd = ['curl']
  let args = ['-s', '-X', 'POST']
  let token = get(g:, 'gql_authorization_token', '')
  if token isnot ''
    let args += ['-H', '''Authorization: bearer ' .. token .. '''']
  endif
  let args += ['-d', printf('''%s''', contens), a:endpoint]

  let base_cmd += args

  if executable('jq')
    let base_cmd += ['| jq']
  endif

  let cmd = join(base_cmd, " ")
  call setbufline(s:bufname, 1, systemlist(cmd))
  redraw
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
