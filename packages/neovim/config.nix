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
          vim.cmd("colorscheme gruvbox-material")
        '';
      }];
      catppuccin-macchiato = [{
        plugin = vimPlugins.catppuccin-nvim;
        config = ''vim.cmd("colorscheme catppuccin-macchiato")'';
      }];
      catppuccin-frappe = [{
        plugin = vimPlugins.catppuccin-nvim;
        config = ''vim.cmd("colorscheme catppuccin-frappe")'';
      }];
    };
  in with vimPlugins;
  [
    {
      # TODO: Remove override when package is updated (NixOS 25.05?)
      plugin = snacks-nvim.overrideAttrs (old: {
        src = fetchFromGitHub {
          owner = "folke";
          repo = "snacks.nvim";
          rev = "1b63b1811c58f661ad22f390a52aa6723703dc3d";
          hash = "sha256-lK8IBGCxiUgB8zO72Ei7NOfDFi4Gs0IGL3fN2MReZNw=";
        };
      });
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
      plugin = [ nvim-cmp cmp-nvim-lsp cmp-buffer cmp-path cmp-cmdline ];
      config = ./config/plugins/cmp.lua;
    }
    {
      plugin = [ nvim-lspconfig cmp-nvim-lsp ];
      config = ./config/plugins/lsp.lua;
    }
    {
      plugin = [ package-info-nvim nui-nvim ];
      config = "require('package-info').setup {}";
    }
    {
      plugin = [ vim-bsv ];
    }

    # Misc
    {
      plugin = indent-o-matic;
      config = ./config/plugins/indent-o-matic.lua;
    }
    {
      plugin = buildVimPlugin {
        pname = "qalc.nvim";
        version = "2023-12-15";
        src = fetchFromGitHub {
          owner = "Apeiros-46B";
          repo = "qalc.nvim";
          rev = "d3072e5ac8dc1caa4b60f673c53f70c7e06f1367";
          sha256 = "sha256-2ZBAa2J4thkEJqzs0bYZngtkuwslHVNqJjmZKSSzoO4=";
        };
        meta.homepage = "https://github.com/Apeiros-46B/qalc.nvim";
      };
      config = "require('qalc').setup{}";
    }
  ] ++ colorschemes.${colorscheme};
}
