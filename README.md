# notify.nvim

`notify.nvim` is an notification framework plugin for neovim, which is detached from [spacevim notify API](https://spacevim.org/api/notify/).


<!-- vim-markdown-toc GFM -->

* [Installation](#installation)
* [Setup](#setup)
* [Usage](#usage)
* [Self-Promotion](#self-promotion)
* [License](#license)

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
  --available functions:
  --
  --    linear
  --    inQuad
  --    outQuad
  --    inOutQuad
  --    outInQuad
  --    inCubic
  --    outCubic
  --    inOutCubic
  --    outInCubic
  --    inQuart
  --    outQuart
  --    inOutQuart
  --    outInQuart
  --    inQuint
  --    outQuint
  --    inOutQuint
  --    outInQuint
  --    inSine
  --    outSine
  --    inOutSine
  --    outInSine
  --    inExpo
  --    outExpo
  --    inOutExpo
  --    outInExpo
  --    inCirc
  --    outCirc
  --    inOutCirc
  --    outInCirc
  --    inElastic
  --    outElastic
  --    inOutElastic
  --    outInElastic
  --    inBack
  --    outBack
  --    inOutBack
  --    outInBack
  --    inBounce
  --    outBounce
  --    inOutBounce
  --    outInBounce
})
```

## Usage

```lua
local nt = require('notify')

nt.notify('normal message')
nt.notify('warn message', 'WarningMsg)
```


## Self-Promotion

Like this plugin? Star the repository on
GitHub.

Love this plugin? Follow [me](https://wsdjeg.net/) on
[GitHub](https://github.com/wsdjeg) and
[Twitter](http://twitter.com/wsdtty).

## License

This project is licensed under the GPL-3.0 License.
