CC = gcc
CFLAGS = -pthread -Wall -Wextra -O2

TARGETS = counter reader

all: $(TARGETS)

counter: counter.c
	$(CC) $(CFLAGS) -o $@ $<

reader: reader.c
	$(CC) $(CFLAGS) -o $@ $<

clean:
	rm -f $(TARGETS)
