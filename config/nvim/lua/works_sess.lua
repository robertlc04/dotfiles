require("workspaces").setup()
require("sessions").setup()

require("sessions").setup({
		events = { "BufEnter", "WinEnter" },
   	session_filepath = vim.fn.stdpath("data") .. "/sessions",
    absolute = true,
})



