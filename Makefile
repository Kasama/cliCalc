DOTLEX = lex.yy.c
DOTYACC = y.tab
DOTYACCC = $(DOTYACC).c
DOTYACCH = $(DOTYACC).h
OBJS = $(DOTYACCC) $(DOTLEX)
NAME = calc
LEXFILE = $(NAME).l
YACCFILE = $(NAME).y
OUT = main

all: $(OBJS)
	gcc -lfl -o $(OUT) $(OBJS)

$(DOTLEX): $(LEXFILE)
	lex $(LEXFILE)

$(DOTYACC): $(YACCFILE)
	yacc -d -v $(YACCFILE)

.PHONY: clean

clean:
	rm $(OBJS) $(OUT) $(DOTYACCC) y.output
