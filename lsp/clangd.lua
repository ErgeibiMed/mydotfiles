return {
    cmd = { 'clangd',
        '--clang-tidy',
        '--background-index',
        '--offset-encoding=utf-8' },
    filetypes = { 'c', 'cpp' },
    root_markers = {
        '.clangd',
        '.clang-tidy',
        '.clang-format',
        'compile_commands.json',
        'compile_flags.txt',
        'configure.ac', -- AutoTools
        '.git',
    },
    capabilities = {
        textDocument = {
            completion = {
                editsNearCursor = true,
            },
        },
        offsetEncoding = { 'utf-8', 'utf-16' },
    },

}
