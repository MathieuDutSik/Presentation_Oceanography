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

;  wks = gsn_open_wks("eps","trimesh")
  wks = gsn_open_wks("pdf","trimesh")
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
  res@cnLevels              = (/50,75,100/)
;  res@cnLevels              = (/20/)
;  res@cnLevels              = (/10, 20/)
;  res@cnLevels              = (/5, 10, 20, 35/)
;  res@cnLevels              = (/20, 35, 50, 100, 150, 200, 800/)
;  res@cnLevels              = (/20, 50, 100, 200, 800/)
  res@cnLineLabelsOn     = True       ; Turn off contour lines
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
  res@mpLeftCornerLatF    = 42.9
  res@mpLeftCornerLonF    = 15.7
  res@mpRightCornerLatF   = 43.6
  res@mpRightCornerLonF   = 16.6
;  res@mpLeftCornerLatF    = min(f->y)
;  res@mpLeftCornerLonF    = min(f->x)
;  res@mpRightCornerLatF   = max(f->y)
;  res@mpRightCornerLonF   = max(f->x)
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
;              COMMON SETTINGS
  txres             = True                         ; Text resources desired
  txres@txFont        = "helvetica"
  txres@txFontHeightF=0.007
  txres@txJust="CenterLeft"
  eLon=new(1, double)
  eLat=new(1, double)

  fT = addfile("Geog_position_iGrid0_opt2.nc", "r")
  LonArr=fT->lon
  LatArr=fT->lat

  ns=dimsizes(LonArr)
  nbStat=ns(0)
  dum=new(nbStat, graphic)
  ;
  pmres = True
  pmres@gsMarkerColor = "red"
  pmres@gsMarkerIndex = 3


  do iStat=0,nbStat-1
    eLon_stat=LonArr(iStat)
    eLat_stat=LatArr(iStat)
    dum(iStat) = gsn_add_polymarker(wks, map, eLon_stat, eLat_stat, pmres)
  end do


;  frame(wks)
;  wks = gsn_open_wks("pdf","trimeshB")
  draw(map)
  frame(wks)

end
