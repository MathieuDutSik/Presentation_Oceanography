load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$HOME/opt/ncl_ncarg6.0.0/myscript/subtitles.ncl"
begin

  f = addfile("cloudScatterMagLAMI_neu.nc", "r")
  X  = f->X2D
  Y = f->Y2D
  Vtot= f->canvas
  strWrite=f->strWrite

  stride=20
  spacing=0.025
  minValue=min(Vtot)
  maxValue=2
;  minValue=1
;  maxValue=6
  wks  = gsn_open_wks ("eps", "MagScatter")
  gsn_define_colormap(wks,"BlAqGrYeOrRevi200")
  vres1 = True               ; plot mods desired
  vres1@gsnDraw   = False
  vres1@gsnFrame  = False
  vres1@gsnMaximize     = True    ; Maximize plot in frame
  vres1@gsnPaperOrientation = "Portrait"
  vres1@cnFillDrawOrder        = "PreDraw"
  vres1@cnFillOn             = True               ; turn on color for contours
  vres1@cnLinesOn            = False              ; turn off contour lines
  vres1@cnLineLabelsOn       = False              ; turn off contour line labels
  vres1@cnFillMode           = "AreaFill"
  vres1@gsnSpreadColors      = True               ; use full color map
  vres1@gsnSpreadColorEnd     = -2

  LLabel=new(81,string)
  LLabel(0)="1"
  LLabel(20)="3"
  LLabel(40)="10"
  LLabel(60)="30"
  LLabel(80)="100"
  vres1@lbLabelBarOn =  True
  vres1@lbLabelStride            = stride
  vres1@lbOrientation        = "Vertical"     ; /Vertical label bar
  vres1@lbLabelStrings = LLabel


  vres1@cnLevelSelectionMode = "ManualLevels"     ; set manual contour levels
  vres1@cnMinLevelValF       = minValue                ; set min contour level
  vres1@cnMaxLevelValF       = maxValue              ; set max contour level
  vres1@cnLevelSpacingF      = spacing                 ; set contour spacing
  vres1@pmLabelBarOrthogonalPosF = -0.01          ; move label bar closer
;  vres1@pmLabelBarDisplayMode = "Always"          ; Turn on a label bar.
  vres1@lbPerimOn             = False             ; no box around it
  vres1@lbBoxLinesOn         = False               ; Yes/No labelbar box lines.

  vres1@tiXAxisString  = "Data (m/s)"
  vres1@tiYAxisString    = "Model (m/s)"
  vres1@tiXAxisOffsetYF = 0.0
;  vres1@tmYLAutoPrecision = False
;  vres1@tmYLPrecision = 0


; First part Hwave

  vres1@sfXArray            = X
  vres1@sfYArray            = Y
  vres1@trGridType	    = "TriangularMesh"
;  vres1@trGridType         = "curvilinear"
  plot = gsn_csm_contour(wks,Vtot,vres1)

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
