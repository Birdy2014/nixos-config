{ buildVimPlugin, vimPlugins, fetchFromGitHub, colorscheme }:

{
  configBefore = [
    ./config/basic.lua
    ./config/autocmds.lua
    ./config/diagnostic-sort.lua
    ./config/related-information-workaround.lua
    ./config/keymap.lua
  ];

  plugins = let
    colorschemes = {
      gruvbox-material-dark = [{
        plugin = vimPlugins.gruvbox-material;
        config = ''
          vim.g.gruvbox_material_disable_terminal_colors = 1
          vim.cmd.colorscheme("gruvbox-material")
        '';
      }];
      gruvbox-material-light = [{
        plugin = vimPlugins.gruvbox-material;
        config = ''
          vim.opt.background = "light"
          vim.g.gruvbox_material_disable_terminal_colors = 1
          vim.cmd.colorscheme("gruvbox-material")
        '';
      }];
      catppuccin-macchiato = [{
        plugin = vimPlugins.catppuccin-nvim;
        config = ''vim.cmd.colorscheme("catppuccin-macchiato")'';
      }];
      catppuccin-frappe = [{
        plugin = vimPlugins.catppuccin-nvim;
        config = ''vim.cmd.colorscheme("catppuccin-frappe")'';
      }];
      catppuccin-latte = [{
        plugin = vimPlugins.catppuccin-nvim;
        config = ''vim.cmd.colorscheme("catppuccin-latte")'';
      }];
    };
  in with vimPlugins;
  [
    {
      plugin = snacks-nvim;
      config = ./config/plugins/snacks.lua;
    }

    # UI
    {
      plugin = [ noice-nvim nui-nvim ];
      config = ./config/plugins/noice.lua;
    }
    {
      plugin = indent-blankline-nvim;
      config = ./config/plugins/indent-blankline.lua;
    }
    {
      plugin = nvim-colorizer-lua;
      config = ./config/plugins/colorizer.lua;
    }
    {
      plugin = which-key-nvim;
      config = ./config/plugins/which-key.lua;
    }

    # Bars
    {
      plugin = [ lualine-nvim package-info-nvim nvim-web-devicons ];
      config = ./config/plugins/lualine.lua;
    }
    {
      plugin = [ barbar-nvim nvim-web-devicons ];
      config = ./config/plugins/barbar.lua;
    }

    # Navigation
    {
      plugin = hop-nvim;
      config = ./config/plugins/hop.lua;
    }
    { plugin = vim-tmux-navigator; }
    {
      plugin = [ nvim-tree-lua nvim-web-devicons ];
      config = ./config/plugins/nvim-tree.lua;
    }
    {
      plugin = buildVimPlugin {
        pname = "multicursor-nvim";
        version = "2025-05-13";
        src = fetchFromGitHub {
          owner = "jake-stewart";
          repo = "multicursor.nvim";
          rev = "c731e52cee7b69fa05915affb09ba65e7cd31fa9";
          hash = "sha256-rw7jE89Lj5F7bOCAx/rMO+Dpswfg9ohKDyQ3RJtaa3I=";
        };
      };
      config = ./config/plugins/multicursor.lua;
    }

    # Git
    {
      plugin = [ gitsigns-nvim plenary-nvim ];
      config = ./config/plugins/gitsigns.lua;
    }
    {
      plugin = [ neogit plenary-nvim ];
      config = ./config/plugins/neogit.lua;
    }

    # Treesitter
    {
      plugin = nvim-treesitter.withAllGrammars;
      config = ./config/plugins/treesitter.lua;
    }

    # Coding
    {
      # TODO: Switch to blink.cmp (when updating to NixOS 25.05)? Or maybe to the native completion?
      plugin = [ nvim-cmp cmp-nvim-lsp cmp-buffer cmp-path cmp-cmdline ];
      config = ./config/plugins/cmp.lua;
    }
    {
      # TODO: Replace lspconfig with native lsp configuration in nvim 0.11 (NixOS 25.05)?
      plugin = [ nvim-lspconfig cmp-nvim-lsp ];
      config = ./config/plugins/lsp.lua;
    }
    {
      plugin = [ package-info-nvim nui-nvim ];
      config = "require('package-info').setup {}";
    }

    # Misc
    {
      plugin = indent-o-matic;
      config = ./config/plugins/indent-o-matic.lua;
    }
    {
      plugin = buildVimPlugin {
        pname = "qalc.nvim";
        version = "2025-03-09";
        src = fetchFromGitHub {
          owner = "Apeiros-46B";
          repo = "qalc.nvim";
          rev = "7697cff543b7089c858f3b26a013c1eb52fe86fa";
          sha256 = "sha256-Qb254SyjhT4ao1BJ2r152Ca2B8IHikvnnO+9MQFj0vI=";
        };
        meta.homepage = "https://github.com/Apeiros-46B/qalc.nvim";
      };
      config = "require('qalc').setup{}";
    }
  ] ++ colorschemes.${colorscheme};
}
