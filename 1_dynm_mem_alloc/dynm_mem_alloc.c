#include<stdio.h>
#include<stdlib.h>
#include<string.h>

/*---------------------------------------------------------------------------------------------

								AUTHOR: Dheeraj Kakkar
								FILE Ref: glibc2.23/malloc/malloc.c
								Calling PATH:
									malloc() -> _libc_malloc -> _int_malloc -> sysmalloc()
									free()   -> _libc_free -> _int_free() 

----------------------------------------------------------------------------------------------*//*

								Analysis of Dynamic Memory Allocation

											malloc()/free() 

----------------------------------------------------------------------------------------------*//*

MALLOC CHUNK STRUCTURE:

	struct malloc_chunk {

		INTERNAL_SIZE_T      prev_size;  // Size of previous chunk (if free).  //
		INTERNAL_SIZE_T      size;       // Size in bytes, including overhead. //

		struct malloc_chunk* fd;         // double links -- used only if free. //
		struct malloc_chunk* bk;

		// Only used for large blocks: pointer to next larger size.  //
		struct malloc_chunk* fd_nextsize; // double links -- used only if free. //
		struct malloc_chunk* bk_nextsize;
	};

FEW POINTS:
   Maximum ( malloc_chunk -> 24 (2 long, 4 pointers))
   Minimum Chunk size is -> 16 (2 long, 2 pointers )
   1. prev_size (long) 
   2. size (long)
   3. fd ( mem addr which returned to user)
   4. bk

Examples:
	struct malloc_chunk *p; // Assume this is pointer

	p->size = (Malloc_aligned(bytes) + 1 (mem in use flags) + 2 long ints present in malloc_chunk struct)

	if malloc passed bytes are following ->

NOTE:
   1. mem2chunk(mem): (struct malloc_chunk *)(mem - 2 * WORD_SIZE(4 -> 32bit, 8 -> 64bit));

   2. chunk2mem(struct malloc_chunk *chunk): (char *)chunk + 2 * WORD_SIZE;

   3. MIN_CHUNK_SIZE: 16 bytes ( 4 pointers -> in 32 bit arch)

   4. WORD SIZE: ( 4 in 32 bit, 8 in 64 bit )

   5. From the below Analysis:
      
      a) MALLOC ALIGNED: (2 * WORD_SIZE)
      
      NOTES:
         1. Minimum Memory Allocated is Chunk Size (sizeof(struct malloc_chunk)).
         2. Memory Bytes which are freed are in format of MALLOC ALIGNED ( 2 * WORD_SIZE ).
         3. Memory allocation will be MALLOC ALIGNED ( 2 * WORD_SIZE ) but only after Memory bytes crosses threshold of (>WORD_SIZE (4th point))
         3. IF Malloc Bytes are just above WORD_SIZE counts (e.g 13, 21, 29 ) whole new ( 2 * WORD_SIZE Will be allocated ) check below
			4. For e.g. Memory bytes is 13 now it is more than 12 ( 1 * MALLOC ALIGNED (8 bytes) + WORD_SIZE) so it will alllocate more MALLOC_ALIGNED size (8 bytes).
			5. For e.g. Memory bytes is 21 now it is more than 20 ( 2 * MALLOC ALIGNED (8 bytes) + WORD_SIZE) so it will alllocate more MALLOC_ALIGNED size (8 bytes).
			6. For e.g. Memory bytes is 29 now it is more than 28 ( 3 * MALLOC ALIGNED (8 bytes) + WORD_SIZE) so it will alllocate more MALLOC_ALIGNED size (8 bytes).

ANALYSIS:

               Malloc            Chunk Header member                                Finally freed in _int_free
                Bytes                 p->size                                             Later Freed

   1.             8                     17                                                      8

                               { MIN_CHUNK_SIZE/(prev + size): 16(8 + 8),           { pointer -> (p + 2 * WORD_SIZE),
                               PREV_INUSE Flag ORed : 0x1}                          prev_size, size are skipped (8 bytes),
                                                                                    PREV_INUSE LSB bit subtracted. }
                                                                 
   2.             12                    17                                                      8                                             

                               { 2 * WORD_SIZE (prev + size): 8,
                               PREV_INUSE Flag(0x1): 1,
                               MALLOC Aligned: 8 (1 * (2 * WORD_SIZE))}


   3.             13                    25                                                      16

                               { 2 * WORD_SIZE (prev + size): 8,
                               PREV_INUSE Flag(0x1): 1,
                               MALLOC Aligned: 16 (2 * (2 * WORD_SIZE))}

   4.             18                    25                                                      16                                                                                               
                               { 2 * WORD_SIZE (prev + size): 8,
                               PREV_INUSE Flag(0x1): 1,
                               MALLOC Aligned: 16 (2 * (2 * WORD_SIZE))}

   5.             20                    25                                                      16
                     
                               { prev + size: 8,
                               PREV_INUSE Flag(0x1): 1,
                               MALLOC Aligned: 16 (2 * (2 * WORD_SIZE))}

   6.             21                    33                                                      24  

                               { prev + size: 8,
                               PREV_INUSE Flag(0x1): 1,
                               MALLOC Aligned: 24 (3 * (2 * WORD_SIZE))}

   7.             24                    33                                                      24  

                               { prev + size: 8,
                               PREV_INUSE Flag(0x1): 1,
                               MALLOC Aligned: 24 (3 * (2 * WORD_SIZE))}
                                   
   8.             28                    33                                                      24  

                               { prev + size: 8,
                               PREV_INUSE Flag(0x1): 1,
                               MALLOC Aligned: 24 (3 * (2 * WORD_SIZE))}

   9.             29                    41                                                      32  

                               { prev + size: 8,
                               PREV_INUSE Flag(0x1): 1,
                               MALLOC Aligned: 32 (4 * (2 * WORD_SIZE))}
*/

int main() {

   char *ptr = NULL;
   ptr = (char *) malloc(sizeof(char) * 29);

   free(ptr);

   return 0;
}
