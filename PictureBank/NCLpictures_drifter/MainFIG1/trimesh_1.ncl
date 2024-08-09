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

  wks = gsn_open_wks("eps","trimesh")
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
  res@cnLabelsMasking = True
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
  txres@txFontHeightF=0.007
  txres@txJust="CenterLeft"

  label="Trieste"
  eLon=new(1, double)
  eLat=new(1, double)
;  eLon=13 + int2flt(48)/int2flt(60)
  eLon=LLdms(13, 48, 0)
  eLat=LLdms(45, 38, 0)
  print(eLon)
  print(eLat)

  text = gsn_add_text(wks,map,label, eLon, eLat, txres)

  label="Senj"
  eLon=LLdms(14, 54, 0)
  eLat=LLdms(44, 57, 0)
  text = gsn_add_text(wks,map,label, eLon, eLat, txres)

  label="Po"
  eLon=LLdms(12, 32, 49)
  eLat=LLdms(44, 58, 12)
  text = gsn_add_text(wks,map,label, eLon, eLat, txres)

  label="Dubrovnik"
  eLon=LLdms(18, 06, 30)
  eLat=LLdms(42, 38, 25)
  text = gsn_add_text(wks,map,label, eLon, eLat, txres)

  label="Istria"
  eLon=LLdms(13, 54, 16) - 0.2
  eLat=LLdms(45, 15, 40)
  text = gsn_add_text(wks,map,label, eLon, eLat, txres)

  label="Kvarner"
  eLon=14.15
  eLat=44.87
  text = gsn_add_text(wks,map,label, eLon, eLat, txres)

  label="Sibenik"
  eLon=LLdms(15, 55, 0)
  eLat=LLdms(43, 44, 0)
  text = gsn_add_text(wks,map,label, eLon, eLat, txres)

  label="Strait of Otranto"
  eLon=LLdms(18, 35, 32)
  eLat=LLdms(40, 13, 10)
  text = gsn_add_text(wks,map,label, eLon, eLat, txres)

  label="Venice"
  eLon=LLdms(12, 20, 09)
  eLat=LLdms(45, 26, 15) + 0.05
  text = gsn_add_text(wks,map,label, eLon, eLat, txres)

  label="Ancona"
  eLon=LLdms(13, 31,  0)
  eLat=LLdms(43, 37, 01)
  text = gsn_add_text(wks,map,label, eLon, eLat, txres)
  
; DO THE TOWER POSITIONS
  fT = addfile("TowerInfo.nc","r")
  LonText=fT->lon_text
  LatText=fT->lat_text
  LonTower=fT->lon
  LatTower=fT->lat
  ListNames=fT->ListNames
  ns=dimsizes(LonTower)
  nbTower=ns(0)
;  print(nbTower)
  dum=new(nbTower, graphic)
  txresB             = True                         ; Text resources desired
  txresB@txFont        = "helvetica"
  txresB@txFontHeightF=0.007
  txresB@txJust="CenterLeft"
  txresB@txFontColor="red"

  do iTower=0,nbTower-1
    Tower_lon=LonTower(iTower)
    Tower_lat=LatTower(iTower)
    eLon=LonText(iTower)
    eLat=LatText(iTower)
;    print(iTower)
;    print(eLon)
;    print(eLat)
    label=str_strip(ListNames(iTower,:))
    text = gsn_add_text(wks,map,label, eLon, eLat, txresB)
    pmres = True
    pmres@gsMarkerColor = "red"
    pmres@gsMarkerIndex = 3
    dum(iTower) = gsn_add_polymarker(wks, map, Tower_lon, Tower_lat, pmres)
  end do


; DO THE ADCP POSITIONS
  fS = addfile("StatInfo.nc","r")
  Stat_LonText=fS->lon_text
  Stat_LatText=fS->lat_text
  Stat_Lon=fS->lon
  Stat_Lat=fS->lat
  ListNameStat=fS->ListNames
  ns=dimsizes(Stat_Lon)
  nbStat=ns(0)
  dum_stat=new(nbStat, graphic)
;  print(nbTower)

  txresC             = True                         ; Text resources desired
  txresC@txFont        = "helvetica"
  txresC@txFontHeightF=0.005
  txresC@txJust="CenterLeft"
  txresC@txFontColor="blue"

  do iStat=0,nbStat-1
    eLonText=Stat_LonText(iStat)
    eLatText=Stat_LatText(iStat)
    eLonRef=Stat_Lon(iStat)
    eLatRef=Stat_Lat(iStat)
;    print(iTower)
;    print(eLon)
;    print(eLat)
    label=str_strip(ListNameStat(iStat,:))
    if (label.eq."VR1") then
      eLonText=eLonRef-0.07
      eLatText=eLatRef+0.05
    end if
    if (label.eq."VR2") then
      eLonText=eLonRef
      eLatText=eLatRef-0.05
    end if
    if (label.eq."VR4") then
      eLonText=eLonText-0.12
      eLatText=eLatText
    end if
    if (label.eq."VR5") then
      eLonText=eLonText-0.12
      eLatText=eLatText
    end if
    if (label.eq."VR6") then
      eLonText=eLonRef-0.09
      eLatText=eLatRef-0.07
    end if
    if (label.eq."SS9") then
      eLonText=eLonRef+0.03
      eLatText=eLatRef
    end if
    if (label.eq."KB1") then
      eLonText=eLonRef-0.06
      eLatText=eLatRef-0.07
    end if
    if ((label.eq."CP5").or.(label.eq."CP3")) then
      eLonText=eLonRef-0.07
      eLatText=eLatRef-0.07
    end if
    if (label.eq."IC") then
      eLonText=eLonRef-0.05
      eLatText=eLatRef-0.07
    end if
    text = gsn_add_text(wks,map,label, eLonText, eLatText, txresC)

    pmres = True
    pmres@gsMarkerColor = "blue"
    pmres@gsMarkerIndex = 16
    pmres@gsMarkerSizeF = 0.002
    dum_stat(iStat) = gsn_add_polymarker(wks, map, eLonRef, eLatRef, pmres)
  end do


;  frame(wks)
;  wks = gsn_open_wks("pdf","trimeshB")
  draw(map)
  frame(wks)

end
