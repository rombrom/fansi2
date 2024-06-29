# FANSI2: Because ANSI can be fancy too

![FANSI Screenshot](https://raw.githubusercontent.com/rombrom/fansi2/master/screenshot.png)

**Disclaimer:** "Works on my machine." Feel free to PR.

FANSI is a little Neovim color scheme which originally was intended to utilize the terminal's ANSI colors. This should still work when you `set notermguicolors` but there were some discrepancies due to Neovim/Treesitter I can't remember. The `set termguicolors` variation uses colors defined in [my dotfiles repo](https://github.com/rombrom/dotfiles): a theme called Bluebox, inspired by Gruvbox.

There is only one theme. Dark background will definitely work. Light background might but is untested. There is no customization. If required you can link custom highlight groups to any of the FANSI2 definitions.

## Usage

1. Include it with your favorite plugin manager
2. `colorscheme fansi2`
