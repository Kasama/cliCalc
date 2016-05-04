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
	gcc -std=c90 -lfl -o $(OUT) $(OBJS)

$(DOTLEX): $(LEXFILE)
	lex $(LEXFILE)

$(DOTYACCC): $(YACCFILE)
	yacc --warnings=all -y -d -v $(YACCFILE)

.PHONY: clean

clean:
	rm $(OBJS) $(OUT) $(DOTYACCC) y.output
