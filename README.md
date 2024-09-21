# Neovim config

## Dependencies

### Telescope

- [ripgrep](https://github.com/BurntSushi/ripgrep?tab=readme-ov-file#installation), fuzzy searching
- [fd](https://github.com/sharkdp/fd?tab=readme-ov-file#installation), for finding files

### LSP's

Mason should auto install them, but to install the various LSP you'll probably need
- Node >= 18
- Rust (stable)

### Test Running

- Rust-Analyzer (in line with the Rust version)
  Needed to run Rust tests

### JSON Formatter

- [jq](https://github.com/jqlang/jq?tab=readme-ov-file#jq)
  Needed for the `<leader>jp` command to format JSON in a file
