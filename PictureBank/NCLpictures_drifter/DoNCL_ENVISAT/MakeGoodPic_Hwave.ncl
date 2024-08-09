load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$HOME/opt/ncl_ncarg6.0.0/myscript/subtitles.ncl"
begin

  f = addfile("ScatterCloudHwaveIgor__ENVISAT.nc", "r")
  X2D  = f->X2D
  Y2D = f->Y2D
  Vtotalnan=f->totalnan
  DatRange = f->data_range
  MaxVal=DatRange(1)

  X  = f->X
  Y = f->Y
  ns=dimsizes(X)
  nb=ns(0)
  data2d=new( (/2, nb/), double)
  data2d(0,:)=X
  data2d(1,:)=X

  strWrite=f->strWrite

  stride=1
  spacing=1
  wks  = gsn_open_wks ("eps", "HwaveScatter_envisat")
  vres1 = True               ; plot mods desired
  vres1@gsnDraw   = False
  vres1@gsnFrame  = False
  vres1@gsnMaximize     = False    ; Maximize plot in frame
  vres1@gsnPaperOrientation = "Portrait"

  vres1@trYMinF=0
  vres1@trXMinF=0
  vres1@trYMaxF=MaxVal
  vres1@trXMaxF=MaxVal
  vres1@tiXAxisString  = "Data (m)"
  vres1@tiYAxisString    = "Model (m)"
  vres1@tiXAxisOffsetYF = 0.0
  vres1@tmXBPrecision=1
  vres1@tmYLPrecision=1


  plot=gsn_csm_blank_plot(wks, vres1)

  resP = True
  resP@gsLineThicknessF = 1.5
  resP@gsLineColor  = "black"
  resP@tfPolyDrawOrder = "PostDraw"
  xp=(/-180, 180/)
  yp=(/-180, 180/)
  line0=gsn_add_polyline(wks,plot,xp,yp,resP)


  ListX  = f->ListX
  ListY = f->ListY
  line1=gsn_add_polyline(wks,plot,ListX,ListY,resP)


  txresC             = True                         ; Text resources desired
  txresC@txFont        = "helvetica"
  txresC@txFontHeightF=0.005
  txresC@txJust="CenterLeft"
  txresC@txFontColor="blue"
  dum=new(nb, graphic)
  do iPair=0,nb-1
    eX=X(iPair)
    eY=Y(iPair)
    pmres = True
    pmres@gsMarkerColor = "red"
    pmres@gsMarkerIndex = 16
    pmres@gsMarkerSizeF = 0.004
    dum(iPair) = gsn_add_polymarker(wks, plot, eX, eY, pmres)
  end do

;  txres             = True                         ; Text resources desired
;  txres@txFont      = "helvetica"
;  txres@txFontHeightF=0.03
;  label="(b)"
;  text = gsn_add_text(wks,plot,label, 700, -0.3, txres)

  txresB             = True
  txresB@txFontHeightF = 0.02
  txresB@txFontColor = "black"
  subtitles(wks,plot,"",strWrite,"",txresB)

  draw(plot)
  frame(wks)

end
