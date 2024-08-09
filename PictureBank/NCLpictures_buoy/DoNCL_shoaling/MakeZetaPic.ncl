load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
;************************************************
begin
  f=addfile("DataPlot.nc","r")

  TheX=f->TheX
  Dat=100*f->zeta

  Data=new((/1, dimsizes(Dat)/), double);
  Data(0,:)=Dat(:)

  TheXmeas=f->MeasX
  DatMeas=100*f->MeasZeta
  DataMeas=new((/1, dimsizes(DatMeas)/), double);
  DataMeas(0,:)=DatMeas(:)

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
  res@tiYAxisString   = "free surface elevation (cm)"
  res@tiYAxisFontHeightF = 0.015
  res@trYMaxF=2.7
  res@trYMinF=-0.3
  res@trXMaxF=9
  res@trXMinF=0
  plot=gsn_csm_xy(wks,TheX,Data, res)

  resRiver = True
  resRiver@gsLineDashPattern = 1
  resRiver@gsLineThicknessF = 1
  resRiver@gsLineColor  = "black"
  resRiver@tfPolyDrawOrder = "PostDraw"

  linesRectB=gsn_add_polyline(wks,plot,TheXmeas,DatMeas,resRiver)


  nbMeas=dimsizes(TheXmeas)
  linesRect = new(nbMeas-1,graphic)   ; array to hold polylines
  do i=0,nbMeas-2
;    print(i)
    xp=TheXmeas(i : i+1)
    yp=DatMeas(i : i+1)
;    linesRect(i)=gsn_add_polyline(wks,plot,xp,yp,resRiver)
    delete(xp)
    delete(yp)
  end do

;  plot=gsn_csm_xy(wks,TheXmeas,DataMeas, res)

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
  label="(1)"
  eLonText=7
  eLatText=1
  text = gsn_add_text(wks,plot,label, eLonText, eLatText, txres)


;   lbid = gsn_create_legend(wks,4,ListLabels,lgres)
   amres = True
   amres@amParallelPosF   = 0.10
   amres@amOrthogonalPosF = -0.20
;   annoid1 = gsn_add_annotation(plot,lbid,amres)
   draw(plot)
   frame(wks)
end

