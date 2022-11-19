System Copy
===========

System copy provides vim mappings for copying / pasting text to the os specific
clipboard.  Most people will be happy just setting their Vim clipboard to the
system clipboard, but I find that doing so pollutes my clipboard history.
Instead, this plugin creates a unique mapping that explicitly pulls content
from Vim into the system clipboard.

Usage
-----

System copy provides a mapping to copy to the system clipboard using a motion
or visual selection. It also provides a mapping for pasting from the system
clipboard.

The default mapping is `cp` for copying and `cv` for pasting, and can be followed by any motion or text
object. For instance:

- `cpiw` => copy word into system clipboard
- `cpi'` => copy inside single quotes to system clipboard
- `cvi'` => paste inside single quotes from system clipboard

In addition, `cP` is mapped to copy the current line directly.

The sequence `cV` is mapped to paste the content of system clipboard to the
next line.

Clipboard Utilities
-------------------

 - OSX     - `pbcopy` and `pbpaste`
 - Windows - `clip` and `paste`
 - Linux   - `xsel` on X11, and `wl-copy` and `wl-paste` on Wayland

 **Note:** `xsel` can be installed with `apt-get install xsel` if your system doesn't have it installed.

 - OS-independent copy - provided by `ojroques/vim-oscyank` based on `ANSI OSC52 sequence`
 
 **Note:** This feature requires an external plugin [ojroques/vim-oscyank](https://github.com/ojroques/vim-oscyank)
 and needs to be [manually enabled](#using-osc52-copy-as-fallback). 
 The terminal emulators that support this feature are listed [here](https://github.com/ojroques/vim-oscyank#vim-oscyank). 

Options
-------

### Customizing copy & paste command

`system-copy` uses default copy and paste command based on your OS, but
you can override either of these commands if you have more specific needs.

To declare custom copy command use following example:
``` vim
let g:system_copy#copy_command='xclip -sel clipboard'
```
And to declare custom paste command use:
``` vim
let g:system_copy#paste_command='xclip -sel clipboard -o'
```

### Supressing message output

By default `system_copy` prints a message each time you execute the copy- or paste-operation.
If you want to suppress it use:
```vim
let g:system_copy_silent = 1
```

### Using OSC52 copy as fallback
OSC52 is an ANSI escape sequence that allows you to copy text into your
system clipboard from the [supported terminal emulators](https://github.com/ojroques/vim-oscyank#vim-oscyank).

It is useful for running Vim via remote SSH, especially when the default
copy command or X11 forwarding is unavaliable on the remote host.
Once this feature is enabled, OSC52 copy sequence is used as a fallback
if the default copy command failed. You can enable this feature
on your local machine with [ojroques/vim-oscyank](https://github.com/ojroques/vim-oscyank)
plugin and the supported terminal emulator installed:
```vim
let g:system_copy_enable_osc52 = 1
```
**Note:** By default, no extra settings for `ojroques/vim-oscyank` are
required. Only works when copying to the system clipboard; does not
support pasting from the system clipboard.

Installation
------------

If you don't have a preferred installation method, I recommend using [Vundle](https://github.com/VundleVim/Vundle.vim).
Assuming you have Vundle installed and configured, the following steps will
install the plugin:

Add the following line to your `~/.vimrc` and then run `:PluginInstall` from
within Vim:

``` vim
call vundle#begin()
" ...
Plugin 'christoomey/vim-system-copy'
" ...
call vundle#end()
```
