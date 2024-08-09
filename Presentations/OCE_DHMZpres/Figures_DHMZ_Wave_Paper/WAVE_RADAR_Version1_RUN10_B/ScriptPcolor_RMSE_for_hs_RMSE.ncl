load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
begin
  ;
  ; Data reading
  ;
  f = addfile("DataPcolor_RMSE_for_hs_RMSE.nc", "r")
  lat  = f->lat
  lon  = f->lon
  eVarF  = f->field
  wks  = gsn_open_wks ("pdf","RMSE_iGrid0_hs")
  res2 = True               ; plot mods desired
  res2@gsnDraw   = False
  res2@gsnFrame  = False
  res2@gsnMaximize     = True    ; Maximize plot in frame
  res2@gsnPaperOrientation = "Portrait"
  ;
  ; General frame information
  ;
  res2@mpProjection = "Mercator"
  res2@mpLimitMode         = "Corners"             ; choose range of map
  res2@mpLeftCornerLatF    = 42.9879
  res2@mpLeftCornerLonF    = 15.7094
  res2@mpRightCornerLatF   = 43.5523
  res2@mpRightCornerLonF   = 16.4655
  res2@mpFillOn      = True
  res2@mpDataBaseVersion      = "HighRes"          ; use high resolution coast
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
  res2@cnMinLevelValF       = 0.25  ; set min contour level
  res2@cnMaxLevelValF       = 0.50  ; set max contour level
  res2@cnLevelSpacingF      = 0.0125     ; set contour spacing
  res2@lbLabelStride            = 10
  ;  res2@gsnScalarContour     = False               ; contours desired
  res2@tiMainString    = "(c) Root Mean Square Error"
  res2@tiMainFont      = "Helvetica"
  res2@tiMainFontHeightF = 0.025
  ;  res2@cnTitlePosition  = "Top"
  res2@gsnSpreadColors      = True               ; use full color map
  res2@gsnSpreadColorEnd     = -3
  ;
  ; Label bar plotting
  ;
  res2@lbLabelBarOn = True
  res2@lbTitleString    = "[m]"
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
  gsn_define_colormap (wks,"BlAqGrYeOrReVi200")
  ;     other possibilities: hotres, rainbow, ViBlGrWhYeOrRe, BlWhRe, GrayWhiteGray, BlGrYeOrReVi200
  i = NhlNewColor(wks,0.8,0.8,0.8)      ; add gray to colormap
  i = NhlNewColor(wks,0.9,0.9,0.9)      ; add gray to colormap
  ;
  ; Pcolor kind of plot
  ;
  eVarF@lat2d=lat
  eVarF@lon2d=lon
  plot = gsn_csm_contour_map(wks,eVarF,res2)
  draw(plot)
  frame(wks)
end
