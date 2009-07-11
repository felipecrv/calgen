
CONV=iconv -f UTF-8 -t ISO-8859-1 -o
MKD=mkdir -p
MAKE=make

all:
	$(MAKE) -C build

install: all
	#

count:
	cat src/*.pas | wc -l

win32: force_look
	#cp stylesheets/*.css win32/
	cp *.css win32/ # provisório

	# win32 tem seu próprio Config.pas
	$(CONV) win32/src/CalendarUtils.pas src/CalendarUtils.pas
	$(CONV) win32/src/Generator.pas src/Generator.pas
	$(CONV) win32/src/Main.pas src/Main.pas
	
	$(MAKE) -C win32/build

force_look:
	true
