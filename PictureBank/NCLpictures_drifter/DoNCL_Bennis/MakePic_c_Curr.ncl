load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
;************************************************
begin
  f=addfile("DataPlot18000.nc", "r")
  TheX=f->TheX
  TheVbar=f->Vbar
  TheVbarS=f->VbarStokes
  Data=new((/2, dimsizes(TheX)/), double);
  Data(0,:)=TheVbar
  Data(1,:)=TheVbarS
  TheMax=3.2
  TheMin=0

  wks   = gsn_open_wks ("eps","Bennis_c_Curr")

  res                  = True                     ; plot mods desired
  res@gsnDraw           = False
  res@gsnFrame          = False
  res@xyMonoDashPattern = False
  res@xyDashPatterns = (/0/)
;  res@tiMainString     = "Average Bathymetry modification"
  res@tiMainFontHeightF  = 0.015
;  res@tiXAxisString   = "x (m)"
;  res@tiXAxisFontHeightF = 0.020
  res@tiYAxisString   = "Current (cm/s)"
  res@tiYAxisFontHeightF = 0.023
  res@xyLineColors = (/"black", "red"/)
  res@xyLineThicknesses = (/3.0, 3.0/)
  res@trYMaxF=TheMax
  res@trYMinF=TheMin
  res@trXMinF=min(TheX)
  res@trXMaxF=max(TheX)
;  res@tiXAxisString  = "Distance (m)"

;  res@tmXBMode="Explicit"
;  res@tmXBValues=(/0,10,20,max(ListTimeDayStart)/)
;  res@tmXBLabels=(/"15 nov", "25 nov", "5 dec", "15 dec"/)

  plot=gsn_csm_xy(wks,TheX,Data, res)


  txres             = True                         ; Text resources desired
  txres@txFont        = "helvetica"
  txres@txFontHeightF=0.03
  label="(c)"
  eLonText=max(TheX)*0.9
  eLatText=2.5
  text = gsn_add_text(wks,plot,label, eLonText, eLatText, txres)


  lgres                    = True
  lgres@lgLineColors     = (/"foreground", "red"/)
  lgres@lgItemType         = "Lines"
  lgres@lgDashIndexes = (/0, 0/)
  lgres@lgLabelFontHeightF = .05
  lgres@vpWidthF           = 0.45
  lgres@vpHeightF          = 0.13
  lgres@lgPerimOn = False
;   gres@lgPerimColor       = "orange"
  lgres@lgPerimThicknessF  = 5.0

  ListLabels= (/"Quasi Eulerian", "Stokes"/)

  lbid = gsn_create_legend(wks,2,ListLabels,lgres)
  amres = True
  amres@amParallelPosF   = 0.10
  amres@amOrthogonalPosF = -0.00
  annoid1 = gsn_add_annotation(plot,lbid,amres)

  draw(plot)
  frame(wks)
end

