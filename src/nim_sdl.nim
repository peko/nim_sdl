## This example show how to have real time cairo using sdl2 backend

import sdl2, sdl2/gfx, math, random
import cairo


const
    pi = 3.1415926
    w:int32 = 1024
    h:int32 = 1024
    wf:float = float(w)
    hf:float = float(h)
var 
  surface = imageSurfaceCreate(FORMAT.FormatRgb24, w, h)
  frameCount = 0
  window: WindowPtr
  render: RendererPtr
  mainSerface: SurfacePtr
  mainTexture: TexturePtr
  evt = sdl2.defaultEvent


proc draw_bit(ctx: ptr Context, x, y, size: float, r = 1) =    
  ctx.setSourceRgb 0.0, 0.0, 0.0
  ctx.setLineWidth size/16.0

  case rand(r):

      of 0:
        ctx.newPath()
        ctx.arc x, y, size/2.0, 0.0, pi/2
        ctx.stroke()

        ctx.newPath()
        ctx.arc x+size, y+size, size/2.0, pi, -pi/2
        ctx.stroke()

      of 1:
        ctx.newPath()
        ctx.arc x+size, y, size/2.0, pi/2, pi
        ctx.stroke()

        ctx.newPath()
        ctx.arc x, y+size, size/2.0, -pi/2.0, 0.0
        ctx.stroke()

      of 2:
        ctx.newPath()
        ctx.moveTo x, y+size/2
        ctx.lineTo x+size, y+size/2
        ctx.stroke()
        
        ctx.newPath()
        ctx.moveTo x+size/2, y
        ctx.lineTo x+size/2, y+size
        ctx.stroke()

      else:
        discard

proc display() =
  ## Called every frame by main while loop

  # draw shiny sphere on gradient background
  var ctx = surface.create()

  # clear
  ctx.newPath()
  ctx.rectangle 0.0, 0.0, wf, hf
  ctx.setSourceRgb 1.0, 1.0, 1.0
  ctx.fill()

  let s = 64.0
  var
      x, y = 0.0
  while y<hf:
      while x<wf:
          ctx.draw_bit x, y, s, 2
          x+=s
      y+=s
      x=0.0

  # cairo surface -> sdl serface -> sdl texture -> copy to render
  var dataPtr = surface.getData()
  mainSerface.pixels = dataPtr
  mainTexture = render.createTextureFromSurface(mainSerface)
  render.copy(mainTexture, nil, nil)
  render.present()

discard sdl2.init(INIT_EVERYTHING)
window = createWindow("Real time SDL/Cairo example", 100, 100, cint w, cint h, SDL_WINDOW_SHOWN)
const
  rmask = uint32 0x00ff0000
  gmask = uint32 0x0000ff00
  bmask = uint32 0x000000ff
  amask = uint32 0xff000000
mainSerface = createRGBSurface(0, cint w, cint h, 32, rmask, gmask, bmask, amask)

render = createRenderer(window, -1, 0)

while true:
  while pollEvent(evt):
    if evt.kind == QuitEvent:
      quit(0)
  display()
  delay(1000)
