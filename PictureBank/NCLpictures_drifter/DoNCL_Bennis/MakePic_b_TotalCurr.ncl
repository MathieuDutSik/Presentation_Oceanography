load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
begin

  f = addfile("DataPlot18000.nc", "r")
  X  = f->TheXexpand
  Z = f->Z_w
  Vtot= f->Vtot

  stride=20
  spacing=0.05
; minValue=min(Vtot)
; maxValue=max(Vtot)
  minValue=1
  maxValue=6

  wks  = gsn_open_wks ("eps", "Bennis_b_TotalLag")
  gsn_define_colormap(wks,"BlAqGrYeOrRevi200")
  res     = True               ; plot mods desired
  res@gsnDraw   = False
  res@gsnFrame  = False
  res@gsnMaximize     = True    ; Maximize plot in frame
  res@gsnPaperOrientation = "Portrait"
  res@cnFillDrawOrder        = "PreDraw"
  res@cnFillOn             = True               ; turn on color for contours
  res@cnLinesOn            = False              ; turn off contour lines
  res@cnLineLabelsOn       = False              ; turn off contour line labels
  res@cnFillMode           = "AreaFill"
  res@gsnSpreadColors      = True               ; use full color map
  res@gsnSpreadColorEnd     = -2
  res@cnLevelSelectionMode = "ManualLevels"     ; set manual contour levels
  res@cnMinLevelValF       = minValue                ; set min contour level
  res@cnMaxLevelValF       = maxValue              ; set max contour level
  res@cnLevelSpacingF      = spacing                 ; set contour spacing
  res@pmLabelBarOrthogonalPosF = -0.01          ; move label bar closer
;  res@pmLabelBarDisplayMode = "Always"          ; Turn on a label bar.

  res@lbLabelBarOn =  True
  res@lbLabelStride            = stride
  res@lbTitleString   = "cm/s"
  res@lbTitleFontHeightF = 0.018
  res@lbOrientation        = "Vertical"     ; /Vertical label bar
  res@lbPerimOn             = False             ; no box around it
  res@lbBoxLinesOn         = False               ; Yes/No labelbar box lines.

  res@tiXAxisString  = "Distance (m)"
  res@tiYAxisString    = "Depth (m)"
  res@tiYAxisFontHeightF = 0.023
  res@tiXAxisOffsetYF = 0.0
  res@tmYLAutoPrecision = False
  res@tmYLPrecision = 0


; First part Hwave

  res@sfXArray            = X
  res@sfYArray            = Z
  res@trGridType	    = "TriangularMesh"
  plot = gsn_csm_contour(wks,Vtot,res)

  txres             = True                         ; Text resources desired
  txres@txFont      = "helvetica"
  txres@txFontHeightF=0.03

  label="(b)"
  text = gsn_add_text(wks,plot,label, 700, -1.0, txres)

  draw(plot)
  frame(wks)
end
