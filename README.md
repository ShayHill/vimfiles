A pretty standard medium-weight, Python-focused Vim config. The most atypical thing here is that I keep a vim-dedicated Python virtual environment for scripts like black, mypy, isort, pylint ... so I have these tools available for quick scripts. I also have two Python scripts I use for plugin management because they're useful in other places.

# Requirements:
* a global install of [ripgrep](https://sourceforge.net/projects/ripgrep.mirror/). I downloaded the exe from Sourceforge to `~AppData\Local\Programs`.
* a global install of [git](https://git-scm.com/downloads)
* a global install of Perl for FzfTags
* a nerd font from [Powerline](https://github.com/powerline/fonts) or [Nerd-Fonts](https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts). I like DejaVu Sans Mono.
* a subscription to [GitHub Copilot](https://github.com/features/copilot)
* a compiled binary of [gvim_fullscreen](https://github.com/movsb/gvim_fullscreen) in the vimfiles folder
* pyright (pip install) somewhere on your path or in your virtual environment
* a 32-bit Python environment, named `vim-env` in the vimfiles folder. This is where I install black, isort, pylint, etc. to keep my global Python install pristine.
* a global install of [node.js](https://nodejs.org/en/download/)
* for markdown preview, a global install of yarn

~~~
    C:\Progam Files\nodejs\npm.cmd i -g corepack
    corepack prepare yarn@stable --activate
~~~


