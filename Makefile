all: bachelor 


bachelor: frontDP.md openWebDP.md
	pandoc frontDP.md -o frontDP.pdf
	pandoc openWebDP.md -o openWebDP.pdf 
	pdftk frontDP.pdf openWebDP.pdf cat output bachelor.pdf

clean: 
	rm -f *.pdf 
