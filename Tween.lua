-- Credits to vozoid

--!strict

local heartbeat = game:GetService("RunService").Heartbeat

-- math
local sqrt, sin, pi, halfpi, tau = math.sqrt, math.sin, math.pi, math.pi / 2, math.pi * 2

-- constants
local s = 1.70158
local p = 0.3

local e = 1 / p

-- styles
local styles = {
    linear = function(delta) return delta end,
    sine = function(delta) return sin(halfpi * delta - halfpi) + 1 end,
    back = function(delta) return delta^2 * (delta * (s + 1) - s) end,
    quad =  function(delta) return delta^2 end,
    quart = function(delta) return delta^4 end,
    quint = function(delta) return delta^5 end,
    elastic = function(delta)  return -2^(10 * (delta - 1)) * sin(tau * (delta - 1 - p * 0.25) * e) end,
    exponential = function(delta) return 2^(10 * delta - 10) - 0.001 end,
    circular = function(delta) return -sqrt(1 - delta^2) + 1 end,
    cubic = function(delta) return delta^3 end
}

local tween = {}
tween.__index = tween

function tween:create(object: any, info: { [string | number] : string }?, properties: { [string]: any }): tween
    return setmetatable({
        object = object,

        time = info.time or info[1],
        style = info.style or info[2] or "quad",
        direction = info.direction or info[3] or "out",

        properties = properties,

        elapsed = 0,
        starts = {},
    }, self)
end

export type tween = typeof(tween:create({}, {}, {}))

function tween:play(_REVERSE: boolean?): ()
    if _REVERSE then
        self.reversed = true
    else
        for property, value in self.properties do
            self.starts[property] = self.object[property]
        end
    end

    coroutine.wrap(function()
        while (if _REVERSE then self.elapsed >= 0 else self.elapsed <= self.time) and not self.cancelled and (if _REVERSE then true else not self.reversed) do
            if self.paused then heartbeat:Wait() continue end
            self.elapsed += if _REVERSE then -heartbeat:Wait() else heartbeat:Wait()

            self.delta = self.elapsed / self.time

            -- "in" to "in_out" and "out" conversion
            local alpha
            if self.direction == "in" then
                alpha = styles[self.style](self.delta)
            elseif self.direction == "in_out" then
                if self.delta <= 0.5 then
                    alpha = 0.5 * styles[self.style](2 * self.delta)
                else
                    alpha = 0.5 * (1 - styles[self.style](-2 * self.delta + 2)) + 0.5
                end
            else
                alpha = 1 - styles[self.style](-self.delta + 1)
            end

            for property: string, value: any in self.properties do
                if typeof(value) == "number" then
                    self.object[property] = self.starts[property] + ((value - self.starts[property]) * alpha)
                else 
                    self.object[property] = self.starts[property]:lerp(value, alpha)
                end
            end
        end

        if not self.cancelled and (if _REVERSE then true else not self.reversed) then
            for property: string, value: any in self.properties do
                self.object[property] = if _REVERSE then self.starts[property] else value
            end
        end

        if self.callback and not self.cancelled and not self.reversed then
            self.callback()
        end
    end)()
end

function tween:reverse(): ()
    self:play(true)
end

function tween:pause(): ()
    self.paused = true
end

function tween:resume(): ()
    self.paused = false
end

function tween:cancel(): ()
    self.cancelled = true
end

function tween:wait(): ()
    repeat heartbeat:Wait() until self.elapsed >= self.time
end

return tween
