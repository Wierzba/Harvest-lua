require("iuplua")
require("iupluagl")
require("luagl")
require("luaglu")
require("imlua")

package.path = package.path .. ";?.lua"
require "harvest"

iup.key_open()

light = false             -- Lighting ON / OFF
lp = false                -- L Pressed?
fp = false                -- F Pressed?

xrot = 0                  -- X Rotation
yrot = 0                  -- Y Rotation
xspeed = 0                -- X Rotation Speed
yspeed = 0                -- Y Rotation Speed
z = -5                    -- Depth Into The Screen

LightAmbient = {0.5, 0.5, 0.5, 1}    -- Ambient Light Values ( NEW )
LightDiffuse = {1, 1, 1, 1}          -- Diffuse Light Values ( NEW )
LightPosition = {0, 0, 2, 1}         -- Light Position ( NEW )

filter = 1                           -- Which Filter To Use
texture = 0                          -- Storage for the textures

cnv = iup.glcanvas{buffer="DOUBLE", rastersize = "800x600"}

timer = iup.timer{time=10}

function timer:action_cb()
    iup.Update(cnv)
end

function cnv:resize_cb(width, height)
    iup.GLMakeCurrent(self)
    gl.Viewport(0, 0, width, height)

    gl.MatrixMode('PROJECTION')   -- Select The Projection Matrix
    gl.LoadIdentity()             -- Reset The Projection Matrix

    if height == 0 then           -- Calculate The Aspect Ratio Of The Window
        height = 1
    end

    --glu.Perspective(80, width / height, 1, 5000)
    gl.Ortho(0, width, height, 0, -1, 1)

    gl.MatrixMode('MODELVIEW')    -- Select The Model View Matrix
    gl.LoadIdentity()             -- Reset The Model View Matrix
end

function cnv:action(x, y)
  iup.GLMakeCurrent(self)
  gl.ClearColor(30/255,30/255,30/255,1)
  gl.Clear('COLOR_BUFFER_BIT,DEPTH_BUFFER_BIT') -- Clear Screen And Depth Buffer

  gl.LoadIdentity()              -- Reset The Current Modelview Matrix

  -- harvest draw function
  update()
  draw()

  iup.GLSwapBuffers(self)
end

function cnv:button_cb(but, pressed, x, y, status)
    mouse_callback(but, pressed, x, y, status)
end

function cnv:k_any(c)
  if c == iup.K_q or c == iup.K_ESC then
    return iup.CLOSE

  end

  if c == iup.K_F1 then
    if fullscreen then
      fullscreen = false
      dlg.fullscreen = "No"
    else
      fullscreen = true
      dlg.fullscreen = "Yes"
    end
    iup.SetFocus(cnv)
  end

  keyboard_callback(c)
end

--[[function LoadTexture(fileName)
  local image = im.FileImageLoadBitmap(fileName)
  if (not image) then
    print ("Unnable to open the file: " .. fileName)
    os.exit()
  end

  gl.PixelStore(gl.UNPACK_ALIGNMENT, 1)

  return image
end]]

--[[function LoadGLTextures()
  texture = gl.GenTextures(3)   -- Create The Textures

  -- Create Nearest Filtered Texture
  gl.BindTexture('TEXTURE_2D', texture[1])
  gl.TexParameter('TEXTURE_2D','TEXTURE_MIN_FILTER','NEAREST')
  gl.TexParameter('TEXTURE_2D','TEXTURE_MAG_FILTER','NEAREST')

  crate = LoadTexture('crate.tga')
  local gldata, glformat = crate:GetOpenGLData()

  gl.TexImage2D(0, crate:Depth(), crate:Width(), crate:Height(), 0, glformat, gl.UNSIGNED_BYTE, gldata)

  -- Create Linear Filtered Texture
  gl.BindTexture('TEXTURE_2D', texture[2])
  gl.TexParameter('TEXTURE_2D','TEXTURE_MIN_FILTER','LINEAR')
  gl.TexParameter('TEXTURE_2D','TEXTURE_MAG_FILTER','LINEAR')

  gl.TexImage2D(0, crate:Depth(), crate:Width(), crate:Height(), 0, glformat, gl.UNSIGNED_BYTE, gldata)

  -- Create MipMapped Texture
  gl.BindTexture('TEXTURE_2D', texture[3])
  gl.TexParameter('TEXTURE_2D','TEXTURE_MIN_FILTER','LINEAR_MIPMAP_NEAREST')
  gl.TexParameter('TEXTURE_2D','TEXTURE_MAG_FILTER','LINEAR')

  glu.Build2DMipmaps(crate:Depth(), crate:Width(), crate:Height(), glformat, gl.UNSIGNED_BYTE, gldata)

  -- gldata will be destroyed when the image object is destroyed
  crate:Destroy()
end]]

function cnv:map_cb()
  iup.GLMakeCurrent(self)
  gl.Enable('TEXTURE_2D')            -- Enable Texture Mapping ( NEW )

  --LoadGLTextures()

  gl.ShadeModel('SMOOTH')            -- Enable Smooth Shading
  gl.ClearColor(0, 0, 0, 0.5)        -- Black Background
  gl.ClearDepth(1.0)                 -- Depth Buffer Setup
  gl.Enable('DEPTH_TEST')            -- Enables Depth Testing
  gl.DepthFunc('LEQUAL')             -- The Type Of Depth Testing To Do
  gl.Hint('PERSPECTIVE_CORRECTION_HINT','NICEST')

  gl.Light('LIGHT1', 'AMBIENT', LightAmbient)        -- Setup The Ambient Light
  gl.Light('LIGHT1', 'DIFFUSE', LightDiffuse)        -- Setup The Diffuse Light
  gl.Light('LIGHT1', 'POSITION', LightPosition)      -- Position The Light

  gl.Enable('LIGHT1')

end

dlg = iup.dialog{cnv; title="LuaGL Test Application 07"}

dlg:show()
cnv.rastersize = nil -- reset minimum limitation
timer.run = "YES"

function kvprint(x)
    for k,v in pairs(x) do
        print(k,v)
    end
end

function start()
    if (not iup.MainLoopLevel or iup.MainLoopLevel()==0) then
          iup.MainLoop()
    end
end
start()
