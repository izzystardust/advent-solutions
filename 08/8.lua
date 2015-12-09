total = 0
memory = 0
newencode = 0

function memoryLen(str)
	if #str == 0 then
		return 0
	end
	local first = str:sub(1,1)
	if first ~= "\\" then
		return 1 + memoryLen(str:sub(2))
	else
		return backslash(str:sub(2))
	end
end

function backslash(str)
	local first = str:sub(1,1)
	if first == "\\" or first == "\"" then
		return 1 + memoryLen(str:sub(2))
	elseif first == "x" then
		return 1 + memoryLen(str:sub(4))
	else
		print("Wat.\n")
	end
end

function encodedLen(str)
	return #str:gsub("[\"\\]", "\\%1") + 2
end

for line in io.lines() do
	total = total + #line
	memory = memory + memoryLen(line:sub(2, #line-1))
	newencode = newencode + encodedLen(line)
end

print("Part 1: " .. total-memory)
print("Part 2: " .. newencode-total)
