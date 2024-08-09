load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
procedure subtitles(wks:graphic,plot:graphic,lstr:string,cstr:string, \
                    rstr:string,tres)
local txres, font_height, amres
begin
  if(tres) then
    txres = tres     ; Copy resources
  else
    txres = True
  end if
  ;
  ; Retrieve font height of left axis string and use to
  ; calculate size of subtitles.
  ;
  if(.not.isatt(txres,"txFontHeightF")) then
    getvalues plot
      "tiXAxisFontHeightF" : font_height
    end getvalues
    txres@txFontHeightF = font_height*0.9
  end if
  ;
  ; Set some some annotation resources.
  ;
  amres                  = True
  if(.not.isatt(txres,"amOrthogonalPosF")) then
    amres@amOrthogonalPosF = -0.53   ; Top of plot plus a little extra
                                     ; to stay out of the tickmarks.
  else
    amres@amOrthogonalPosF = txres@amOrthogonalPosF
  end if
  ;
  ; Create three strings to put at the top, using a slightly
  ; smaller font height than the axis titles.
  ;
  if(lstr.ne."") then
    txidl = gsn_create_text(wks, lstr, txres)
    amres@amJust           = "BottomLeft"
    amres@amParallelPosF   = -0.5   ; Left-justified
    annoidl = gsn_add_annotation(plot, txidl, amres)
  end if
  if(cstr.ne."") then
    txidc = gsn_create_text(wks, cstr, txres)
    amres@amJust           = "BottomCenter"
    amres@amParallelPosF   = 0.0   ; Centered
    annoidc = gsn_add_annotation(plot, txidc, amres)
  end if
  if(rstr.ne."") then
    txidr = gsn_create_text(wks, rstr, txres)
    amres@amJust           = "BottomRight"
    amres@amParallelPosF   = 0.5   ; Right-justifed
    annoidr = gsn_add_annotation(plot, txidr, amres)
  end if
end
begin
  f = addfile("DataScatter_Scatter_2_Hwave.nc", "r")
  X = f->X2D
  Y = f->Y2D
  Vtot = f->canvas
  stride=20
  spacing=0.025
  minValue=min(Vtot)
  maxValue=2
  wks  = gsn_open_wks ("pdf","Scatter_2_Hwave")
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
  vres1@lbOrientation        = "Vertical"     ; Vertical label bar
  vres1@lbLabelStrings = LLabel
  vres1@cnLevelSelectionMode = "ManualLevels"     ; set manual contour levels
  vres1@cnMinLevelValF       = minValue                ; set min contour level
  vres1@cnMaxLevelValF       = maxValue              ; set max contour level
  vres1@cnLevelSpacingF      = spacing                 ; set contour spacing
  vres1@pmLabelBarOrthogonalPosF = -0.01          ; move label bar closer
  ;  vres1@pmLabelBarDisplayMode = "Always"          ; Turn on a label bar.
  vres1@lbPerimOn             = False             ; no box around it
  vres1@lbBoxLinesOn         = False               ; Yes/No labelbar box lines.
  vres1@tiXAxisString  = "Data (m)"
  vres1@tiYAxisString    = "Model (m)"
  vres1@tiXAxisOffsetYF = 0.0
  ; vres1@tmYLPrecision = 0
  ; First part Hwave
  vres1@sfXArray            = X
  vres1@sfYArray            = Y
  vres1@trGridType          = "TriangularMesh"
  ;  vres1@trGridType         = "curvilinear"
  plot = gsn_csm_contour(wks,Vtot,vres1)
  resP = True
  resP@gsLineThicknessF = 1.5
  resP@gsLineColor  = "black"
  resP@tfPolyDrawOrder = "PostDraw"
  xp=(/-180, 180/)
  yp=(/-180, 180/)
  line0=gsn_add_polyline(wks,plot,xp,yp,resP)
  data_rangeA = f->data_rangeA
  data_rangeB = f->data_rangeB
  line1=gsn_add_polyline(wks,plot,data_rangeA,data_rangeB,resP)
  txresB             = True
  txresB@txFontHeightF = 0.03
  txresB@txFontColor = "black"
  strLeft=""
  strMid="(b) 6101629 m=0.84 c=0.79 s=0.56"
  strRight=""
  subtitles(wks, plot, strLeft, strMid, strRight, txresB)
  draw(plot)
  frame(wks)
end
