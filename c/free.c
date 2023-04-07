typedef struct header { 
   struct header *ptr; unsigned size; 
} Header; 
static Header base = {NULL,0 }; 
static Header *freep = NULL; 
 
void myfree(void *ap) { 
   Header *bp, *p;  bp = (Header *)ap - 1; 
   for (p = freep; !(bp > p && bp < p->ptr); p = p->ptr) { 
       if (p >= p->ptr && (bp > p || bp < p->ptr)) break; 
   } 
   if (bp + bp->size == p->ptr) { 
      bp->size += p->ptr->size; 
      bp->ptr = p->ptr->ptr; 
   } else bp->ptr = p->ptr; 
   if (p + p->size == bp) { 
      p->size += bp->size; 
      p->ptr = bp->ptr; 
   } else p->ptr = bp; 
   freep = p; 
}

void *alloc_and_print_pun(int sz) { 
   void *p = sbrk(sz); 
   print_string("p="); 
   print_int(p); 
   print_string("\n"); 
   return (p); 
} 

int main() { 
   void *p0, *p1, *p2, *p3; 
   base.ptr = &base; freep=&base; 
   p0 = alloc_and_print_pun(0); 
   p1 = alloc_and_print_pun(256); 
   p2 = alloc_and_print_pun(256); 
   p3 = alloc_and_print_pun(256); 
   myfree(p1); myfree(p2); myfree(p3); 
   p0 = alloc_and_print_pun(0); 
}