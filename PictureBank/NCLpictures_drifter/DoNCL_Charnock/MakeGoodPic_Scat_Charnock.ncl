load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
begin

  f = addfile("Scatter_bulk_wave.nc", "r")
  maxWind = f->maxWind
  maxAlpha= f->maxAlpha
  uv = f->uv
  alpha_bulk = f->alpha_bulk
  alpha_wave = f->alpha_wave
  ns=dimsizes(uv)
  nb=ns(0)

  wks  = gsn_open_wks ("eps", "Charnock_Scatter_bulk_wave")
  vres1 = True               ; plot mods desired
  vres1@gsnDraw   = False
  vres1@gsnFrame  = False
  vres1@gsnMaximize     = False    ; Maximize plot in frame
  vres1@gsnPaperOrientation = "Portrait"

  vres1@trXMinF=0
  vres1@trXMaxF=maxWind

  vres1@trYMinF=0
  vres1@trYMaxF=maxAlpha
  vres1@tiXAxisString  = "Wind speed (m/s)"
  vres1@tiYAxisString    = "Charnock (nondimensional)"
  vres1@tiXAxisOffsetYF = 0.0
  vres1@tmYLPrecision=1

  plot=gsn_csm_blank_plot(wks, vres1)

  dum=new(nb, graphic)
  do iPair=0,nb-1
    eX=uv(iPair)
    eY=alpha_bulk(iPair)
    pmres = True
    pmres@gsMarkerColor = "red"
    pmres@gsMarkerIndex = 16
    pmres@gsMarkerSizeF = 0.002
    dum(iPair) = gsn_add_polymarker(wks, plot, eX, eY, pmres)
  end do

  dum2=new(nb, graphic)
  do iPair=0,nb-1
    eX=uv(iPair)
    eY=alpha_wave(iPair)
    pmres = True
    pmres@gsMarkerColor = "blue"
    pmres@gsMarkerIndex = 16
    pmres@gsMarkerSizeF = 0.002
    dum2(iPair) = gsn_add_polymarker(wks, plot, eX, eY, pmres)
  end do

  draw(plot)
  frame(wks)

end
