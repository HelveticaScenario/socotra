-- Socotra
-- The tree sequencer

local easing = include('lib/easing')

local SCREEN_FRAMERATE = 15

local position = {63, 31}
local size = 5

local vector = {(math.random() * 4) - 2,(math.random() * 4) - 2}

function round(n)
  return math.floor(n + 0.5)
end

function out_of_bounds(p)
  local modifier = {1, 1}

  if (p[1] - size) < 0 or (p[1] + size) > 127 then
    modifier[1] = -1
  end

  if (p[2] - size) < 0 or (p[2] + size) > 63 then
    modifier[2] = -1
  end

  return modifier
end

function in_out_quad_blend(t)
    if (t <= 0.5) then
        return 2.0 * t * t;
    end
    t = t - 0.5;
    return 2.0 * t * (1.0 - t) + 0.5;
end

function bezier_blend(t)
    return t * t * (3.0 - 2.0 * t);
end

function v_add(v1, v2)
  return { v1[1] + v2[1], v1[2] + v2[2] }
end

function v_mul(v1, v2)
  return { v1[1] * v2[1], v1[2] * v2[2] }
end

function v_diff(v1, v2)
  return v1[1] ~= v2[1] or v1[2] ~= v2[2]
end

function key(n,z)
  -- key actions: n = number, z = state
end

function enc(n, d)
  -- encoder actions: n = number, d = delta
end

function update()
  local new_position = v_add(position, vector)
  local new_vector = v_mul(vector, out_of_bounds(new_position))
  if v_diff(position, new_position) or v_diff(vector, new_vector) then
    position = new_position
    vector = new_vector
    screen_dirty = true
  end
end

function redraw()
  screen.clear()
  screen.aa(1)
  screen.stroke()
  screen.circle(position[1], position[2], size)
  screen.stroke()

  screen.update()
end


function init()
  local screen_refresh_metro = metro.init()
  screen_refresh_metro.event = function()
    update()
    if screen_dirty then
      redraw()
      screen_dirty = false
    end
  end
  screen_refresh_metro:start(1 / SCREEN_FRAMERATE)
end


function cleanup()
  -- deinitialization
end