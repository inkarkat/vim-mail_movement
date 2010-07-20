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


" call CountJump#Motion#MakeBracketMotion('<buffer>', '', '', 
" \   s:diffHunkHeaderPattern,
" \   s:diffHunkEndPattern,
" \   0
" \)


"aq			"a quote" text object, select [count] email quotes
"iq			"inner quote" text object, select [count] regions with
"			the same quoting level
function! s:QuotePattern( isQuoteLevel )
    return '\V\^' . escape(s:quotePrefix, '\') . (a:isQuoteLevel ? '\%( \*\$\| \*\[^ >]\)' : '')
endfunction
function! s:JumpToQuoteRegionBegin( count, isQuoteLevel )
    let s:quotePrefix = matchstr(getline('.'), '^[ >]*>')
    if empty(s:quotePrefix)
	return [0, 0]
    endif

    return CountJump#Region#SearchForRegionBorder(a:count, s:QuotePattern(a:isQuoteLevel), -1)
endfunction
function! s:JumpToQuoteRegionEnd( count, isQuoteLevel )
    return CountJump#Region#SearchForRegionBorder(a:count, s:QuotePattern(a:isQuoteLevel), 1)
endfunction
function! s:JumpToQuoteBegin( count, isInner )
    return s:JumpToQuoteRegionBegin(a:count, 0)
endfunction
function! s:JumpToQuoteEnd( count, isInner )
    return s:JumpToQuoteRegionEnd(a:count, 0)
endfunction
function! s:JumpToQuoteLevelBegin( count, isInner )
    return s:JumpToQuoteRegionBegin(a:count, 1)
endfunction
function! s:JumpToQuoteLevelEnd( count, isInner )
    return s:JumpToQuoteRegionEnd(a:count, 1)
endfunction
function! s:function(name)
    return function(substitute(a:name, '^s:', matchstr(expand('<sfile>'), '<SNR>\d\+_\zefunction$'),''))
endfunction 
call CountJump#TextObject#MakeWithJumpFunctions('<buffer>', 'q', 'a', 'V',
\   s:function('s:JumpToQuoteBegin'),
\   s:function('s:JumpToQuoteEnd'),
\)
call CountJump#TextObject#MakeWithJumpFunctions('<buffer>', 'q', 'i', 'V',
\   s:function('s:JumpToQuoteLevelBegin'),
\   s:function('s:JumpToQuoteLevelEnd'),
\)

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: set sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
