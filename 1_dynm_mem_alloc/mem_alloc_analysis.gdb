>>> gcc -m32 -g dynm_mem_alloc.c -o dynm_mem_alloc
>>> gdb ./dynm_mem_alloc
GNU gdb (Ubuntu 7.11.1-0ubuntu1~16.5) 7.11.1
Copyright (C) 2016 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.  Type "show copying"
and "show warranty" for details.
This GDB was configured as "x86_64-linux-gnu".
Type "show configuration" for configuration details.
For bug reporting instructions, please see:
<http://www.gnu.org/software/gdb/bugs/>.
Find the GDB manual and other documentation resources online at:
<http://www.gnu.org/software/gdb/documentation/>.
For help, type "help".
Type "apropos word" to search for commands related to "word"...
Reading symbols from ./dynm_mem_alloc...done.
Reading in symbols for dynm_mem_alloc.c...done.
(gdb) 
(gdb) dir /usr/src/glibc/glibc-2.23/malloc
Source directories searched: /usr/src/glibc/glibc-2.23/malloc:$cdir:$cwd
(gdb) b main
Breakpoint 1 at 0x804844c: file dynm_mem_alloc.c, line 135.
(gdb) b malloc.c:3921
No source file named malloc.c.
Make breakpoint pending on future shared library load? (y or [n]) y
Breakpoint 2 (malloc.c:3921) pending.
(gdb) list
121	
122	                               { prev + size: 8,
123	                               PREV_INUSE Flag(0x1): 1,
124	                               MALLOC Aligned: 24 (3 * (2 * WORD_SIZE))}
125	
126	   9.             29                    41                                                      32  
127	
128	                               { prev + size: 8,
129	                               PREV_INUSE Flag(0x1): 1,
130	                               MALLOC Aligned: 32 (4 * (2 * WORD_SIZE))}
(gdb) b malloc
Breakpoint 3 at 0x8048310
(gdb) r
Reading symbols from /lib/ld-linux.so.2...Reading symbols from /usr/lib/debug//lib/i386-linux-gnu/ld-2.23.so...done.
done.
Reading in symbols for dl-minimal.c...done.
Reading in symbols for rtld.c...done.
Reading symbols from system-supplied DSO at 0xf7fd8000...(no debugging symbols found)...done.

Breakpoint 3, malloc (n=749) at dl-minimal.c:94
94	dl-minimal.c: No such file or directory.
(gdb) info symbol malloc
malloc in section .text of /lib/ld-linux.so.2
(gdb) info functions malloc
All functions matching regular expression "malloc":

File dl-minimal.c:
void *malloc(size_t);

Non-debugging symbols:
0x08048310  malloc@plt
0xf7fd9820  malloc@plt
(gdb) c
Continuing.

Breakpoint 3, malloc (n=621) at dl-minimal.c:94
94	in dl-minimal.c
(gdb) c
Continuing.

Breakpoint 3, malloc (n=16) at dl-minimal.c:94
94	in dl-minimal.c
(gdb) c
Continuing.

Breakpoint 3, malloc (Reading in symbols for dl-hwcaps.c...done.
n=184) at dl-minimal.c:94
94	in dl-minimal.c
(gdb) c
Continuing.

Breakpoint 3, malloc (Reading in symbols for dl-load.c...done.
n=20) at dl-minimal.c:94
94	in dl-minimal.c
(gdb) c
Continuing.

Breakpoint 3, malloc (n=400) at dl-minimal.c:94
94	in dl-minimal.c
(gdb) c
Continuing.

Breakpoint 3, malloc (Reading in symbols for strdup.c...done.
n=30) at dl-minimal.c:94
94	in dl-minimal.c
(gdb) c
Continuing.

Breakpoint 3, malloc (n=630) at dl-minimal.c:94
94	in dl-minimal.c
(gdb) c
Continuing.

Breakpoint 3, malloc (Reading in symbols for dl-object.c...done.
n=30) at dl-minimal.c:94
94	in dl-minimal.c
(gdb) c
Continuing.

Breakpoint 3, malloc (Reading in symbols for dl-deps.c...done.
n=20) at dl-minimal.c:94
94	in dl-minimal.c
(gdb) c
Continuing.

Breakpoint 3, malloc (n=28) at dl-minimal.c:94
94	in dl-minimal.c
(gdb) c
Continuing.

Breakpoint 3, malloc (n=48) at dl-minimal.c:94
94	in dl-minimal.c
(gdb) delete breakpoints 3
(gdb) c
Continuing.
Reading symbols from /lib/i386-linux-gnu/libc.so.6...Reading symbols from /usr/lib/debug//lib/i386-linux-gnu/libc-2.23.so...done.
done.
Reading in symbols for malloc.c...done.

Breakpoint 1, main () at dynm_mem_alloc.c:135
135	   char *ptr = NULL;
(gdb) c
Continuing.

