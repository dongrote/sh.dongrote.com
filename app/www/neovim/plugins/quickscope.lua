return {
    'unblevable/quick-scope',
    event = { 'BufEnter' },
    config = function()
        vim.g.qs_highlight_on_keys = {'f', 'F', 't', 'T'}
    end
}
