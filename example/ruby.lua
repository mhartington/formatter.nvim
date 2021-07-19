-- Enable rubocop formatting in ruby
require('formatter').setup({
  logging = false,
  filetype = {
    ruby = {
      -- rubocop run on one file
      function()
        return {
          exe = "rubocop", -- might prepend `bundle exec `
          args = { '--auto-correct', '--stdin', '%:p', '2>/dev/null', '|', 'sed "1,/^====================$/d"' },
          stdin = true,
        }
      end
    }
  }
})
