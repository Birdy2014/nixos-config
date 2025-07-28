{
  stdenvNoCC,
  buildVimPlugin,
  vimPlugins,
  fetchFromGitHub,
  fetchurl,
  colorscheme,
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
      kanso-nvim = buildVimPlugin {
        pname = "kanso-nvim";
        version = "2025-07-25";
        src = fetchFromGitHub {
          owner = "webhooked";
          repo = "kanso.nvim";
          rev = "925b8a210027ec51959697250c1cd9f56d17f6cd";
          hash = "sha256-gNef33nCJvrjaMCldjRm+5OKxltmDg3UnPd3cFsVO20=";
        };
      };

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
        kanso-mist = [
          {
            plugin = kanso-nvim;
            config = ''vim.cmd.colorscheme("kanso-mist")'';
          }
        ];
        kanso-pearl = [
          {
            plugin = kanso-nvim;
            config = ''
              require('kanso').setup({
                foreground = "contrast",
              })
              vim.cmd.colorscheme("kanso-pearl")
            '';
          }
        ];
      };

      # Fix deprecation warnings for vim.tbl_islist
      # TODO: Remove once nui-nvim is updated in nixpkgs stable (NixOS 25.11?)
      nui-nvim-v0_4_0 = vimPlugins.nui-nvim.overrideAttrs (
        final: prev: {
          version = "0.4.0-1";
          rockspecVersion = final.version;
          knownRockspec =
            (fetchurl {
              url = "mirror://luarocks/nui.nvim-0.4.0-1.rockspec";
              sha256 = "sha256-Ll8j93K9whJlooWPl7hTYryqHUlDFZYsLTCevJg6SC8=";
            }).outPath;
          src = prev.src.override {
            rev = "0.4.0";
            hash = "sha256-SJc9nfV6cnBKYwRWsv0iHy+RbET8frNV85reICf+pt8=";
          };
        }
      );
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
          nui-nvim-v0_4_0
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
        plugin = nvim-treesitter.withAllGrammars;
        config = ./config/plugins/treesitter.lua;
      }

      # Coding
      {
        plugin = blink-cmp;
        config = ./config/plugins/blink.lua;
      }
      {
        plugin = nvim-lspconfig;
        config = ./config/plugins/lsp.lua;
      }
      {
        plugin = [
          package-info-nvim
          nui-nvim-v0_4_0
        ];
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
