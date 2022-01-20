MAIL_MOVEMENT
===============================================================================
_by Ingo Karkat_

DESCRIPTION
------------------------------------------------------------------------------

This filetype plugin provides movement commands and text objects for email
quotes.

USAGE
------------------------------------------------------------------------------

    A quoted email is determined either by:
    - lines prefixed with ">" (one, or multiple for nested quotes)
    - an optional email separator, e.g.
    -----Original Message-----
      and the standard
    From: <Name>
      optionally followed by other header lines.

    Move around email quotes of either:
    - a certain nesting level, as determined by the current line; if the cursor is
      not on a quoted line, any nesting level will be used.
    - the range of lines from the "From: <Name>" mail header up to the line
      preceding the next email separator or next mail header.

    ]]                      Go to [count] next start of an email quote.
    ][                      Go to [count] next end of an email quote.
    [[                      Go to [count] previous start of an email quote.
    []                      Go to [count] previous end of an email quote.

    Move to nested email quote (i.e. of a higher nesting level as the current
    line; if the cursor is not on a quoted line, any nesting level will be used).

    ]+                      Go to [count] next start of a nested email quote.
    [+                      Go to [count] previous start of a nested email quote.

    aq                      "a quote" text object, select [count] email quotes, i.e.
                            - contiguous lines having at least the same as the
                              current line's nesting level
                            - one email message including the preceding mail
                              headers and optional email separator
    iq                      "inner quote" text object, select [count] regions with
                            either:
                            - the same nesting level
                            - the contents of an email message without the
                              preceding mail headers

INSTALLATION
------------------------------------------------------------------------------

The code is hosted in a Git repo at
    https://github.com/inkarkat/vim-mail_movement
You can use your favorite plugin manager, or "git clone" into a directory used
for Vim packages. Releases are on the "stable" branch, the latest unstable
development snapshot on "master".

This script is also packaged as a vimball. If you have the "gunzip"
decompressor in your PATH, simply edit the \*.vmb.gz package in Vim; otherwise,
decompress the archive first, e.g. using WinZip. Inside Vim, install by
sourcing the vimball or via the :UseVimball command.

    vim mail_movement*.vmb.gz
    :so %

To uninstall, use the :RmVimball command.

The commands and text objects are only active when 'filetype' is set to
"mail". If you use Vim as an external editor for your browser or email
program, you need to make sure that the filetype is properly detected, or
manually set the filetype every time via

    :setf mail

If you want to use this plugin also for other filetypes, e.g. "txt", create a
file ftplugin/txt\_movement.vim in your 'runtimepath' (usually ~/.vim) with the
following contents:

    runtime! ftplugin/mail_movement.vim

### DEPENDENCIES

- Requires Vim 7.0 or higher.
- Requires the CountJump plugin ([vimscript #3130](http://www.vim.org/scripts/script.php?script_id=3130)), version 1.40.

CONFIGURATION
------------------------------------------------------------------------------

For a permanent configuration, put the following commands into your vimrc:

To change the default motion mapping, use:

    let g:mail_movement_BeginMapping = ''
    let g:mail_movement_EndMapping = ''
    let g:mail_movement_NestedMapping = '+'

To also change the [ / ] prefix to something else, follow the instructions for
CountJump-remap-motions.

To change the default text object mappings, use:

    let g:mail_movement_QuoteTextObject = 'q'

To also change the i prefix to something else, follow the instructions for
CountJump-remap-text-objects.

IDEAS
------------------------------------------------------------------------------

- Support "[On ..., ]&lt;Name&gt; wrote:" header:
  - Adapt motions to accept this in place of the "From:" header.
  - Include in "aq" text object
- Add "ah" text object for the mail header block.

### CONTRIBUTING

Report any bugs, send patches, or suggest features via the issue tracker at
https://github.com/inkarkat/vim-mail_movement/issues or email (address below).

HISTORY
------------------------------------------------------------------------------

##### 1.55    22-Jul-2014
- Allow to reconfigure the mappings for the motion and text objects.
- Extract functions into separate autoload script.

##### 1.54    05-Jun-2013
- Avoid use of s:function() by using autoload function name. This fixes a regression in Vim 7.3.1032, reported by lilydjwg.

##### 1.53    13-Jun-2011
- FIX: Directly ring the bell to avoid problems when running under :silent!.

##### 1.52    20-Dec-2010
- Adapted to CountJump#Region#JumpToNextRegion() again returning jump position in
version 1.40.

##### 1.51    20-Dec-2010
- ENH: ][ mapping in operator-pending and visual mode now also operates over /
  select the last line of the quote. This is what the user expects.
- Adapted to changed interface of CountJump.vim; now requires version 1.30.

##### 1.50    08-Aug-2010
- ENH: Added support for MS Outlook-style quoting with email separator and mail
headers.

##### 1.00    03-Aug-2010
- First published version.

------------------------------------------------------------------------------
Copyright: (C) 2010-2022 Ingo Karkat -
The [VIM LICENSE](http://vimdoc.sourceforge.net/htmldoc/uganda.html#license) applies to this plugin.

Maintainer:     Ingo Karkat &lt;ingo@karkat.de&gt;
