
CONV=iconv -f UTF-8 -t ISO-8859-1 -o
MKD=mkdir -p
MAKE=make
RM=rm -f
RMDIR=rm -R
INSTALL=install
BASE_PATH=/usr/local/
STYLESHEETS=stylesheets/default.css stylesheets/food.css \
			stylesheets/classic.css stylesheets/dark.css \
			stylesheets/vintage.css stylesheets/clean.css
DIST_FILES=build/ src/ stylesheets/ www/ AUTHOR \
				 calgen Makefile README VERSION

all:
	$(MAKE) -C build

install:
	$(INSTALL) -T calgen $(BASE_PATH)bin/calgen
	$(MKD) $(BASE_PATH)share/calgen/
	$(MKD) $(BASE_PATH)share/calgen/stylesheets/
	$(INSTALL) $(STYLESHEETS) $(BASE_PATH)share/calgen/stylesheets/

unistall:
	$(RM) $(BASE_PATH)bin/calgen
	$(RMDIR) $(BASE_PATH)share/calgen

count:
	cat src/*.pas | wc -l

win32: force_look
	cp stylesheets/*.css win32/
	# win32 tem seu próprio Config.pas
	$(CONV) win32/src/CalendarUtils.pas src/CalendarUtils.pas
	$(CONV) win32/src/Generator.pas src/Generator.pas
	$(CONV) win32/src/Main.pas src/Main.pas
	
	$(MAKE) -C win32/build

clean:
	#$(RM) calgen
	$(RM) out.html
	#$(RM) win32/calgen
	$(RM) win32/out.html
	$(RM) build/*.o build/*.gpi
	$(RM) win32/build/*.o win32/build/*.gpi
	$(RM) *.tar.gz

dist: all win32 clean
	$(MKD) calgen-`cat VERSION`
	cp -R $(DIST_FILES) calgen-`cat VERSION`/
	tar -c calgen-`cat VERSION`/ | gzip > calgen-`cat VERSION`.tar.gz
	$(RMDIR) calgen-`cat VERSION`

force_look:
	true
