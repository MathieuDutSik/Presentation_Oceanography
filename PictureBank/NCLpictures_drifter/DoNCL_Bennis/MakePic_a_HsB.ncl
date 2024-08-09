load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
;************************************************
begin
  f=addfile("DataPlot18000.nc", "r")
  TheX=f->TheX
  TheHs=f->Hsignificant
  Data=new((/1, dimsizes(TheHs)/), double);
  Data(0,:)=TheHs
  TheMax=1.045
  TheMin=1.02

  wks   = gsn_open_wks ("eps","Bennis_a_HsB")

  res                  = True                     ; plot mods desired
  res@gsnDraw           = False
  res@gsnFrame          = False
  res@xyMonoDashPattern = False
  res@xyDashPatterns = (/0/)
  res@tiMainFontHeightF  = 0.015
;  res@tiYAxisString   = "Significant wave height (m)"
;  res@tiYAxisFontHeightF = 0.023
  res@xyLineColors = (/"black"/)
  res@xyLineThicknesses = (/3.0/)
  res@trYMaxF=TheMax
  res@trYMinF=TheMin
  res@trXMinF=min(TheX)
  res@trXMaxF=max(TheX)
;  res@tmXBPrecision=2
  res@tmYLMode     = "Explicit"
  res@tmYLValues =(/1.02,    1.03,   1.04 /)
  res@tmYLLabels =(/"1.02", "1.03", "1.04" /)
  res@tmYLMinorValues = (/1.02,    1.03,   1.04 /)
  res@tmYLPrecision=3

  plot=gsn_csm_xy(wks,TheX,Data, res)

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
  label="Significant wave height"
  eLonText=max(TheX)*0.5
  eLatText=1.043
  text = gsn_add_text(wks,plot,label, eLonText, eLatText, txres)

  txres             = True
  txres@txFontHeightF = 0.02
  amres = True
  amres@amParallelPosF   = 0.10
  amres@amOrthogonalPosF = -0.20
  draw(plot)
  frame(wks)
end

