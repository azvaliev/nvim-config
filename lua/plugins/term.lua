return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = true,
    opts = {
      open_mapping = [[<leader>to]],
      insert_mappings = false,     
      terminal_mappings = true,
      direction = "float",       
      shade_terminals = true,
      float_opts = {                                                                                                                          
          border = "curved",    
      },
    }
  }
}
