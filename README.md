# notify.nvim

`notify.nvim` is an notification framework plugin for neovim.

<!-- vim-markdown-toc GFM -->

- [Installation](#installation)
- [Setup](#setup)
- [Usage](#usage)
- [`vim.notify`](#vimnotify)
- [Self-Promotion](#self-promotion)
- [License](#license)

<!-- vim-markdown-toc -->

## Installation

Using [nvim-plug](https://github.com/wsdjeg/nvim-plug):

```lua
require('plug').add({
  {
    'wsdjeg/notify.nvim',
    config = function()
      require('notify').setup({})
    end,
  },
})
```

## Setup

```lua
require('notify').setup({
  easing_func = 'linear',
  timeout = 3000,
})
```

## Usage

```lua
local nt = require('notify')

nt.notify('normal message')
nt.notify('warn message', 'WarningMsg')
```

## `vim.notify`

Use `vim.notify` with this plugin:

```lua
vim.notify = function(msg, level, opt)
    require('notify').notify(msg)
end
```

## Self-Promotion

Like this plugin? Star the repository on
GitHub.

Love this plugin? Follow [me](https://wsdjeg.net/) on
[GitHub](https://github.com/wsdjeg) and
[Twitter](http://twitter.com/wsdtty).

## License

This project is licensed under the GPL-3.0 License.
