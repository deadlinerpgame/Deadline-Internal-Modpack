local XN = {}
for a = 0, 15 do
	XN[a] = {}
	for b = 0, 15 do
		local r, x, y, p = 0, a, b, 1
		for _ = 1, 4 do
			local xa, xb = x % 2, y % 2
			if xa ~= xb then r = r + p end
			x = (x - xa) / 2
			y = (y - xb) / 2
			p = p * 2
		end
		XN[a][b] = r
	end
end

local function bxor32(a, b)
	local r, p = 0, 1
	for _ = 1, 8 do
		local na, nb = a % 16, b % 16
		r = r + XN[na][nb] * p
		a = (a - na) / 16
		b = (b - nb) / 16
		p = p * 16
	end
	return r
end

local function band32(a, b)
	return (a + b - bxor32(a, b)) / 2
end

local function bnot32(a)
	return 4294967295 - a
end

local function rrot(x, n)
	local m = 2 ^ n
	local lo = x % m
	return (x - lo) / m + lo * (4294967296 / m)
end

local function rshift(x, n)
	return math.floor(x / 2 ^ n)
end

local SHA_K = {
	1116352408, 1899447441, 3049323471, 3921009573, 961987163, 1508970993, 2453635748, 2870763221,
	3624381080, 310598401, 607225278, 1426881987, 1925078388, 2162078206, 2614888103, 3248222580,
	3835390401, 4022224774, 264347078, 604807628, 770255983, 1249150122, 1555081692, 1996064986,
	2554220882, 2821834349, 2952996808, 3210313671, 3336571891, 3584528711, 113926993, 338241895,
	666307205, 773529912, 1294757372, 1396182291, 1695183700, 1986661051, 2177026350, 2456956037,
	2730485921, 2820302411, 3259730800, 3345764771, 3516065817, 3600352804, 4094571909, 275423344,
	430227734, 506948616, 659060556, 883997877, 958139571, 1322822218, 1537002063, 1747873779,
	1955562222, 2024104815, 2227730452, 2361852424, 2428436474, 2756734187, 3204031479, 3329325298,
}

local SHA_H = {
	1779033703, 3144134277, 1013904242, 2773480762, 1359893119, 2600822924, 528734635, 1541459225,
}

local HEXCHARS = "0123456789abcdef"

local function toHex8(n)
	local out = ""
	for _ = 1, 8 do
		local d = n % 16
		out = string.sub(HEXCHARS, d + 1, d + 1) .. out
		n = (n - d) / 16
	end
	return out
end

local function sha256(msg)
	local bytes = {}
	local len = string.len(msg)
	for i = 1, len do
		bytes[i] = string.byte(msg, i) % 256
	end
	local bitLen = len * 8
	bytes[#bytes + 1] = 128
	while #bytes % 64 ~= 56 do
		bytes[#bytes + 1] = 0
	end
	local lenBytes = {}
	local bl = bitLen
	for i = 8, 1, -1 do
		lenBytes[i] = bl % 256
		bl = math.floor(bl / 256)
	end
	for i = 1, 8 do
		bytes[#bytes + 1] = lenBytes[i]
	end

	local H = {}
	for i = 1, 8 do
		H[i] = SHA_H[i]
	end

	for block = 0, #bytes - 1, 64 do
		local w = {}
		for i = 0, 15 do
			local o = block + i * 4
			w[i + 1] = bytes[o + 1] * 16777216 + bytes[o + 2] * 65536 + bytes[o + 3] * 256 + bytes[o + 4]
		end
		for i = 17, 64 do
			local x = w[i - 15]
			local s0 = bxor32(bxor32(rrot(x, 7), rrot(x, 18)), rshift(x, 3))
			local y = w[i - 2]
			local s1 = bxor32(bxor32(rrot(y, 17), rrot(y, 19)), rshift(y, 10))
			w[i] = (w[i - 16] + s0 + w[i - 7] + s1) % 4294967296
		end
		local a, b, c, d, e, f, g, h = H[1], H[2], H[3], H[4], H[5], H[6], H[7], H[8]
		for i = 1, 64 do
			local S1 = bxor32(bxor32(rrot(e, 6), rrot(e, 11)), rrot(e, 25))
			local ch = bxor32(band32(e, f), band32(bnot32(e), g))
			local t1 = (h + S1 + ch + SHA_K[i] + w[i]) % 4294967296
			local S0 = bxor32(bxor32(rrot(a, 2), rrot(a, 13)), rrot(a, 22))
			local maj = bxor32(bxor32(band32(a, b), band32(a, c)), band32(b, c))
			local t2 = (S0 + maj) % 4294967296
			h = g; g = f; f = e; e = (d + t1) % 4294967296
			d = c; c = b; b = a; a = (t1 + t2) % 4294967296
		end
		H[1] = (H[1] + a) % 4294967296
		H[2] = (H[2] + b) % 4294967296
		H[3] = (H[3] + c) % 4294967296
		H[4] = (H[4] + d) % 4294967296
		H[5] = (H[5] + e) % 4294967296
		H[6] = (H[6] + f) % 4294967296
		H[7] = (H[7] + g) % 4294967296
		H[8] = (H[8] + h) % 4294967296
	end

	local out = ""
	for i = 1, 8 do
		out = out .. toHex8(H[i])
	end
	return out
end

return sha256
