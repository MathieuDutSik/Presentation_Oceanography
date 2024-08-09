load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
;************************************************
begin
  f=addfile("DataPlot.nc","r")

  TheX=f->TheX
  DatZeta=100*f->zeta
  Data=new((/1, dimsizes(DatZeta)/), double);
  Data(0,:)=DatZeta(:)
  TheMax=max(Data)
  TheMin=min(Data)

  wks   = gsn_open_wks ("eps","Zeta")

  res                  = True                     ; plot mods desired
  res@gsnDraw           = False
  res@gsnFrame          = False
  res@xyMonoDashPattern = False
  res@xyDashPatterns = (/0/)
  res@tiMainFontHeightF  = 0.015
  res@tiXAxisString   = "x (m)"
  res@tiXAxisFontHeightF = 0.020
  res@tiYAxisString   = "Free Surface (cm)"
  res@tiYAxisFontHeightF = 0.015
  res@trYMaxF=TheMax
  res@trYMinF=TheMin
  res@trXMaxF=10
  res@trXMinF=0
  plot=gsn_csm_xy(wks,TheX,Data, res)

   lgres                    = True
   lgres@lgLineColors     = (/"foreground"/)
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
  label="(c)"
  eLonText=8
  eLatText=0.1
  text = gsn_add_text(wks,plot,label, eLonText, eLatText, txres)


;   ListLabels= (/"Linear Programming volume"

;   lbid = gsn_create_legend(wks,4,ListLabels,lgres)
   amres = True
   amres@amParallelPosF   = 0.10
   amres@amOrthogonalPosF = -0.20
;   annoid1 = gsn_add_annotation(plot,lbid,amres)
   draw(plot)
   frame(wks)
end

