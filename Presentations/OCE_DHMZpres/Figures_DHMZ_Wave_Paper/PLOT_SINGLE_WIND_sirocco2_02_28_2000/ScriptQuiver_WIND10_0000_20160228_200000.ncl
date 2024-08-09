load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
begin
  ; 
  ; Loading fundamental data
  ; 
  f = addfile("DataQuiver_WIND10_0000_20160228_200000.nc", "r")
  lat2d  = f->lat
  lon2d  = f->lon
  eVarU  = f->u
  eVarV  = f->v
  speed  = f->F
  wks  = gsn_open_wks ("pdf","WIND10_0000_20160228_200000")
  vres1=True
  vres1@gsnDraw = False
  vres1@gsnFrame = False
  vres1@gsnPaperOrientation = "Landscape"
  vres1@gsnScalarContour     = True
  vres1@gsnSpreadColors      = True
  vres1@gsnSpreadColorEnd    = -3
  ;  vres1@gsnSpreadColorStart  = 1
  vres1@mpLandFillColor      = "grey"
  vres1@cnFillDrawOrder      = "PreDraw"
  vres1@cnFillOn             = True
  vres1@cnLinesOn            = False
  vres1@cnLineLabelsOn       = False
  vres1@cnLevelSelectionMode = "ManualLevels"
  vres1@cnMinLevelValF       = 0
  vres1@cnMaxLevelValF       = 22
  vres1@lbLabelStride        = 8
  vres1@cnLevelSpacingF      = 0.5
  ;
  ; The vertical label bar on the right
  ;
  vres1@lbOrientation        = "Vertical"     ; Vertical label bar
  vres1@pmLabelBarOrthogonalPosF = 0.025          ; move label bar closer
  vres1@pmLabelBarDisplayMode = "Always"          ; Turn on a label bar.
  vres1@lbPerimOn             = False             ; no box around it
  vres1@lbBoxLinesOn         = False               ; Yes/No labelbar box lines.
  vres1@lbTitleString    = "Wind speed [m/s]"
  vres1@lbTitleFont      = "Helvetica"
  vres1@lbTitleFontHeightF = 0.015
  vres1@lbTitleDirection     = "Across" 
  vres1@lbTitlePosition = "Right"
  vres1@lbTitleAngleF = 90
  vres1@mpProjection = "Mercator"
  vres1@mpLimitMode         = "Corners"             ; choose range of map
  vres1@mpLeftCornerLatF    = 40.29
  vres1@mpLeftCornerLonF    = 12.13
  vres1@mpRightCornerLatF   = 45.78
  vres1@mpRightCornerLonF   = 19.61
  vres1@mpFillOn      = True
  vres1@mpDataBaseVersion      = "HighRes"          ; use high resolution coast
  vres1@mpLandFillColor      = "LightGrey"
  vres1@mpLandFillColor       = "gray"            ; set land to be gray
  vres1@pmTickMarkDisplayMode  = "Always"           ; turn on tickmarks
  vres1@vcMonoLineArrowColor  = True             ; colored by their mag
  vres1@pmLabelBarWidthF = 0.03
  vres1@tiMainString    = "(a) 10m wind at 2016-02-28 20:00:00"
  vres1@tiMainFont      = "Helvetica"
  vres1@tiMainFontHeightF=0.025
  ; vres1@gsnRightString    = "Sea surface elevation"
  ; vres1@gsnLeftString     = "Difference"
  ;  vres1@vcRefMagnitudeF   = 10.
  vres1@vcGlyphStyle      = "CurlyVector"
  ;  vres1@vcGlyphStyle      = "LineArrow"
  vres1@vcMinDistanceF    = 0.014
  vres1@vcRefLengthF      = 0.02
  vres1@vcRefAnnoOn       = False
  vres1@vcLineArrowHeadMaxSizeF = 0.005
  ;  vres1@vcRefAnnoOrthogonalPosF = -0.8
  ;  vres1@vcRefAnnoParallelPosF = 1.0
  ;  vres1@vcRefMagnitudeF         = 10
  ;  vres1@vcRefAnnoString1 = "10 m/s"
  ;  gsn_define_colormap (wks,"testcmap")
  ;
  ; Specifying the colormap
  ;
  gsn_define_colormap (wks,"BlAqGrYeOrReVi200")
  ;  gsn_define_colormap(wks,"BlGrYeOrReVi200")
  ;  gsn_define_colormap(wks,"hotres")
  ;  gsn_define_colormap(wks,"rainbow")
  ;  gsn_define_colormap(wks,"ViBlGrWhYeOrRe")
  ;  gsn_define_colormap(wks,"BlWhRe")
  ;  gsn_define_colormap(wks,"GrayWhiteGray")
  ;  gsn_define_colormap(wks,"BlWhRe")
  i = NhlNewColor(wks,0.8,0.8,0.8)      ; add gray to colormap
  i = NhlNewColor(wks,0.9,0.9,0.9)      ; add gray to colormap
  eVarU@lat2d=lat2d
  eVarU@lon2d=lon2d
  eVarV@lat2d=lat2d
  eVarV@lon2d=lon2d
  speed@lat2d=lat2d
  speed@lon2d=lon2d
  plot = gsn_csm_vector_scalar_map(wks,eVarU,eVarV,speed,vres1)
  f2 = addfile("DataPcolor_Track_0001_10_SARAL_trivialarrayplot.nc", "r")
  LLS_ListLon = f2->LLS_ListLon
  LLS_ListLat = f2->LLS_ListLat
  LLS_ns = dimsizes(LLS_ListLon)
  nbLine=LLS_ns(0)/2
  resLine = True
  resLine@gsLineThicknessF = 3.0
  resLine@gsLineColor  = "dodgerblue1"
  resLine@tfPolyDrawOrder = "PostDraw"
  if (nbLine .gt. 0) then
    linesRect = new(nbLine,graphic)
    do iLine=0,nbLine-1
      xp=LLS_ListLon(2*iLine : 2*iLine+1)
      yp=LLS_ListLat(2*iLine : 2*iLine+1)
      linesRect(iLine)=gsn_add_polyline(wks,plot,xp,yp,resLine)
      delete(xp)
      delete(yp)
    end do
  end if
  draw(plot)
  frame(wks)
end
