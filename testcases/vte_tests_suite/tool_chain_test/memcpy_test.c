/*
 * Copyright (C) 2011 Freescale Semiconductor, Inc. All Rights Reserved.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#include <sys/time.h>

#define MAX_LOOP 102400
#define BLOCK (1024*4)

void run_test( char * out, char * in)
{
	int i = 0;
	for (i = 0; i < MAX_LOOP; i++) {
	memcpy(out, in, BLOCK);
	}
}

void run_test_d( char * out, char * in)
{
	int i = 0;
	for (i = 0; i < MAX_LOOP; i++) {
	memcpy(out, in, BLOCK);
	}
}

int main()
{
	struct timeval start, end;
	struct timezone tz;
/*static array memory copy test*/
	static char to[BLOCK] __attribute((aligned(4)));
	static char from[BLOCK] __attribute((aligned(4)));
	unsigned long last = 0;
	char *pto, *pfrom;

  memset(from,1,BLOCK);
	gettimeofday(&start, &tz);
		run_test(to,from);
	//	memcpy(to, from, BLOCK);
	gettimeofday(&end, &tz);

	last = (end.tv_sec - start.tv_sec) * 1000 +
	    (end.tv_usec - start.tv_usec) / 1000;

	printf("test last %ld ms\n", last);
	if (last)
		printf("performance is %ldMB/s\n", (unsigned long)(BLOCK * MAX_LOOP) / (last * (1024 * 1024 / 1000)));

	pto = (char *)malloc(BLOCK);
	if (pto == NULL) {
		printf("malloc fail 1\n");
		return -1;
	}
	pfrom = (char *)malloc(BLOCK);
	if (pfrom == NULL) {
		printf("malloc fail 2 \n");
		return -1;
	}
  memset(from,1,BLOCK);
	gettimeofday(&start, &tz);
	//	memcpy(pto, pfrom, BLOCK);
	run_test_d(pto,pfrom);
	gettimeofday(&end, &tz);

	last = (end.tv_sec - start.tv_sec) * 1000 +
	    (end.tv_usec - start.tv_usec) / 1000;

	printf("dynamic test last %ld ms\n", last);
	if (last)
		printf("dynamic performance is %ld MB/s\n",
		       (unsigned long)(BLOCK * MAX_LOOP) / (last * (1024 * 1024 / 1000)));

  if(pto)
		free(pto);
	if(pfrom)
		free(pfrom);
/*dynamic allocate mempry copy*/
	return 0;
}
