local util = require "formatter.util"

return function(lang)
  return {
    exe = "prettydiff",
    args = {
      util.format_prettydiff_arg("mode", "beautify"),
      util.format_prettydiff_arg("lang", lang),
      util.format_prettydiff_arg("readmethod", "filescreen"),
      util.format_prettydiff_arg("endquietly", "quiet"),
      util.format_prettydiff_arg("source", util.get_current_buffer_file_path()),
    },
    no_append = true,
  }
end
