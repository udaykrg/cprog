UDAY.exe:main.o factorial.o biggest3.o reverse.o prime.o
	gcc -o UDAY.exe main.o factorial.o biggest3.o reverse.o prime.o
main.o:main.c
	gcc -c main.c
factorial.o:factorial.c
	gcc -c factorial.c
biggest3.o:biggest3.c
	gcc -c biggest3.c
reverse.o:reverse.c
	gcc -c reverse.c
prime.o:prime.c
	gcc -c prime.c

