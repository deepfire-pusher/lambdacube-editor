module DefaultText where

defaultSrc = """
clear = FrameBuffer $ (DepthImage @1 1000, ColorImage @1 navy)   -- ...

triangleRasterCtx = TriangleCtx CullNone PolygonFill NoOffset LastVertex
colorFragmentCtx = AccumulationContext (DepthOp Less True, ColorOp NoBlending (V4 True True True True))

rasterizeWith = Rasterize
triangles = triangleRasterCtx

cubeVertexStream = Fetch "stream4" Triangles (Attribute "position4" :: Vec 4 Float)
mapFragments s fs = Accumulate colorFragmentCtx PassAll (\a -> FragmentOutRastDepth $ fs a) s clear
transform s f =  Transform (\v -> VertexOut (f v) 1 () (Smooth v)) s

rotate' v = (Uniform "MVP" :: Mat 4 4 Float) *. v

main =             cubeVertexStream         -- cube vertices
    `transform`    (scale 0.5 . rotate')    -- scale them
     &             rasterizeWith triangles  -- rasterize
    `mapFragments` id
     &             ScreenOut                --  draw into screen
"""