load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
;************************************************
begin
  f=addfile("Acqua_Alta/Acqua_Alta_Dwave_CombiPic_Dwave.nc", "r")

  ListTimeDayStart=f->ListTimeDayStart
  DatMeas=f->FieldMeas
  DatModel=f->FieldModel
  Data=new((/2, dimsizes(DatMeas)/), double);
  Data(0,:)=DatMeas(:)
  Data(1,:)=DatModel(:,0)
  TheMax=360
  TheMin=0

  wks   = gsn_open_wks ("eps","Dwave_AA")

  res                  = True                     ; plot mods desired
  res@gsnDraw           = False
  res@gsnFrame          = False
  res@xyMonoDashPattern = False
  res@xyDashPatterns = (/0/)
;  res@tiMainString     = "Average Bathymetry modification"
  res@tiMainFontHeightF  = 0.015
;  res@tiXAxisString   = "x (m)"
;  res@tiXAxisFontHeightF = 0.020
  res@tiYAxisString   = "Mean direction (deg)"
  res@tiYAxisFontHeightF = 0.015
  res@xyLineColors = (/"black", "red"/)
  res@trYMaxF=TheMax
  res@trYMinF=TheMin
  res@trXMaxF=max(ListTimeDayStart)
  res@trXMinF=0
  res@tmXBMode="Explicit"
  res@tmXBValues=(/0,10,20,max(ListTimeDayStart)/)
  res@tmXBLabels=(/"15 nov", "25 nov", "5 dec", "15 dec"/)

  plot=gsn_csm_xy(wks,ListTimeDayStart,Data, res)

   lgres                    = True
   lgres@lgLineColors     = (/"foreground", "blue"/)
   lgres@lgItemType         = "Lines"
   lgres@lgDashIndexes = (/0/)
   lgres@lgLabelFontHeightF = .10
   lgres@vpWidthF           = 0.45
   lgres@vpHeightF          = 0.13
   lgres@lgPerimOn = False
;   lgres@lgPerimColor       = "orange"
   lgres@lgPerimThicknessF  = 5.0

  txres             = True                         ; Text resources desired
  txres@txFont        = "helvetica"
  txres@txFontHeightF=0.03
;  subtitles(wks,map,"c)","","",txres)
  label="(c)"
  eLonText=max(ListTimeDayStart)*0.9
  eLatText=max(Data)*0.9
  text = gsn_add_text(wks,plot,label, eLonText, eLatText, txres)


   txres             = True
   txres@txFontHeightF = 0.02
;   txres@txFontColor = "ForestGreen"
;   subtitles(wks,plot,"(b)","","",txres)


;   ListLabels= (/"Linear Programming volume"

;   lbid = gsn_create_legend(wks,4,ListLabels,lgres)
   amres = True
   amres@amParallelPosF   = 0.10
   amres@amOrthogonalPosF = -0.20
;   annoid1 = gsn_add_annotation(plot,lbid,amres)
   draw(plot)
   frame(wks)
end

