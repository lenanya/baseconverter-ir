all: main main.exe

main: main.ll
	clang main.ll -o main

main.exe: main.ll
	clang -target x86_64-w64-mingw32 -c main.ll -o main_win.obj && x86_64-w64-mingw32-gcc main_win.obj -o main.exe && rm main_win.obj
