all: main

main: main.ll
	clang -mllvm -opaque-pointers main.ll -o main
