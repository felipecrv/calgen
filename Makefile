
CONV=iconv -f UTF-8 -t ISO-8859-1 -o
MKD=mkdir -p
MAKE=make
RM=rm
INSTALL=install
SUDO=sudo
BASE_PATH=/usr/local/
STYLESHEETS=stylesheets/default.css stylesheets/food.css

all:
	$(MAKE) -C build

install: all
	$(SUDO) $(INSTALL) -T calgen $(BASE_PATH)bin/calgen
	$(SUDO) $(MKD) $(BASE_PATH)share/calgen/
	$(SUDO) $(MKD) $(BASE_PATH)share/calgen/stylesheets/
	$(SUDO) $(INSTALL) $(STYLESHEETS) $(BASE_PATH)share/calgen/stylesheets/

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
	$(RM) calgen
	$(RM) out.html
	$(RM) win32/calgen

force_look:
	true
