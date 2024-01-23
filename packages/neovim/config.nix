{ vimPlugins, fetchFromGitHub }:

{
  configBefore = [
    ./config/basic.lua
    ./config/autocmds.lua
    ./config/diagnostic-sort.lua
    ./config/related-information-workaround.lua
  ];

  plugins = with vimPlugins; [
    # Colors
    {
      plugin = gruvbox-material;
      config = ./config/plugins/gruvbox.lua;
    }

    # UI
    {
      plugin = nvim-notify;
      config = ''require("notify").setup{ stages = "fade"; }'';
    }
    {
      plugin = [ noice-nvim nui-nvim ];
      config = ./config/plugins/noice.lua;
    }
    {
      plugin = dressing-nvim;
      config = ./config/plugins/dressing.lua;
    }
    {
      # satellite.nvim is only compatible with the latest nightly version of neovim
      plugin = satellite-nvim.overrideAttrs {
        version = "2023-05-25";
        src = fetchFromGitHub {
          owner = "lewis6991";
          repo = "satellite.nvim";
          rev = "022c884978b888d5b5812052c64d0d243092155e";
          sha256 = "sha256-8S9MLedEq9O8HJx8n7yFS5gKn8Ap7SOLMf45eGIzbUQ=";
        };
      };
      config = ''require("satellite").setup()'';
    }
    {
      plugin = [ alpha-nvim nvim-web-devicons ];
      config = ./config/plugins/alpha.lua;
    }
    {
      plugin = indent-blankline-nvim;
      config = ./config/plugins/indent-blankline.lua;
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
    {
      plugin = vim-tmux-navigator;
    }

    # Treesitter
    {
      plugin = nvim-treesitter.withAllGrammars;
    }

    # Misc
    {
      plugin = indent-o-matic;
      config = ./config/plugins/indent-o-matic.lua;
    }
  ];
}
