local sens = 10.5

local touch = nil
local pivot_x = nil
local camera = nil
local camera_component = nil
local laser = nil

function start()
  laser = Laser:new()
  touch = Input:getAxisValue("touch")
  pivot_x = myObject:findChildObject("pivot-x")
  camera = pivot_x:findChildObject("camera")
  camera_component = camera:findComponent("Camera")
end

function get_vertices_from_triangle(triangle, vertices)
  local v = luajava.newInstance("java.util.ArrayList")

  v:add(vertices:get(triangle:getX()))
  v:add(vertices:get(triangle:getY()))
  v:add(vertices:get(triangle:getZ()))

  return v
end

function vertices_is_equals(other, vertices, triangles)
  for i=0, triangles:size() -1, 1 do
    local v = get_vertices_from_triangle(triangles:get(i), vertices)
    
    local e = true
    for s=0, 2, 1 do
      if v:get(s) ~= other:get(s) then
        e = false
      end
    end

    if e then
      return i
    end
  end
end

function update()
  if Input:getTouch(0):isDown() then
    local hit = laser:trace(camera:getGlobalPosition(), 
      camera_component:screenPointNormal(Input:getTouchPosition(0)),
      100.5)

    if hit ~= nil then
      local object = hit:getObject()
      local object_vertex = object:findComponent("ModelRenderer"):getVertex()
      local object_vertices = object_vertex:getVertices()
      local object_triangles = object_vertex:getTriangles()
      local collider_vertices = hit:getCollider():getVertex():getVertices()

      Console:log(vertices_is_equals(collider_vertices, object_vertices, object_triangles))
    end
  end

  myTransform:rotateInSeconds(0, -touch:getX() * sens, 0)
  pivot_x:rotateInSeconds(touch:getY() * sens, 0, 0)
end
