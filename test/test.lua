
for i = 0, 1, 2 do -- dangling Begin ForNumericStatement
end -- Dangling End ForNumericStatement

-- leading ForNumericStatement
for i = 0, 1, 2 do -- dangling Begin ForNumericStatement
end -- Dangling End ForNumericStatement
-- trailing ForNumericStatement

-- leading ForNumericStatement
for i = 0, 1, 2 do -- dangling Begin ForNumericStatement
--body ForNumericStatement
end -- Dangling End ForNumericStatement
-- trailing ForNumericStatement

for i in pairs(v) do -- dangling Begin ForNumericStatement
end -- Dangling End ForNumericStatement

-- leading ForNumericStatement
for i in pairs(v) do -- dangling Begin ForNumericStatement
end -- Dangling End ForNumericStatement
-- trailing ForNumericStatement

-- leading ForNumericStatement
for i in pairs(v) do -- dangling Begin ForNumericStatement
--body ForNumericStatement
end -- Dangling End ForNumericStatement
-- trailing ForNumericStatement
