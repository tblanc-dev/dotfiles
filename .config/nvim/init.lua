-- Option+Left/Right in WezTerm send Ctrl-Left/Ctrl-Right.
-- nvim's built-in Ctrl-arrows use WORD motion (W/B), which skips over
-- punctuation like dots. Remap them to keyword-aware word motion (w/b)
-- so the cursor stops at dots (e.g. foo.bar.baz -> foo | . | bar | . | baz).
local map = vim.keymap.set

-- Normal, visual and operator-pending modes
map({ 'n', 'x', 'o' }, '<C-Right>', 'w', { desc = 'Word forward (stops at dots)' })
map({ 'n', 'x', 'o' }, '<C-Left>', 'b', { desc = 'Word backward (stops at dots)' })

-- Insert mode (run one normal-mode motion without leaving insert)
map('i', '<C-Right>', '<C-o>w', { desc = 'Word forward (stops at dots)' })
map('i', '<C-Left>', '<C-o>b', { desc = 'Word backward (stops at dots)' })

-- Transparent background: clear nvim's own background so WezTerm's
-- background (and its 0.9 opacity / blur) shows through instead.
-- Wrapped in an autocmd so it survives loading a colorscheme later.
local function make_transparent()
  for _, group in ipairs({ 'Normal', 'NormalNC', 'NormalFloat', 'SignColumn', 'EndOfBuffer' }) do
    vim.api.nvim_set_hl(0, group, { bg = 'none' })
  end
end

vim.api.nvim_create_autocmd('ColorScheme', { callback = make_transparent })
make_transparent()
