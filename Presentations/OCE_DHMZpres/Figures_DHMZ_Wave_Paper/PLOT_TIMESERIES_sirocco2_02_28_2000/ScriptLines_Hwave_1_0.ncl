load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
procedure subtitles(wks:graphic,plot:graphic,lstr:string,cstr:string, \
                    rstr:string,tres)
local txres, font_height, amres
begin
  if(tres) then
    txres = tres     ; Copy resources
  else
    txres = True
  end if
  ;
  ; Retrieve font height of left axis string and use to
  ; calculate size of subtitles.
  ;
  if(.not.isatt(txres,"txFontHeightF")) then
    getvalues plot
      "tiXAxisFontHeightF" : font_height
    end getvalues
    txres@txFontHeightF = font_height*0.9
  end if
  ;
  ; Set some some annotation resources.
  ;
  amres                  = True
  if(.not.isatt(txres,"amOrthogonalPosF")) then
    amres@amOrthogonalPosF = -0.53   ; Top of plot plus a little extra
                                     ; to stay out of the tickmarks.
  else
    amres@amOrthogonalPosF = txres@amOrthogonalPosF
  end if
  ;
  ; Create three strings to put at the top, using a slightly
  ; smaller font height than the axis titles.
  ;
  if(lstr.ne."") then
    txidl = gsn_create_text(wks, lstr, txres)
    amres@amJust           = "BottomLeft"
    amres@amParallelPosF   = -0.5   ; Left-justified
    annoidl = gsn_add_annotation(plot, txidl, amres)
  end if
  if(cstr.ne."") then
    txidc = gsn_create_text(wks, cstr, txres)
    amres@amJust           = "BottomCenter"
    amres@amParallelPosF   = 0.0   ; Centered
    annoidc = gsn_add_annotation(plot, txidc, amres)
  end if
  if(rstr.ne."") then
    txidr = gsn_create_text(wks, rstr, txres)
    amres@amJust           = "BottomRight"
    amres@amParallelPosF   = 0.5   ; Right-justifed
    annoidr = gsn_add_annotation(plot, txidr, amres)
  end if
end
;************************************************
begin
  ;
  ; Data reading
  ;
  f = addfile("/tmp/PLOT_TIMESERIES_T47HSiwPtzzlaVAUuLnO/DataLines_Hwave_1_0.nc", "r")
  ListX=f->ListX
  Data=f->ListListVect
  TheMax=max(Data)
  TheMin=0
  wks  = gsn_open_wks ("pdf","/home/mathieu/TheComputation/ALADIN_run/Version1_BUOY_RUN10_sirocco2/TimeSeries_iBuoy1_iBlock0_Hwave")
  res                  = True   ; plot mods desired
  res@gsnFrame          = False
  res@xyMonoDashPattern = False
  res@xyDashPatterns = (/0/)
  res@tiMainFontHeightF  = 0.015
  res@tiYAxisString   = "Significant wave height(m)"
  res@tiYAxisFontHeightF = 0.015
  res@xyLineColors = (/"black","red"/)
  res@trYMaxF=2.5
  res@trYMinF=0
  res@trXMaxF=max(ListX)
  res@trXMinF=min(ListX)
  res@tmXBMode="Explicit" 
  res@tmXBValues=(/57445.000000000, 57446.000000000, 57447.000000000, 57448.000000000/)
  res@tmXBLabels=(/"02.27", "02.28", "02.29", "03.01"/)
  plot=gsn_csm_xy(wks,ListX,Data,res)
  txresB             = True
  txresB@txFontHeightF = 0.02
  txresB@txFontColor = "black"
  strLeft=""
  strMid="Time series of Hwave for buoy 6101628"
  strRight=""
  subtitles(wks, plot, strLeft, strMid, strRight, txresB)
  lgres                    = True
  lgres@lgLineColors     = (/"black","red"/)
  lgres@lgItemType         = "Lines"
  lgres@lgDashIndexes = (/0,0/)
  lgres@lgLabelFontHeightF = .07
  lgres@vpWidthF           = 0.11
  lgres@vpHeightF          = 0.12
  lgres@lgPerimOn = False
  ;   lgres@lgPerimColor       = "orange"
  lgres@lgPerimThicknessF  = 5.0
  ListLabels= (/"buoy","Explicit scheme"/)
  lbid = gsn_create_legend(wks,2,ListLabels,lgres)
  amres = True
  amres@amParallelPosF   = 0.35
  amres@amOrthogonalPosF = 0.30
  annoid1 = gsn_add_annotation(plot,lbid,amres)
  draw(plot)
  frame(wks)
end
