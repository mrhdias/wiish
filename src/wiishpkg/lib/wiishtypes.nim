import sdl2
import opengl
import ../events
import ../defs

type
  Rect* = tuple[x, y, width, height: float32]
  BaseApp = ref object of RootRef
    launched*: EventSource[bool]
    willExit*: EventSource[bool]
  
  BaseWindow = ref object of RootRef
    # events
    onDraw*: EventSource[Rect]

    # attributes/properties
    frame*: Rect

proc newRect*(x, y, width, height: float32 = 0):Rect =
  result = (x, y, width, height)

template newRect*(x, y, width, height: int32 = 0):Rect =
  newRect(x.toFloat, y.toFloat, width.toFloat, height.toFloat)

type
  App* = ref object of BaseApp
    windows*: seq[Window]
  Window* = ref object of BaseWindow
    sdlWindow*: sdl2.WindowPtr
    sdlGlContext*: sdl2.GlContextPtr
# when macDesktop:
#   type
#     Id* {.importc: "id", header: "<AppKit/AppKit.h>", final .} = distinct int
#   type
#     App* = ref object of BaseApp
#     Window* = ref object of BaseWindow
#       nativeWindowPtr*: pointer # WiishWindow
#       nativeViewPtr*: pointer # WiishView
# else:
#   import glfw
#   type
#     App* = ref object of BaseApp
#     Window* = ref object of BaseWindow
#       glfwWindow*: glfw.Window


## The singleton application instance.
var app* = App()
app.launched = newEventSource[bool]()
app.willExit = newEventSource[bool]()