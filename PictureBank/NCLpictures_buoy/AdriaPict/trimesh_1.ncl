;*****************************************************
; trimesh_1.ncl
;
; Concepts illustrated:
;   - Contouring one-dimensional X, Y, Z data
;   - Selecting a "rainbow" color map that also contains "gray"
;   - Spanning part of a color map for contour fill
;   - Drawing a map using the high resolution map outlines

;*****************************************************

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

function LLdms(eDeg:integer, eMin:integer, eSec:integer)
begin
  a=new(1, double)
  a=int2dble(eDeg) + int2dble(eMin)/int2dble(60) + int2dble(eSec)/int2dble(3600)
  return a
end


begin
  f = addfile("FEMgrid.nc","r")

  wks = gsn_open_wks("eps","AdriaPict")
;  wks = gsn_open_wks("pdf","trimesh")
;  gsn_define_colormap(wks,"rainbow+gray")

  res                     = True
;  res@gsnMaximize         = True
;  res@gsnSpreadColors     = True
;  res@gsnSpreadColorStart = 15         ; Start with lighter purple
;  res@gsnSpreadColorEnd   = -2         ; Make sure not to include gray

  res@sfXArray            = f->x
  res@sfYArray            = f->y
  res@sfElementNodes      = f->e
  res@sfFirstNodeIndex    = 1
  TheDep=f->z

  res@cnLevelSelectionMode  = "ExplicitLevels" ; explicit [unequal] cn levels
  res@cnLevels              = (/20, 35, 50, 100, 150, 200, 800/)
;  res@cnLevels              = (/20, 50, 100, 200, 800/)
  res@cnLineLabelsOn     = True       ; Turn off contour lines
;  res@cnLabelsMasking = True
  res@cnLabelDrawOrder = "PostDraw"
  res@cnLevelFlag = "LineAndLabel"
  res@cnLineLabelFontHeightF = 0.005
  res@cnLineLabelPerimOn = False
  res@cnLineLabelFontColor = "black"
  res@cnLineLabelBackgroundColor = "white"
  res@cnLineThicknessF = 0.2

  res@cnFillOn            = False        ; Turn on contour fill.
  res@cnLinesOn           = True       ; Turn off contour lines
;  res@lbOrientation       = "Vertical"  ; Change location of labelbar.
  res@lbLabelAutoStride   = False
;  res@cnHighLabelsOn      = True
;  res@cnHighLabelFontHeightF = 0.024
;  res@cnHighLabelBackgroundColor = -1

;
; First create just a contour plot so we can later retrieve
; the start/end limits of the actual location of the  data.
; Don't draw the contour plot or advance the frame.
;

  res@gsnDraw   = False
  res@gsnFrame  = False
  res@cnInfoLabelOn = False ; to remove "CONTOUR FROM ...."
;  res@tiXAxisString = "East"
;  res@tiYAxisString = "North"
;  res@tiXAxisOffsetYF = 1
;  res@tiYAxisOffsetXF = 1

;  res@tiMainOn  = False
;  res@lbTitleOn = False
;  res@gsnRightString  = ""
;  res@gsnLeftString   = "" 


;
; Get ready to overlay on a cylindrical equidistant map.
;
; Retrieve the actual start and end limits of the data

  res@mpProjection = "Mercator"
  res@mpLimitMode = "Corners"
  res@mpDataBaseVersion     = "HighRes"     ; "MediumRes" will run faster.
;  res@mpLimitMode           = "LatLon"
;  res@mpMinLonF             = 
;  res@mpMaxLonF             = max(f->x)
;  res@mpMinLatF             = 
;  res@mpMaxLatF             = 
  res@mpLeftCornerLatF    = min(f->y)
  res@mpLeftCornerLonF    = min(f->x)
  res@mpRightCornerLatF   = max(f->y)
  res@mpRightCornerLonF   = max(f->x)
  res@pmTickMarkDisplayMode  = "Always"           ; turn on tickmarks

;  res@mpLandFillColor      = -1

;  res@mpGridLatSpacingF = 0.5
;  res@mpGridLonSpacingF = 1.0

;  res@gsnRightStringOrthogonalPosF = 0.02     ; Move the subtitles down
;  res@gsnLeftStringOrthogonalPosF  = 0.02     ; a little bit.
  map = gsn_csm_contour_map(wks,TheDep,res)
;  DO THE RIVERS
  riv_data = asciiread("JadranRivers_extractor.dat",(/10583,2/),"float")
  riv_lon=riv_data(:,0)
  riv_lat=riv_data(:,1)
  segments=ind(riv_lon.eq.-999)
  ns=dimsizes(segments)
  resRiver = True
  resRiver@gsLineThicknessF = 1.5
  resRiver@gsLineColor  = "dodgerblue1"
  resRiver@tfPolyDrawOrder = "PostDraw"
  lines = new(ns(0)-1,graphic)   ; array to hold polylines
  do i=0,ns-2
;    print(i)
    xp=riv_lon(segments(i)+2 : segments(i+1)-2)
    yp=riv_lat(segments(i)+2 : segments(i+1)-2)
    lines(i)=gsn_add_polyline(wks,map,xp,yp,resRiver)
    delete(xp)
    delete(yp)
  end do
