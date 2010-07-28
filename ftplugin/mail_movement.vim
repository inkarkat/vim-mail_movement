" mail_movement.vim: Movement over email quotes with ]] etc. 
"
" DEPENDENCIES:
"   - CountJump/Region.vim, CountJump/TextObjects.vim autoload scripts. 
"
" Copyright: (C) 2010 by Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'. 
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS 
"	001	19-Jul-2010	file creation from diff_movement.vim

" Avoid installing when in unsupported Vim version. 
if v:version < 700
    finish
endif 

let s:save_cpo = &cpo
set cpo&vim

"			Move around email quotes: 
"]]			Go to [count] next start of an email quote. 
"][			Go to [count] next end of an email quote. 
"[[			Go to [count] previous start of an email quote. 
"[]			Go to [count] previous end of an email quote. 

function! s:function(name)
    return function(substitute(a:name, '^s:', matchstr(expand('<sfile>'), '<SNR>\d\+_\zefunction$'),''))
endfunction 
function! s:QuotePattern( quotePrefix, isInner )
    return '\V\^' . escape(a:quotePrefix, '\') . (a:isInner ? '\%( \*\$\| \*\[^ >]\)' : '')
endfunction

function! s:JumpToBeginForward( mode )
    return CountJump#Region#Jump(a:mode, function('CountJump#Region#SearchForNextRegion'), s:QuotePattern('>', 0), 1, 0)
endfunction
function! s:JumpToBeginBackward( mode )
    return CountJump#Region#Jump(a:mode, function('CountJump#Region#SearchForNextRegion'), s:QuotePattern('>', 0), -1, 1)
endfunction
function! s:JumpToEndForward( mode )
    return CountJump#Region#Jump(a:mode, function('CountJump#Region#SearchForNextRegion'), s:QuotePattern('>', 0), 1, 1)
endfunction
function! s:JumpToEndBackward( mode )
    return CountJump#Region#Jump(a:mode, function('CountJump#Region#SearchForNextRegion'), s:QuotePattern('>', 0), -1, 0)
endfunction
call CountJump#Motion#MakeBracketMotionWithJumpFunctions('<buffer>', '', '', 
\   s:function('s:JumpToBeginForward'),
\   s:function('s:JumpToBeginBackward'),
\   s:function('s:JumpToEndForward'),
\   s:function('s:JumpToEndBackward'),
\   0
\)


"aq			"a quote" text object, select [count] email quotes
"iq			"inner quote" text object, select [count] regions with
"			the same quoting level
function! s:JumpToQuoteBegin( count, isInner )
    let s:quotePrefix = matchstr(getline('.'), '^[ >]*>')
    if empty(s:quotePrefix)
	return [0, 0]
    endif

    return CountJump#Region#SearchForRegionEnd(a:count, s:QuotePattern(s:quotePrefix, a:isInner), -1)
endfunction
function! s:JumpToQuoteEnd( count, isInner )
    return CountJump#Region#SearchForRegionEnd(a:count, s:QuotePattern(s:quotePrefix, a:isInner), 1)
endfunction
call CountJump#TextObject#MakeWithJumpFunctions('<buffer>', 'q', 'aI', 'V',
\   s:function('s:JumpToQuoteBegin'),
\   s:function('s:JumpToQuoteEnd'),
\)

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: set sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