Breakpoint 2, _int_free (av=0xf7fc7780 <main_arena>, p=0x804b000, have_lock=0) at malloc.c:3921
3921	    free_perturb (chunk2mem(p), size - 2 * SIZE_SZ);
(gdb) list
3916		    (void)mutex_unlock(&av->mutex);
3917		    locked = 0;
3918		  }
3919	      }
3920	
3921	    free_perturb (chunk2mem(p), size - 2 * SIZE_SZ);
3922	
3923	    set_fastchunks(av);
3924	    unsigned int idx = fastbin_index(size);
3925	    fb = &fastbin (av, idx);
(gdb) set print pretty on
(gdb) p *p
$1 = {
  prev_size = 0, 
  size = 41, 
  fd = 0x0, 
  bk = 0x0, 
  fd_nextsize = 0x0, 
  bk_nextsize = 0x0
}
(gdb) p main::ptr
$2 = 0x804b008 ""
(gdb) p &p->fd
$3 = (struct malloc_chunk **) 0x804b008
(gdb) x/8xw 0x804b008-8
0x804b000:	0x00000000	0x00000029	0x00000000	0x00000000
0x804b010:	0x00000000	0x00000000	0x00000000	0x00000000
(gdb) p/d 0x29
$4 = 41
(gdb) b main:140
Note: breakpoint 1 also set at pc 0x804844c.
Breakpoint 4 at 0x804844c: file dynm_mem_alloc.c, line 135.
(gdb) si
0xf7e82b89	3921	    free_perturb (chunk2mem(p), size - 2 * SIZE_SZ);
(gdb) 
free_perturb (n=32, p=0x804b008 "") at malloc.c:1886
1886	  if (__glibc_unlikely (perturb_byte))
(gdb) list
1881	}
1882	
1883	static void
1884	free_perturb (char *p, size_t n)
1885	{
1886	  if (__glibc_unlikely (perturb_byte))
1887	    memset (p, perturb_byte, n);
1888	}
1889	
1890	
(gdb) p n
$5 = 32
(gdb) si
0xf7e82b91	1886	  if (__glibc_unlikely (perturb_byte))
(gdb) 
0xf7e82b97	1886	  if (__glibc_unlikely (perturb_byte))
(gdb) 
0xf7e82b99	1886	  if (__glibc_unlikely (perturb_byte))
(gdb) 
_int_free (av=0xf7fc7780 <main_arena>, p=0x804b000, have_lock=0) at malloc.c:3923
3923	    set_fastchunks(av);
(gdb) c
Continuing.
[Inferior 1 (process 17992) exited normally]
(gdb) delete breakpoints 
Delete all breakpoints? (y or n) y
(gdb) b dynm_mem_alloc.c:140
Breakpoint 5 at 0x8048471: file dynm_mem_alloc.c, line 140.
(gdb) r
Reading symbols from /lib/ld-linux.so.2...Reading symbols from /usr/lib/debug//lib/i386-linux-gnu/ld-2.23.so...done.
done.
Reading symbols from system-supplied DSO at 0xf7fd8000...(no debugging symbols found)...done.
Reading in symbols for rtld.c...done.
Reading symbols from /lib/i386-linux-gnu/libc.so.6...Reading symbols from /usr/lib/debug//lib/i386-linux-gnu/libc-2.23.so...done.
done.

Breakpoint 5, main () at dynm_mem_alloc.c:140
140	   return 0;
(gdb) p ptr
$6 = 0x804b008 ""
(gdb) x/8xw 0x804b008-4
0x804b004:	0x00000029	0x00000000	0x00000000	0x00000000
0x804b014:	0x00000000	0x00000000	0x00000000	0x00000000
(gdb) p/d 29
$7 = 29
(gdb) p/d 0x29
$8 = 41
(gdb) list
135	   char *ptr = NULL;
136	   ptr = (char *) malloc(sizeof(char) * 29);
137	
138	   free(ptr);
139	
140	   return 0;
141	}
(gdb) disassemble main
Dump of assembler code for function main:
   0x0804843b <+0>:	lea    ecx,[esp+0x4]
   0x0804843f <+4>:	and    esp,0xfffffff0
   0x08048442 <+7>:	push   DWORD PTR [ecx-0x4]
   0x08048445 <+10>:	push   ebp
   0x08048446 <+11>:	mov    ebp,esp
   0x08048448 <+13>:	push   ecx
   0x08048449 <+14>:	sub    esp,0x14
   0x0804844c <+17>:	mov    DWORD PTR [ebp-0xc],0x0
   0x08048453 <+24>:	sub    esp,0xc
   0x08048456 <+27>:	push   0x1d
   0x08048458 <+29>:	call   0x8048310 <malloc@plt>
   0x0804845d <+34>:	add    esp,0x10
   0x08048460 <+37>:	mov    DWORD PTR [ebp-0xc],eax
   0x08048463 <+40>:	sub    esp,0xc
   0x08048466 <+43>:	push   DWORD PTR [ebp-0xc]
   0x08048469 <+46>:	call   0x8048300 <free@plt>
   0x0804846e <+51>:	add    esp,0x10
=> 0x08048471 <+54>:	mov    eax,0x0
   0x08048476 <+59>:	mov    ecx,DWORD PTR [ebp-0x4]
   0x08048479 <+62>:	leave  
   0x0804847a <+63>:	lea    esp,[ecx-0x4]
   0x0804847d <+66>:	ret    
End of assembler dump.
(gdb) b *0x0804847d
Breakpoint 6 at 0x804847d: file dynm_mem_alloc.c, line 141.
(gdb) c
Continuing.

Breakpoint 6, 0x0804847d in main () at dynm_mem_alloc.c:141
141	}
(gdb) x/8xw 0x804b008-4
0x804b004:	0x00000029	0x00000000	0x00000000	0x00000000
0x804b014:	0x00000000	0x00000000	0x00000000	0x00000000
(gdb) p/d 0x29
$9 = 41
