{
  stdenvNoCC,
  buildVimPlugin,
  vimPlugins,
  fetchFromGitHub,
  colorscheme,
  withAllTreesitterGrammars,
}:

{
  configBefore = [
    ./config/basic.lua
    ./config/autocmds.lua
    ./config/diagnostic-sort.lua
    ./config/related-information-workaround.lua
    ./config/keymap.lua
  ];

  plugins =
    let
      colorschemes = {
        gruvbox-material-dark = [
          {
            plugin = vimPlugins.gruvbox-material;
            config = ''
              vim.g.gruvbox_material_disable_terminal_colors = 1
              vim.cmd.colorscheme("gruvbox-material")
            '';
          }
        ];
        gruvbox-material-light = [
          {
            plugin = vimPlugins.gruvbox-material;
            config = ''
              vim.opt.background = "light"
              vim.g.gruvbox_material_disable_terminal_colors = 1
              vim.g.gruvbox_material_foreground = "original"
              vim.cmd.colorscheme("gruvbox-material")
            '';
          }
        ];
        catppuccin-macchiato = [
          {
            plugin = vimPlugins.catppuccin-nvim;
            config = ''vim.cmd.colorscheme("catppuccin-macchiato")'';
          }
        ];
        catppuccin-frappe = [
          {
            plugin = vimPlugins.catppuccin-nvim;
            config = ''vim.cmd.colorscheme("catppuccin-frappe")'';
          }
        ];
        catppuccin-latte = [
          {
            plugin = vimPlugins.catppuccin-nvim;
            config = ''vim.cmd.colorscheme("catppuccin-latte")'';
          }
        ];
        onedark-dark = [
          {
            plugin = vimPlugins.onedark-nvim;
            config = ''
              require("onedark").setup({ style = "dark" })
              require("onedark").load()
              vim.api.nvim_set_hl(0, "BufferCurrent", { fg = "#ffffff" })
            '';
          }
        ];
        onedark-darker = [
          {
            plugin = vimPlugins.onedark-nvim;
            config = ''
              require("onedark").setup({ style = "darker" })
              require("onedark").load()
              vim.api.nvim_set_hl(0, "BufferCurrent", { fg = "#ffffff" })
            '';
          }
        ];
      };
    in
    with vimPlugins;
    [
      {
        plugin = snacks-nvim;
        config = ./config/plugins/snacks.lua;
      }

      # UI
      {
        plugin = [
          noice-nvim
          nui-nvim
        ];
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
        plugin = [
          lualine-nvim
          package-info-nvim
          nvim-web-devicons
          aerial-nvim
        ];
        config = ./config/plugins/lualine.lua;
      }
      {
        plugin = [
          barbar-nvim
          nvim-web-devicons
        ];
        config = ./config/plugins/barbar.lua;
      }

      # Navigation
      {
        plugin = hop-nvim;
        config = ./config/plugins/hop.lua;
      }
      { plugin = vim-tmux-navigator; }
      {
        plugin = [
          nvim-tree-lua
          nvim-web-devicons
        ];
        config = ./config/plugins/nvim-tree.lua;
      }
      {
        plugin = multicursor-nvim;
        config = ./config/plugins/multicursor.lua;
      }

      # Git
      {
        plugin = [
          gitsigns-nvim
          plenary-nvim
        ];
        config = ./config/plugins/gitsigns.lua;
      }
      {
        plugin = [
          neogit
          plenary-nvim
        ];
        config = ./config/plugins/neogit.lua;
      }

      # Treesitter
      {
        plugin =
          if withAllTreesitterGrammars then
            nvim-treesitter.withAllGrammars
          else
            nvim-treesitter.withPlugins (
              parsers: with parsers; [
                nix
                bash
              ]
            );
        config = ./config/plugins/treesitter.lua;
      }
      {
        plugin = nvim-treesitter-context;
        config = ./config/plugins/treesitter-context.lua;
      }

      # Coding
      {
        plugin = blink-cmp;
        config = ./config/plugins/blink.lua;
      }
      {
        plugin =
          let
            direnv-nvim = buildVimPlugin {
              pname = "direnv-nvim";
              version = "2025-10-07";
              src = fetchFromGitHub {
                owner = "actionshrimp";
                repo = "direnv.nvim";
                rev = "0d2edd378dbdf2c653869772d761ad914219ba9d";
                hash = "sha256-p2im4nUV0n9HQsjCA9oGJvTADfKGlCEr/RYWGlUszuU=";
              };
            };
          in
          [
            nvim-lspconfig
            direnv-nvim
          ];
        config = ./config/plugins/lsp.lua;
      }
      {
        plugin = [
          package-info-nvim
          nui-nvim
        ];
        config = "require('package-info').setup {}";
      }

      # Misc
      {
        plugin = indent-o-matic;
        config = ./config/plugins/indent-o-matic.lua;
      }
      {
        plugin = stdenvNoCC.mkDerivation {
          pname = "spell";
          version = "1.0";
          srcs = [
            (builtins.fetchurl {
              url = "https://ftp.nluug.nl/vim/runtime/spell/de.utf-8.spl";
              sha256 = "sha256:1ld3hgv1kpdrl4fjc1wwxgk4v74k8lmbkpi1x7dnr19rldz11ivk";
            })
            (builtins.fetchurl {
              url = "https://ftp.nluug.nl/vim/runtime/spell/de.utf-8.sug";
              sha256 = "sha256:0j592ibsias7prm1r3dsz7la04ss5bmsba6l1kv9xn3353wyrl0k";
            })
          ];
          dontUnpack = true;
          sourceRoot = ".";
          buildPhase = ''
            mkdir -p $out/spell

            for _src in $srcs; do
              cp "$_src" "$out/spell/$(stripHash "$_src")"
            done
          '';
        };
      }
    ]
    ++ colorschemes.${colorscheme};
}
