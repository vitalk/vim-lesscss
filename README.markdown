# lesscss

Vim plugin that make it easy to edit less files without need to manually update
corresponding css file.

## Installation

If your don't have a preferred way to install Vim plugins, try to use
[pathogen](https://github.com/tpope/vim-pathogen) and then run:

```bash
cd ~/.vim/bundle
git clone git://github.com/vitalk/vim-lesscss.git
```

## Walkthrough

Just open your `less` file in Vim and edit it. On save corresponding `css` file
will be created with the same name as original. If your want to save the output
`css` files anywhere else add to your `vimrc`:

```viml
" save css files to separate css folder(relative to original less)
let g:lesscss_save_to = '../css/'
```

To use another external program to process `less` files or to add some options
define it:

```viml
" less to css executable(full path or simple executable)
let g:lesscss_cmd = 'lessc'
```

## License

Copyright © Vital Kudzelka <vital.kudzelka@gmail.com>. Distribute under the
same terms as Vim itself. See `:help license` for details.
