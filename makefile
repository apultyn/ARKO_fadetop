EXEFILE = fadetop
OBJECTS = fadetop.o main.o
CCFMT = -m32
NASMFMT = -f elf32
CCOPT =
NASMOPT = -w+all

.c.o:
	cc -g $(CCFMT) $(CCOPT) -c $<

$(EXEFILE): $(OBJECTS)
	cc $(CCFMT) -o $@ $^

%.o: %.asm
	nasm -g $(NASMFMT) $(NASMOPT) -o $@ $<

clean:
	rm *.o $(EXEFILE)
