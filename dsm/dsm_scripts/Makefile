CC = gcc
CFLAGS = -O2

TARGETS = modifier

all: $(TARGETS)

counter: modifier.c
	$(CC) $(CFLAGS) -o $@ $<

clean:
	rm -f $(TARGETS)
