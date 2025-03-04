#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <unistd.h>

int counter = 0;  // Shared global variable
pthread_mutex_t lock;

void *thread_function(void *arg) {
	while (1) {
		sleep(5);  // Wait for 5 seconds
		pthread_mutex_lock(&lock);
		counter++;
		printf("[Thread] Counter: %d\n", counter);
		pthread_mutex_unlock(&lock);
	}
	return NULL;
}

int main() {
	pthread_t thread;

	pthread_mutex_init(&lock, NULL);
	pthread_create(&thread, NULL, thread_function, NULL);

	while (1) {
		sleep(5);  // Wait for 5 seconds
		pthread_mutex_lock(&lock);
		counter++;
		printf("[Main] Counter: %d\n", counter);
		pthread_mutex_unlock(&lock);
	}

	pthread_join(thread, NULL);
	pthread_mutex_destroy(&lock);

	return 0;
}
