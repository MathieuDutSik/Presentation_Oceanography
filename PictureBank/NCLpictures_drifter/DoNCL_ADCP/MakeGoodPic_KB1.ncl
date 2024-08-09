load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
;************************************************
begin
  f=addfile("KB1_uvsurf_mag_detide.nc", "r")

  ListTimeDayStart=f->ListTimeDayStart
  DatMeas=f->FieldMeas
  DatModel=f->FieldModel
  Data=new((/5, dimsizes(DatMeas)/), double);
  Data(0,:)=DatMeas(:)
  Data(1,:)=DatModel(:,0)
  Data(2,:)=DatModel(:,1)
  Data(3,:)=DatModel(:,2)
  Data(4,:)=DatModel(:,3)
  TheMax=360
  TheMin=0

  wks   = gsn_open_wks ("eps","KB1_uv")
  ListDayCal=ListTimeDayStart+7


  res                  = True                     ; plot mods desired
  res@gsnDraw           = False
  res@gsnFrame          = False
  res@xyMonoDashPattern = False
  res@xyDashPatterns = (/0/)
  res@tiMainFontHeightF  = 0.015
;  res@tiXAxisString   = "x (m)"
;  res@tiXAxisFontHeightF = 0.020
;  res@tiYAxisString   = "Surface current magnitude (m/s)"
;  res@tiYAxisFontHeightF = 0.015
  res@xyLineColors = (/"black", "red", "blue", "purple", "green"/)
  res@xyLineThicknesses = (/2.0, 1.0, 1.0, 1.0, 1.0/)
  res@trYMaxF=max(Data)
  res@trYMinF=min(Data)
  res@trXMaxF=max(ListDayCal)
  res@trXMinF=min(ListDayCal)
  res@tmXBPrecision=2
  res@tmYLPrecision=1

;  res@tmXBMode="Explicit"
;  res@tmXBValues=(/0,1,2,max(ListTimeDayStart)/)
;  res@tmXBLabels=(/"15 nov", "25 nov", "5 dec", "15 dec"/)

  plot=gsn_csm_xy(wks,ListDayCal,Data, res)


   lgres                    = True
   lgres@lgLineColors     = (/"foreground", "red", "blue", "purple", "green"/)
   lgres@lgItemType         = "Lines"
   lgres@lgDashIndexes = (/0, 0, 0, 0, 0/)
   lgres@lgLabelFontHeightF = .07
   lgres@vpWidthF           = 0.11
   lgres@vpHeightF          = 0.12
   lgres@lgPerimOn = False
;   lgres@lgPerimColor       = "orange"
   lgres@lgPerimThicknessF  = 5.0
   ListLabels= (/"Meas", "Exp. 1", "Exp. 2", "Exp. 3", "Exp. 4"/)
   lbid = gsn_create_legend(wks,5,ListLabels,lgres)

  txres             = True                         ; Text resources desired
  txres@txFont        = "helvetica"
  txres@txFontHeightF=0.03
;  subtitles(wks,map,"c)","","",txres)
  label="KB1"
  eLonText=11
  eLatText=0.55
  text = gsn_add_text(wks,plot,label, eLonText, eLatText, txres)


   amres = True
   amres@amParallelPosF   = -0.10
   amres@amOrthogonalPosF = 0.40
   annoid1 = gsn_add_annotation(plot,lbid,amres)
   draw(plot)
   frame(wks)
end

