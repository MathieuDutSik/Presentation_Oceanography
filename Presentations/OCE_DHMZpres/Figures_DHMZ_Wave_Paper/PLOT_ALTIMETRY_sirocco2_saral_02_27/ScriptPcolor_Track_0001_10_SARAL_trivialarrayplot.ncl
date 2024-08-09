load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
begin
  ;
  ; Data reading
  ;
  f = addfile("DataPcolor_Track_0001_10_SARAL_trivialarrayplot.nc", "r")
  lat  = f->lat
  lon  = f->lon
  eVarF  = f->field
  wks  = gsn_open_wks ("pdf","Track_SARAL_at0001")
  res2 = True               ; plot mods desired
  res2@gsnDraw   = False
  res2@gsnFrame  = False
  res2@gsnMaximize     = True    ; Maximize plot in frame
  res2@gsnPaperOrientation = "Landscape"
  ;
  ; General frame information
  ;
  res2@mpProjection = "Mercator"
  res2@mpLimitMode         = "Corners"             ; choose range of map
  res2@mpLeftCornerLatF    = 39
  res2@mpLeftCornerLonF    = 12
  res2@mpRightCornerLatF   = 46
  res2@mpRightCornerLonF   = 21
  res2@mpFillOn      = True
  res2@mpDataBaseVersion      = "HighRes"          ; use high resolution coast
  res2@mpLandFillColor      = "LightGrey"
  res2@mpLandFillColor       = "gray"            ; set land to be gray
  res2@pmTickMarkDisplayMode  = "Always"           ; turn on tickmarks
  ;
  ; Contour map information
  ;
  res2@cnFillDrawOrder        = "PreDraw"
  res2@cnFillOn             = True               ; turn on color for contours
  res2@cnLinesOn            = False              ; turn off contour lines
  res2@cnLineLabelsOn       = False              ; turn off contour line labels
  res2@cnFillMode           = "RasterFill"
            ; AreaFill : slow and buggy but maybe more beautiful
            ; RasterFill : fast and efficient
            ; CellFill : similar to RasterFill but only for finite difference
  ;  res2@cnRasterSmoothingOn  = True
  res2@cnSmoothingOn = True
  ;  res2@cnSmoothingDistanceF  = 0.05
  res2@cnSmoothingTensionF  = -1
  res2@cnLevelSelectionMode = "ManualLevels"     ; set manual contour levels
  res2@cnMinLevelValF       = 2  ; set min contour level
  res2@cnMaxLevelValF       = 3  ; set max contour level
  res2@cnLevelSpacingF      = 0.05     ; set contour spacing
  res2@lbLabelStride            = 10
  ;  res2@gsnScalarContour     = False               ; contours desired
  res2@tiMainString    = "Tracks 0001 for SARAL from 2016-02-27 17:40:57 to 2016-02-27 17:41:15"
  res2@tiMainFont      = "Helvetica"
  res2@tiMainFontHeightF = 0.015
  ;  res2@cnTitlePosition  = "Top"
  res2@gsnSpreadColors      = True               ; use full color map
  res2@gsnSpreadColorEnd     = -3
  ;
  ; Label bar plotting
  ;
  res2@lbLabelBarOn = False
  res2@lbTitleString    = "Track [nondim.]"
  res2@lbTitleFont      = "Helvetica"
  res2@lbTitleFontHeightF = 0.015
  res2@lbTitleDirection     = "Across"
  res2@lbTitlePosition = "Right"
  res2@lbTitleAngleF = 90
  res2@lbOrientation        = "Vertical"     ; Vertical label bar
  res2@pmLabelBarOrthogonalPosF = 0.025          ; move label bar closer
  ;  res2@lbHeightF               = 0.7          ; move label bar closer
  res2@pmLabelBarDisplayMode = "Always"          ; Turn on a label bar.
  res2@lbPerimOn             = False             ; no box around it
  res2@lbBoxLinesOn         = False               ; Yes/No labelbar box lines
  res2@pmLabelBarWidthF = 0.03
  ; res2@gsnRightString  = "Sea surface elevation"
  ; res2@gsnLeftString    = "Difference"
  ;
  ; Colormap assignation
  ;
  gsn_define_colormap (wks,"WhBlGrYeRe")
  ;     other possibilities: hotres, rainbow, ViBlGrWhYeOrRe, BlWhRe, GrayWhiteGray, BlGrYeOrReVi200
  i = NhlNewColor(wks,0.8,0.8,0.8)      ; add gray to colormap
  i = NhlNewColor(wks,0.9,0.9,0.9)      ; add gray to colormap
  ;
  ; Pcolor kind of plot
  ;
  eVarF@lat2d=lat
  eVarF@lon2d=lon
  plot = gsn_csm_contour_map(wks,eVarF,res2)
  LLS_ListLon = f->LLS_ListLon
  LLS_ListLat = f->LLS_ListLat
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
