return {
	"stevearc/conform.nvim",
	opts = {},
	config = function()
		conform = require("conform")
		conform.setup({
			formatters_by_ft = {
				-- python = { "black", "isort" }, Handled by LSP
				lua = { "stylua" },
				go = { "gofmt", "goimports" },
				json = { "jq" },
				typescript = { "prettier" },
				javascript = { "prettier" },
				typescriptreact = { "prettier" },
				javascriptreact = { "prettier" },
				eruby = { "erb_format" },
			},
			format_on_save = {
				-- These options will be passed to conform.format()
				timeout_ms = 1000,
				lsp_fallback = true,
			},
		})

		conform.formatters.jq = {
			prepend_args = { "--indent", "2" },
		}
	end,
}
