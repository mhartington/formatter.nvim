local M = {}

M.default_config = {
  logging = true,
  log_level = vim.log.levels.WARN,
  filetype = {
    ["*"] = {},
  },
}

M.values = M.default_config

function M.validate_config(user_config)
  if not user_config then
    return true
  end

  if type(user_config) ~= "table" then
    return false
  end

  if user_config.logging then
    if type(user_config.logging) ~= "boolean" then
      return false
    end
  end

  if user_config.log_level then
    if type(user_config.log_level) ~= "number" then
      return false
    end
  end

  if user_config.filetype then
    if type(user_config.filetype) ~= "table" then
      return false
    end

    for filetype, formatters in pairs(user_config.filetype) do
      if type(filetype) ~= "string" then
        return false
      end

      if type(formatters) == "table" then
        for _, formatter in ipairs(user_config) do
          if type(formatter) ~= "function" then
            return false
          end
        end
      elseif type(formatters) ~= "function" then
        return false
      end
    end
  end

  return true
end

function M.normalize_config(valid_config)
  local normalized = vim.tbl_deep_extend("force", {}, M.config.default_config)
  if not valid_config then
    return normalized
  end
  normalized = vim.tbl_deep_extend("force", normalized, valid_config)

  normalized.logging = normalized.logging or M.default_config.logging
  normalized.log_level = normalized.log_level or M.default_config.log_level
  normalized.filetype = normalized.filetype or M.default_config.filetype

  for key, filetype in pairs(normalized.filetype) do
    if type(filetype) == "function" then
      normalized.filetype[key] = { filetype }
    end
  end

  return normalized
end

function M.formatters_for_filetype(filetype)
  if type(filetype) ~= "string" then
    return { unpack(M.config.values.filetype["*"] or {}) }
  end

  return {
    unpack(M.config.values.filetype[filetype] or {}),
    unpack(M.config.values.filetype["*"] or {}),
  }
end

return M
