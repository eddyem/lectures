SRCS = $(wildcard *.tex)
PDFS = $(SRCS:.tex=.pdf)


all: $(PDFS)

%.pdf : %.tex
	latexmk --pdf $<

clean:
	rm -f *.aux *.log *.nav *.out *.snm *.vrb *.backup *.toc *~ *.fls *.fdb_latexmk
