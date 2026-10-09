pico-8 cartridge // http://www.pico-8.com
version 43
__lua__
-- master functions

function _init()
	player_start()
	obstacle_init()
end

function _update()
	if not rn.game_over then 
		player_update()
		obstacle_update()
	end
	ui_update()
end

function _draw()
	cls(0)
	
	line(0, 120, 128, 120, 7)
	
	player_draw()
	obstacle_draw()
	ui_draw()
end
-->8
-- player functions

function player_start()
	rn = {
		x = 63,
		y = 100,
		v = 0,
		jump_force = -4,
		gravity = 0.3,
		grounded = false,
		speed = 2,
		score = 0,
		game_over = false,
 }
 cur_spr = 2
 str_spr = 1
 end_spr = 2
end

function player_update()

	if not rn.grounded then
  rn.v += rn.gravity
 else
  rn.v = 0
 end
 
 if btnp(4) and rn.grounded then
  rn.v = rn.jump_force
  rn.grounded = false
 end
 
 rn.y += rn.v
 
 if rn.y >= 112 then
  rn.y = 112
  rn.grounded = true
 end
 
	cur_spr += 0.3
            	
	if cur_spr >= end_spr + 1 then
		cur_spr = str_spr
	end
 
end

function player_draw()

	spr(cur_spr, 16, rn.y)
end
-->8
-- obstacles

function obstacle_init()
	obstacles = {}
	spawn_timer = 30
end

function spawn_obstacle()

	add(obstacles, {
		x = 128,
		spr = 3 + flr(rnd(3))
	})
	
end

function obstacle_update()

	spawn_timer -= 1
	
	if spawn_timer <= 0 then
		spawn_obstacle()
		spawn_timer = 35 + flr(rnd(35))
	end
	
	for o in all(obstacles) do
		o.x -= rn.speed
		if o.x < -10 then
			del(obstacles, o)
			rn.score += 1
		end
	end
	
	for o in all(obstacles) do
		if collide(player_box(), obstacle_box(o)) then
			rn.game_over = true
		end 
	end
	
rn.speed = 2 + rn.score / 8
 	 	
end

function obstacle_draw()

	for o in all(obstacles) do
		spr(o.spr, o.x, 120 - 8)
	end
	
end
-->8
--game over and score ui
 
function ui_update()

	if rn.game_over then
	
		if btnp(5) then
			player_start()
		 obstacle_init()
		end
	end
	
end

function ui_draw()
	print("score "..rn.score, 2, 2, 7)
	
	if rn.game_over then
		print("game over", 44, 56, 7)
		print("x to restart", 38,
		 64, 12)
	end
end


-->8
--collisions

function player_box()
	return {
		x1 = 16, y1 = rn.y,
		x2 = 16 + 8, y2 = rn.y + 8
	}
end

function obstacle_box(o)
	return {
		x1 = o.x, y1 = 120 - 8,
		x2 = o.x + 8, y2 = 120
	}
end

function collide(a, b)
	return a.x2 > b.x1 and a.x1 < b.x2
				and a.y2 > b.y1 and a.y1 < b.y2
	
end
__gfx__
000000000000000000000000000c0000000770000007c00000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000006776000067760000077000077c77000007700000000000000000000000000000000000000000000000000000000000000000000000000000000000
007007000077770000777700007770000c777770000c700000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000007c7c00007c7c0000c7c700077cc7770007770000000000000000000000000000000000000000000000000000000000000000000000000000000000
0007700000677700006777000777c70007c677770007777000000000000000000000000000000000000000000000000000000000000000000000000000000000
007007000077760000777600077777700776667700777c7700000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000767700007677007cc77c777777767c0c77c77700000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000600700000600707c777cc7c777777cc777777c00000000000000000000000000000000000000000000000000000000000000000000000000000000
