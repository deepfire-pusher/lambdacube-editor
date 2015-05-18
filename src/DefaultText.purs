module DefaultText where

defaultSrc = """
renderWire fb = let
  modelViewProj = Uni (IM44F "MVP2")
  blendFun x = Blend x ((SrcAlpha,OneMinusSrcAlpha),(SrcAlpha,OneMinusSrcAlpha)) (V4F 1.0 1.0 1.0 1.0)
  blend'' = blendFun (FuncAdd,FuncAdd)
  blend = Blend (FuncSubtract,FuncAdd) ((SrcColor,SrcColor),(SrcColor,OneMinusSrcAlpha)) (V4F 0.0 1.0 0.0 0.0)
  blend' = NoBlending
  polyMode          = PolygonLine 20.0
  polyMode'         = PolygonFill
  polyMode''        = PolygonPoint (PointSize 10.0)
  cull = CullNone
  cull' = CullFront CW
  rasterCtx         = TriangleCtx cull polyMode NoOffset FirstVertex
  fragmentCtx       = AccumulationContext (DepthOp Always False, ColorOp blend' (V4B True True False False))
  vertexShader v    = let v2 = PrimV3FToV4F v in VertexOut (PrimMulMatVec modelViewProj v2) 1.0 () ()
  vertexStream      = Fetch "stream" Triangles (IV3F "position")
  primitiveStream   = Transform vertexShader vertexStream
  fragmentStream    = Rasterize rasterCtx primitiveStream
  fragmentShader' v = FragmentOutRastDepth (V4F 1.0 0.4 0.0 0.2)
  fragmentShader v  = FragmentOutRastDepth (V4F 0.0 0.4 0.0 1.0)
  frame             = Accumulate fragmentCtx PassAll fragmentShader fragmentStream fb
  in frame

render fb = let
  modelViewProj = Uni (IM44F "MVP2")
  blendFun x = Blend x ((SrcAlpha,OneMinusSrcAlpha),(SrcAlpha,OneMinusSrcAlpha)) (V4F 1.0 1.0 1.0 1.0)
  blend'' = blendFun (FuncAdd,FuncAdd)
  blend = Blend (Max,FuncAdd) ((SrcColor,SrcColor),(SrcColor,OneMinusSrcAlpha)) (V4F 0.0 1.0 0.0 0.0)
  blend' = NoBlending
  polyMode          = PolygonLine 20.0
  polyMode'         = PolygonFill
  polyMode''        = PolygonPoint (PointSize 10.0)
  cull = CullNone
  cull' = CullFront CW
  rasterCtx         = TriangleCtx cull polyMode' NoOffset FirstVertex
  fragmentCtx       = AccumulationContext (DepthOp Less False, ColorOp blend' (V4B True True False False))
  vertexShader v    = let v2 = PrimV3FToV4F v in VertexOut (PrimMulMatVec modelViewProj v2) 1.0 () (Smooth v2)
  vertexStream      = Fetch "stream" Triangles (IV3F "position")
  primitiveStream   = Transform vertexShader vertexStream
  fragmentStream    = Rasterize rasterCtx primitiveStream
  fragmentShader' v = FragmentOutRastDepth (V4F 1.0 0.4 0.0 0.2)
  fragmentShader v  = FragmentOutRastDepth (PrimAdd v (V4F 1.0 1.4 1.0 0.6))
  frame             = Accumulate fragmentCtx PassAll fragmentShader fragmentStream fb
  in frame

render' fb = let
  modelViewProj = Uni (IM44F "MVP")
  blendFun x = Blend x ((SrcAlpha,OneMinusSrcAlpha),(SrcAlpha,OneMinusSrcAlpha)) (V4F 1.0 1.0 1.0 1.0)
  blend'' = blendFun (FuncAdd,FuncAdd)
  blend = Blend (FuncAdd,FuncAdd) ((SrcAlpha,OneMinusSrcAlpha),(SrcAlpha,OneMinusSrcAlpha)) (V4F 1.0 1.0 1.0 1.0)
  blend' = NoBlending
  polyMode          = PolygonLine 20.0
  polyMode'         = PolygonFill
  polyMode''        = PolygonPoint (PointSize 10.0)
  cull = CullNone
  cull' = CullFront CW
  rasterCtx         = TriangleCtx cull polyMode' NoOffset LastVertex
  fragmentCtx       = AccumulationContext (DepthOp Less False, ColorOp blend (V4B True True True True))
  vertexShader' v    = let v2 = PrimV3FToV4F v in VertexOut (PrimMulMatVec modelViewProj v2) 1.0 () (Flat v2)
  vertexShader v    = VertexOut (PrimMulMatVec modelViewProj v) 1.0 () (Flat v)
  vertexStream      = Fetch "stream4" Triangles (IV4F "position4")
  primitiveStream   = Transform vertexShader vertexStream
  fragmentStream    = Rasterize rasterCtx primitiveStream
  fragmentShader' v = FragmentOutRastDepth (V4F 1.0 0.4 0.0 0.2)
  fragmentShader v  = FragmentOutRastDepth (PrimMul v (V4F 1.0 1.4 1.0 0.6))
  frame             = Accumulate fragmentCtx PassAll fragmentShader fragmentStream fb
  in frame

main = let
  bgColor = V4F 0.5 0.0 0.4 1.0
  bgColor' = V4F 0.2 0.2 0.4 1.0
  emptyFB = FrameBuffer (depthImage1 1000.0,colorImage1 bgColor)
  modelViewProj = Uni (IM44F "MVP")
  --fx a = render modelViewProj a
  --out = fx (fx emptyFB)
  --out = fx emptyFB
  --out = render modelViewProj emptyFB
  out = renderWire (render (render' emptyFB))
  in ScreenOut out
"""
