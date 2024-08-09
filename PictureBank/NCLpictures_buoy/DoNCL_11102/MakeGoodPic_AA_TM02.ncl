load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
;************************************************
begin
  f=addfile("Acqua_Alta/Acqua_Alta_TM02_CombiPic_TM02.nc", "r")

  ListTimeDayStart=f->ListTimeDayStart
  DatMeas=f->FieldMeas
  DatModel=f->FieldModel
  Data=new((/2, dimsizes(DatMeas)/), double);
  Data(0,:)=DatMeas(:)
  Data(1,:)=DatModel(:,0)
  TheMax=max(Data)
  TheMin=min(Data)

  wks   = gsn_open_wks ("eps","TM02_AA")

  res                  = True                     ; plot mods desired
  res@gsnDraw           = False
  res@gsnFrame          = False
  res@xyMonoDashPattern = False
  res@xyDashPatterns = (/0/)
  res@tiMainFontHeightF  = 0.015
  res@tiYAxisString   = "Zero crossing period (s)"
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
   lgres@lgPerimThicknessF  = 5.0

  txres             = True                         ; Text resources desired
  txres@txFont        = "helvetica"
  txres@txFontHeightF=0.03
  label="(d)"
  eLonText=max(ListTimeDayStart)*0.9
  eLatText=max(Data)*0.9
  text = gsn_add_text(wks,plot,label, eLonText, eLatText, txres)


   txres             = True
   txres@txFontHeightF = 0.02
   amres = True
   amres@amParallelPosF   = 0.10
   amres@amOrthogonalPosF = -0.20
   draw(plot)
   frame(wks)
end

