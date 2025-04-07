#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <unistd.h>

int counter = 0;  // Shared global variable

void *thread_function() {
	while (1) {
		sleep(5);  // Wait for 5 seconds
		printf("[Thread] Counter: %d\n", counter);
	}
	return NULL;
}

int main() {
	pthread_t thread;

	pthread_create(&thread, NULL, thread_function, NULL);

	while (1) {
		sleep(5);  // Wait for 5 seconds
		counter++;
		printf("[Main] Counter: %d\n", counter);
	}

	pthread_join(thread, NULL);

	return 0;
}