local M = {}

function M:peek(job)
	local cache = ya.file_cache(job)
	if not cache then
		return
	end

	if not self:preload(job) then
		return
	end

	-- local t = io.open(tostring(cache), "r")
	-- if t == nil then
	-- 	return 0
	-- end
	--
	-- local thumb = Url(t:read())
	-- t:close()

	ya.image_show(cache, job.area)
	ya.preview_widgets(job, {})
end

function M:seek() end

M.dump = function(t)
	local conv = {
		["nil"] = function() return "nil" end,
		["number"] = function(n) return tostring(n) end,
		["string"] = function(s) return '"' .. s .. '"' end,
		["boolean"] = function(b) return tostring(b) end,
		["function"] = function(_) return "function()" end,
	}
	if type(t) == "table" then
		local s = "{"
		for k, v in pairs(t) do
			if type(v) == "table" then
				s = s .. (s == "{" and " " or ", ") .. (k .. " = " .. M.dump(v))
			else
				s = s .. (s == "{" and " " or ", ") .. k .. " = " .. conv[type(v)](v)
			end
		end
		return s .. " }"
	else
		return conv[type(t)](t)
	end
end


function M:preload(job)
	local height
	local width

	local ostype = Command("uname")
		:args({ "-o" })
		:stdout(Command.PIPED)
		:stderr(Command.PIPED)
		:output()

	if not ostype then
		return 0
	elseif not ostype.status.success then
		return 0
	end

	if string.find(ostype.stdout, "Darwin") then
		local output = Command("exiftool")
			:args({ "-ImageSize", tostring(job.file.url) })
			:stdout(Command.PIPED)
			:stderr(Command.PIPED)
			:output()

		if not output then
			return 0
		elseif not output.status.success then
			return 0
		end
		ya.dbg("exiftool: " .. tostring(output.stdout))
		-- Image Size                      : 640x480
		_, _, width, height = string.find(output.stdout, ".* (%d+)x(%d+).*")
	elseif string.find(ostype.stdout, "Linux") then
		local output = Command("identify")
			:args({ tostring(job.file.url) })
			:stdout(Command.PIPED)
			:stderr(Command.PIPED)
			:output()

		if not output then
			return 0
		elseif not output.status.success then
			return 0
		end
		ya.dbg("identify: " .. tostring(output.stdout))
		-- network-labnet.svg SVG 640x480 640x480+0+0 16-bit sRGB 21094B 0.010u 0:00.005
		_, _, width, height = string.find(output.stdout, ".* (%d+)x(%d+) .*")
	else
		return 0
	end

	local cache = ya.file_cache(job)
	if not cache or fs.cha(cache) then
		return 1
	end

	local max_width = (width / height) >= (PREVIEW.max_width / PREVIEW.max_height)

	local args = {
		"-f", "png", "-a",
		max_width and "--width" or "--height",
		max_width and tostring(PREVIEW.max_width) or tostring(PREVIEW.max_height),
		tostring(job.file.url),
	}
	local child, code = Command("rsvg-convert"):args(args):stdout(Command.PIPED):spawn()

	if not child then
		ya.err("spawn `rsvg-convert` command returns " .. tostring(code))
		return 0
	end

	local child_output, err = child:wait_with_output()
	if err then
		ya.err("rsvg-convert returned an error" .. tostring(err))
		return 0
	end

	local thumb = child_output.stdout
	ya.dbg("length: " .. string.len(thumb))
	return fs.write(cache, thumb) and 1 or 2
	-- return status and status.success and 1 or 2
end

return M
