{ vimPlugins, fetchFromGitHub }:

{
  configBefore = [
    ./config/basic.lua
    ./config/autocmds.lua
    ./config/diagnostic-sort.lua
    ./config/related-information-workaround.lua
    ./config/keymap.lua
  ];

  plugins = with vimPlugins; [
    # Colors
    {
      plugin = gruvbox-material;
      config = ./config/plugins/gruvbox.lua;
    }

    # UI
    {
      plugin = [ noice-nvim nui-nvim ];
      config = ./config/plugins/noice.lua;
    }
    {
      plugin = dressing-nvim;
      config = ./config/plugins/dressing.lua;
    }
    {
      plugin = [ alpha-nvim nvim-web-devicons ];
      config = ./config/plugins/alpha.lua;
    }
    {
      plugin = indent-blankline-nvim;
      config = ./config/plugins/indent-blankline.lua;
    }
    {
      plugin = nvim-colorizer-lua;
      config = ./config/plugins/colorizer.lua;
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
      plugin = [ telescope-nvim plenary-nvim ];
      config = ./config/plugins/telescope.lua;
    }
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

    # Misc
    {
      plugin = indent-o-matic;
      config = ./config/plugins/indent-o-matic.lua;
    }
    {
      plugin = nvim-osc52;
      config = ./config/plugins/osc52.lua;
    }
  ];
}
