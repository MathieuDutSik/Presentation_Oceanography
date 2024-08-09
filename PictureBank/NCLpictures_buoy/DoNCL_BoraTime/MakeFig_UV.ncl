load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"

begin
 f = addfile("dataplot.nc", "r")
 lat2d  = f->lat
 lon2d  = f->lon
 eVarU  = f->Usurf
 eVarV  = f->Vsurf
 speed=sqrt(eVarU^2 + eVarV^2)
 fVarU= eVarU/speed
 fVarV= eVarV/speed

 wks  = gsn_open_wks ("eps", "TheCurrent")

 tride=50

 lon1=12.1
 lat1=40.2
 lon2=19.6
 lat2=45.8
 minValue=0
 maxValue=0.5
  vres1 = True               ; plot mods desired
  vres1@gsnDraw   = False
  vres1@gsnFrame  = False
  vres1@gsnPaperOrientation  = "Portrait"
  vres1@gsnScalarContour     = True               ; contours desired
  vres1@gsnSpreadColors      = True               ; use full color map
  vres1@gsnSpreadColorEnd    = -3
;  vres1@gsnSpreadColorStart  = 1
  vres1@mpLandFillColor      = "grey"            ; set land to be gray

  vres1@cnFillDrawOrder      = "PreDraw"          ; put continents on top
  vres1@cnFillOn             = True               ; turn on color for contours
  vres1@cnLinesOn            = False              ; turn off contour lines
  vres1@cnLineLabelsOn       = False              ; turn off contour line labels
  vres1@cnLevelSelectionMode = "ManualLevels"     ; set manual contour levels
  vres1@lbLabelStride            = 10
  vres1@cnMinLevelValF       = minValue                ; set min contour level
  vres1@cnMaxLevelValF       = maxValue                ; set max contour level
  vres1@cnLevelSpacingF      = 0.01                 ; set contour spacing

;  vres1@cnFillMode          = "RasterFill"

;  vres1@cnLevelSpacingF      = 0.01                 ; set contour spacing
  vres1@lbOrientation        = "Vertical"     ; /Vertical label bar
  vres1@pmLabelBarOrthogonalPosF = 0.025          ; move label bar closer
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
  vres1@vcMonoLineArrowColor  = True             ; vec's colored by their mag
  vres1@pmLabelBarWidthF = 0.02

;  vres1@tiMainString    = "Surface current" ; title string
;  vres1@tiMainFont      = "Helvetica"
;  vres1@tiMainFontHeightF=0.015
  vres1@lbTitleString    = "(m/s)"
  vres1@lbTitleFont      = "Helvetica"
  vres1@lbTitleFontHeightF = 0.015
  vres1@lbTitleDirection     = "Across"
  vres1@lbTitlePosition = "Right"
  vres1@lbTitleAngleF = 90


  vres1@gsnRightString    = "Sea surface elevation"
  vres1@gsnLeftString     = "Difference"
  vres1@gsnRightString    = ""
  vres1@gsnLeftString     = "" 
;  vres1@vcRefMagnitudeF   = 10.             ; define vector ref mag
  vres1@vcGlyphStyle      = "CurlyVector"   ; default: "LineArrow"  
;  vres1@vcGlyphStyle      = "LineArrow"   ; default: "LineArrow"  
  vres1@vcMinDistanceF    = 0.014            ; larger means sparser
  vres1@vcRefLengthF      = 0.02
  vres1@vcRefAnnoOn      = False
  vres1@vcLineArrowHeadMaxSizeF = 0.005
;  vres1@vcRefAnnoOrthogonalPosF = -0.8
;  vres1@vcRefAnnoParallelPosF = 1.0
;  vres1@vcRefMagnitudeF         = 0.5
;  vres1@vcRefAnnoString1 = "0.5 m/s"



;  gsn_define_colormap (wks,"testcmap")
  gsn_define_colormap (wks,"BlAqGrYeOrReVi200")
;  i = NhlNewColor(wks,0.8,0.8,0.8)                ; add gray to colormap 
;  gsn_define_colormap(wks,"hotres")
;  gsn_define_colormap(wks,"rainbow")
;  gsn_define_colormap(wks,"ViBlGrWhYeOrRe")
;  gsn_define_colormap(wks,"BlWhRe")
;  gsn_define_colormap(wks,"GrayWhiteGray")
;  gsn_define_colormap(wks,"BlWhRe")
  i = NhlNewColor(wks,0.8,0.8,0.8)                ; add gray to colormap 
  i = NhlNewColor(wks,0.9,0.9,0.9)                ; add gray to colormap 

;  gsn_define_colormap(wks,"BlGrYeOrReVi200");
;
  eVarU@lat2d=lat2d
  eVarU@lon2d=lon2d
  eVarV@lat2d=lat2d
  eVarV@lon2d=lon2d

  fVarU@lat2d=lat2d
  fVarU@lon2d=lon2d
  fVarV@lat2d=lat2d
  fVarV@lon2d=lon2d
  speed@lat2d=lat2d
  speed@lon2d=lon2d
  plot = gsn_csm_vector_scalar_map(wks,fVarU,fVarV,speed,vres1)
          ; contour the variable
;
  riv_data = asciiread("JadranRivers_extractor.dat",(/10583,2/),"float")
  ; load political brys
  ;riv_data@_FillValue=-999
  lon=riv_data(:,0)
  lat=riv_data(:,1)
  segments=ind(lon.eq.-999);
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
  label="(b)"
  eLonText=18.0
  eLatText=45.5
  txres             = True                         ; Text resources desired
  txres@txFont        = "helvetica"
  txres@txFontHeightF=0.02
  text = gsn_add_text(wks,plot,label, eLonText, eLatText, txres)
;  overlay(plot_ov, plot)
  draw(plot)
  frame(wks)
end
