load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"

begin
 f = addfile("dataplot.nc", "r")
 lat2d  = f->lat
 lon2d  = f->lon
 eVar  = f->Hwave


 wks  = gsn_open_wks ("png", "HwaveB")
; wks  = gsn_open_wks ("eps", "HwaveB")


 lon1=12.1
 lat1=40.2
 lon2=19.6
 lat2=45.8
 minValue=0
 maxValue=max(eVar)

  vres1 = True               ; plot mods desired
  vres1@gsnDraw   = False
  vres1@gsnFrame  = False
  vres1@gsnMaximize     = True    ; Maximize plot in frame
  vres1@gsnPaperOrientation = "Portrait"
  vres1@cnFillDrawOrder        = "PreDraw"
  vres1@cnFillOn             = True               ; turn on color for contours
  vres1@cnLinesOn            = False              ; turn off contour lines
  vres1@cnLineLabelsOn       = False              ; turn off contour line labels
  vres1@cnFillMode           = "AreaFill"
;  vres1@cnRasterSmoothingOn  = True
  vres1@cnSmoothingOn  = True
;  vres1@cnSmoothingDistanceF  = 0.05
;  vres1@cnSmoothingTensionF  = -1
;  vres1@gsnScalarContour     = False               ; contours desired

;  vres1@tiMainString    = "Significant wave height difference (m)"
;  vres1@tiMainFont      = "Helvetica"
;  vres1@tiMainFontHeightF = 0.015
  vres1@lbTitleString    = "(m)"
  vres1@lbTitleFont      = "Helvetica"
  vres1@lbTitleFontHeightF = 0.015
  vres1@lbTitleDirection     = "Across"
  vres1@lbTitlePosition = "Right"
  vres1@lbTitleAngleF = 90

;  vres1@cnTitlePosition  = "Top"              ; title position

  vres1@gsnSpreadColors      = True               ; use full color map
  vres1@gsnSpreadColorEnd     = -3
  vres1@mpLandFillColor       = "gray"            ; set land to be gray
  vres1@lbLabelBarOn = True
  vres1@lbLabelStride            = 20
  vres1@cnLevelSelectionMode = "ManualLevels"     ; set manual contour levels
  vres1@cnMinLevelValF       = minValue                ; set min contour level
  vres1@cnMaxLevelValF       = maxValue                ; set max contour level
  vres1@cnLevelSpacingF      = 0.05                 ; set contour spacing

;  vres1@cnFillMode          = "RasterFill"

  vres1@lbOrientation        = "Vertical"     ; /Vertical label bar
  vres1@pmLabelBarOrthogonalPosF = 0.025          ; move label bar closer
;  vres1@lbHeightF               = 0.7          ; move label bar closer
  vres1@pmLabelBarDisplayMode = "Always"          ; Turn on a label bar.
  vres1@lbPerimOn             = False             ; no box around it
  vres1@lbBoxLinesOn         = False               ; Yes/No labelbar box lines.
  
  vres1@mpProjection = "Mercator"
  vres1@mpLimitMode         = "Corners"             ; choose range of map
  vres1@mpLeftCornerLatF    = lat1
  vres1@mpLeftCornerLonF    = lon1
  vres1@mpRightCornerLatF   = lat2
  vres1@mpRightCornerLonF   = lon2
  vres1@mpDataBaseVersion      = "HighRes"          ; use high resolution coast
  vres1@pmTickMarkDisplayMode  = "Always"           ; turn on tickmarks
  vres1@mpLandFillColor      = "LightGrey"
  vres1@pmLabelBarWidthF = 0.03


  vres1@gsnRightString  = "Sea surface elevation"
  vres1@gsnLeftString    = "Difference"
  vres1@gsnRightString  = ""
  vres1@gsnLeftString    = "" 


;  gsn_define_colormap (wks,"testcmap")
  gsn_define_colormap (wks,"BlAqGrYeOrReVi200")
;  gsn_define_colormap(wks,"hotres")
;  gsn_define_colormap(wks,"rainbow")
;  gsn_define_colormap(wks,"ViBlGrWhYeOrRe")
;  gsn_define_colormap(wks,"BlWhRe")
  i = NhlNewColor(wks,0.8,0.8,0.8)                ; add gray to colormap 
  i = NhlNewColor(wks,0.9,0.9,0.9)                ; add gray to colormap 
;  gsn_define_colormap(wks,"BlGrYeOrReVi200");
;
  eVar@lat2d=lat2d
  eVar@lon2d=lon2d
;  vres1@cnMaxLevelValF       = 0.05
  plot = gsn_csm_contour_map(wks,eVar,vres1)
;
  riv_data = asciiread("JadranRivers_extractor.dat",(/10583,2/),"float")
  ; load political brys
  ;riv_data@_FillValue=-999
  lon=riv_data(:,0)
  lat=riv_data(:,1)
  segments=ind(lon.eq.-999)
  ns=dimsizes(segments)
  resP = True
  resP@gsLineThicknessF = 1.5
  resP@gsLineColor  = "dodgerblue1"
  resP@tfPolyDrawOrder = "PostDraw"
  print("ns=" + ns(0))
  lines = new(ns(0)-1,graphic)   ; array to hold polylines
  do i=0,ns-2
    xp=lon(segments(i)+2 : segments(i+1)-2)
    yp=lat(segments(i)+2 : segments(i+1)-2)
    lines(i)=gsn_add_polyline(wks,plot,xp,yp,resP)
    delete(xp)
    delete(yp)
  end do
  delete(segments)
;
  label="Hs coupled"
  eLonText=18.0
  eLatText=45.5
  txres             = True                         ; Text resources desired
  txres@txFont        = "helvetica"
  txres@txFontHeightF=0.03
  text = gsn_add_text(wks,plot,label, eLonText, eLatText, txres)
  draw(plot)
  frame(wks)
end
