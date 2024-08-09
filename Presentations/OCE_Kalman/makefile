EPS = $(wildcard *.eps)

%.dvi: %.tex $(EPS)
	( \
	\latex $<; \
	while \grep -q "Rerun to get cross-references right." $(<:.tex=.log); \
	do \
		\latex $<; \
	done \
	)

%.ps: %.dvi ; dvips $< -o $@

%.pdf: %.dvi ; dvi2pdf_Perso $<

TEX = $(wildcard *.tex)
DVI = $(patsubst %.tex,%.dvi, $(TEX))
PS  = $(patsubst %.dvi,%.ps, $(DVI))
PDF = $(patsubst %.ps,%.pdf, $(PS))
TOC = $(patsubst %.tex,%.toc, $(TEX))

all: $(DVI) $(PS) $(PDF)

clean:
	rm -f $(PS) $(DVI) $(PDF) $(TOC) *.log *.aux *.out
