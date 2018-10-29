import opengl
import ./events
import ./context

type
  Rect* = tuple[x, y, width, height: float32]
  BaseApp = ref object of RootRef
    launched*: EventSource[bool]
    willExit*: EventSource[bool]
  
  BaseWindow = ref object of RootRef
    # events
    willExit*: EventSource[bool]
    onDraw*: EventSource[Rect]

    # attributes/properties
    context*: GLContext
    frame*: Rect

proc newRect*(x, y, width, height: float32 = 0):Rect =
  result = (x, y, width, height)

template newRect*(x, y, width, height: int32 = 0):Rect =
  newRect(x.toFloat, y.toFloat, width.toFloat, height.toFloat)

when defined(macosx) and not defined(ios):
  type
    Id* {.importc: "id", header: "<AppKit/AppKit.h>", final .} = distinct int
  type
    App* = ref object of BaseApp
    Window* = ref object of BaseWindow
      nativeWindowPtr*: pointer # WiishWindow
      nativeViewPtr*: pointer # WiishView
else:
  import glfw
  type
    App* = ref object of BaseApp
    Window* = ref object of BaseWindow
      glfwWindow*: glfw.Window
      