return {
	{
		"jose-elias-alvarez/null-ls.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		config = function()
			local null_ls = require("null-ls")
			local lspformatting = vim.api.nvim_create_augroup("LspFormatting", {})
			null_ls.setup({
				debounce = 2000,
				sources = {
					null_ls.builtins.formatting.trim_whitespace,
					null_ls.builtins.formatting.trim_newlines,
					null_ls.builtins.formatting.markdownlint,
					null_ls.builtins.diagnostics.markdownlint,
					null_ls.builtins.formatting.stylua,
					null_ls.builtins.formatting.gofmt,
					null_ls.builtins.formatting.goimports,
					null_ls.builtins.diagnostics.rubocop.with({
						command = "bundle",
						args = vim.list_extend({
							"exec",
							"rubocop",
							--							"--server", The server arg is causing issues for diagnostics
							"--cache-root",
							"~/.cache/rubocop_diagnostics_cache/",
							"--format",
							"json",
							"--force-exclusion",
							"--stdin",
							"$FILENAME",
						}, {}),
					}),
					null_ls.builtins.formatting.rubocop.with({
						command = "bundle",
						args = vim.list_extend({
							"exec",
							"rubocop",
							"--server",
							"-A",
							"--format",
							"quiet",
							"--stderr",
							"--stdin",
							"$FILENAME",
						}, {}),
					}),
				},
				on_attach = function(client, bufnr)
					-- Auto format on save
					if client.supports_method("textDocument/formatting") then
						vim.api.nvim_clear_autocmds({ group = lspformatting, buffer = bufnr })
						vim.api.nvim_create_autocmd("BufWritePre", {
							group = lspformatting,
							buffer = bufnr,
							callback = function()
								-- vim.lsp.buf.formatting_sync()
								-- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
								vim.lsp.buf.format({ bufnr = bufnr, timeout_ms = 10000 })
							end,
						})
					end
				end,
			})
		end,
	},
}
