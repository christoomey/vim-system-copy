System Copy
===========

System copy provides vim mappings for copying text to the os specific
clipboard.  Most people will be happy just setting their Vim clipboard to the
system clipboard, but I find that doing so pollutes my clipboard history.
Instead, this plugin creates a unique mapping that explicitly pulls content
from Vim into the system clipboard.

Usage
-----

System copy provides a mapping to copy to the system clipboard. It accepts a
motion or can be used with a visual selection.

The default mapping is `cp`, and can be followed by any motion or text
object. For instance:

- `cpiw` => copy word into system clipboard
- `cpi'` => copy inside single quotes to system clipboard

In addition, `cP` is mapped to copy the current line directly.

Clipboard Utilities
-------------------

 - OSX     - pbcopy
 - Windows - clip
 - Linux   - xsel

Installation
------------

If you don't have a preferred installation method, I recommend using [Vundle][].
Assuming you have Vundle installed and configured, the following steps will
install the plugin:

Add the following line to your `~/.vimrc` and then run `PluginInstall` from
within Vim:

``` vim
Plugin 'christoomey/vim-system-copy'
```
