:: Based on http://developer.covenanteyes.com/building-openssl-for-visual-studio/
set here=%~dp0
cd %here%\..
@echo Should anything go wrong, check that you have ActivePerl on your system (instead of mingw/cygwin perl).
@if exist openssl-1.0.1i (
	@echo Source already extracted, will simply rebuild
	cd openssl-1.0.1i
	goto skipConfigure
)
@if not exist openssl-1.0.1i.tar.gz (
	@echo You need to download openssl-1.0.1i.tar.gz from the official source and place it under the openssl directory.
	goto :eof
)

tar xzfv openssl-1.0.1i.tar.gz
cd openssl-1.0.1i
patch -p0 < ../Windows/tools.patch
:: Might fail since patch is non standard on Windows
@if %errorlevel%==9009 (
	echo "FAILED! You need the patch command."
	exit /b
)

perl Configure VC-WIN64A --prefix=Build-Win64
call ms\do_win64a

:skipConfigure
nmake -f ms\nt.mak tmp32 out32 inc32\openssl headers lib
mkdir -p ..\..\delivery\openssl\Win32\x64\include
mkdir -p ..\..\delivery\openssl\Win32\x64\lib
xcopy /D /E /C /R /I /K /Y inc32 ..\..\delivery\openssl\Win32\x64\include
copy out32\*.lib ..\..\delivery\openssl\Win32\x64\lib
copy tmp32\*.pdb ..\..\delivery\openssl\Win32\x64\lib
cd %here%