; DO THE CITIES
  txres             = True                         ; Text resources desired
  txres@txFont        = "helvetica"
  txres@txFontHeightF=0.01
  txres@txJust="CenterLeft"

  txresD             = True                         ; Text resources desired
  txresD@txFont        = "helvetica"
  txresD@txFontHeightF=0.005
  txresD@txAngleF=45
  txresD@txJust="CenterLeft"





;  label="Trieste"
  eLon=new(1, double)
  eLat=new(1, double)
  eLon=LLdms(13, 48, 0)
  eLat=LLdms(45, 38, 0)
;  print(eLon)
;  print(eLat)

;  text = gsn_add_text(wks,map,label, eLon, eLat, txres)

  label="Southern"
  eLon=17.4567110583789+0.07
  eLat=41.8710247349823
  text = gsn_add_text(wks,map,label, eLon, eLat, txres)

  label="Adriatic Pit"
  eLon=17.4567110583789
  eLat=41.8710247349823-0.15
  text = gsn_add_text(wks,map,label, eLon, eLat, txres)

  label="Jabuka Pit"
  eLon=14.7462138651764
  eLat=42.952296819788+0.15
  text = gsn_add_text(wks,map,label, eLon, eLat, txres)

  label="Palagruza Sill"
  eLon=15.9927526813016-0.3
  eLat=42.3374558303887+0.3
  text = gsn_add_text(wks,map,label, eLon, eLat, txres)

  label="Istria"
  eLon=LLdms(14, 0, 0)-0.25
  eLat=LLdms(45, 0, 0)+0.2
  text = gsn_add_text(wks,map,label, eLon, eLat, txres)

  label="Kvarner"
  eLon=LLdms(14, 0, 0)-0.02
  eLat=LLdms(44, 30, 0)+0.27
  text = gsn_add_text(wks,map,label, eLon, eLat, txresD)

  label="Otranto"
  eLon=LLdms(18, 35, 32)+0.03
  eLat=LLdms(40, 13, 10)+0.2
  text = gsn_add_text(wks,map,label, eLon, eLat, txres)

  label="Strait"
  eLon=LLdms(18, 35, 32)+0.18
  eLat=LLdms(40, 0 , 10)+0.2
  text = gsn_add_text(wks,map,label, eLon, eLat, txres)

; Positions of stations and Buoy.
  txresC             = True                         ; Text resources desired
  txresC@txFont        = "helvetica"
  txresC@txFontHeightF=0.01
  txresC@txJust="CenterLeft"
  txresC@txFontColor="blue"
  dum_stat=new(20, graphic)

  eLonRef=13.2997
  eLatRef=44.7428
  eLonText=eLonRef+0.07
  eLatText=eLatRef
  label="B"

    text = gsn_add_text(wks,map,label, eLonText, eLatText, txresC)
    pmres = True
    pmres@gsMarkerColor = "blue"
    pmres@gsMarkerIndex = 16
    pmres@gsMarkerSizeF = 0.002
    dum_stat(1) = gsn_add_polymarker(wks, map, eLonRef, eLatRef, pmres)

  eLonRef=12.5083333333333
  eLatRef=45.3141666666667
  eLonText=eLonRef+0.07
  eLatText=eLatRef
  label="S"

    text = gsn_add_text(wks,map,label, eLonText, eLatText, txresC)
    pmres = True
    pmres@gsMarkerColor = "blue"
    pmres@gsMarkerIndex = 16
    pmres@gsMarkerSizeF = 0.002
    dum_stat(0) = gsn_add_polymarker(wks, map, eLonRef, eLatRef, pmres)


;  eLonText=eLonRef+0.07+1
;  eLatText=eLatRef
;  label="S"
;    text = gsn_add_text(wks,map,label, eLonText, eLatText, txresC)


  txresF             = True                         ; Text resources desired
  txresF@txFont        = "helvetica"
  txresF@txFontHeightF=0.03
  label="(a)"
  eLonText=18.0
  eLatText=45.5
  text = gsn_add_text(wks,map,label, eLonText, eLatText, txresF)

;  DO THE Rectangle
  MinLon=16.65;
  MaxLon=18;
  MinLat=42.70;
  MaxLat=43.25;
  ListLon= (/ MinLon, MaxLon, MaxLon, MinLon, MinLon/)
  ListLat= (/ MinLat, MinLat, MaxLat, MaxLat, MinLat/)

  resRiver = True
  resRiver@gsLineThicknessF = 3.0
  resRiver@gsLineColor  = "dodgerblue1"
  resRiver@tfPolyDrawOrder = "PostDraw"
  linesRect = new(4,graphic)   ; array to hold polylines
  do i=0,3
;    print(i)
    xp=ListLon(i : i+1)
    yp=ListLat(i : i+1)
    linesRect(i)=gsn_add_polyline(wks,map,xp,yp,resRiver)
    delete(xp)
    delete(yp)
  end do





;  frame(wks)
;  wks = gsn_open_wks("pdf","trimeshB")
  draw(map)
  frame(wks)

end
