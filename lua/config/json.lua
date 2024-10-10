function format_json_with_jq()
  -- Get the current buffer number
  local bufnr = vim.api.nvim_get_current_buf()

  -- Get the mode (visual, normal, etc.)
  local mode = vim.api.nvim_get_mode().mode

  -- Determine range based on mode
  local start_line, end_line
  if mode == "v" or mode == "V" or mode == "" then  -- Visual mode
    -- Get visual selection range
    start_line = vim.fn.line("'<") - 1 -- Start of selection (0-indexed)
    if start_line < 0 then
      start_line = 0
    end
    end_line = vim.fn.line("'>")   -- End of selection (inclusive, 1-indexed)

    -- Ensure start_line is less than or equal to end_line
    if start_line > end_line then
      start_line, end_line = end_line, start_line 
    else
      end_line = end_line  -- Increment end_line for exclusive range
    end
  else
    -- If not in visual mode, process the entire buffer
    start_line = 0
    end_line = -1
  end

  -- Get the selected lines in the current buffer
  local lines = vim.api.nvim_buf_get_lines(bufnr, start_line, end_line, false)

  -- Combine the lines into a single string
  local input = table.concat(lines, "\n")

  -- Create a temporary file
  local temp_file = vim.fn.tempname() .. ".json"
  local file = io.open(temp_file, "w")
  if not file then
    print("Error: Failed to create temporary file.")
    return
  end

  -- Write the input JSON to the temporary file
  file:write(input)
  file:close()

  -- Use the jq command to format the JSON from the temp file
  local handle = io.popen('jq . ' .. temp_file .. ' 2>&1', 'r')
  if not handle then
    print("Error: Failed to run jq command.")
    return
  end

  -- Read the formatted output from jq
  local output = handle:read("*a")
  handle:close()

  -- Check for errors in jq output
  if output:match("^parse error") then
    print("Error: Invalid JSON detected.")
    -- Clean up temporary file before returning
    os.remove(temp_file)
    return
  end

  -- Split the output into lines to handle multiline JSON properly
  local output_lines = vim.split(output, "\n", { trimempty = true })

  -- Replace the buffer contents or visual selection with the formatted output
  vim.api.nvim_buf_set_lines(bufnr, start_line, end_line, false, output_lines)

  -- Delete the temporary file
  os.remove(temp_file)
end

vim.keymap.set({ 'n', 'v' }, '<leader>jp', function() format_json_with_jq() end, { noremap = true, silent = true })
