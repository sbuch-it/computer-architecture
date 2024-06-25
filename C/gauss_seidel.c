#define N 3 
#define MAXITER 20 
#define EPSILON 0.0001 
 
float A[N*N] = {  4.0, -1.0, -1.0, 
                 -2.0,  6.0,  1.0, 
                 -1.0,  1.0,  7.0 }; 
float B[N]   = {  3.0,  9.0, -6.0 }; 
float e2, x[N], y[N], c[N], R[N*N], T[N*N]; 
int iter = 0; 
 
void setup() { 
   int i, j, k; 
   float t; 
   for (i = 0; i < N; ++i) { 
      x[i] = 0.0; 
      for (j = 0; j < N; ++j) { 
         t = 0.0; 
         if (i>j) for (k = j; k < i; ++k) 
            t -= A[i*N+k] * T[k*N+j]; 
         if (i==j) t = 1.0; 
         T[i*N+j] = (i<j) ? 0.0 : t / A[i*N+i]; 
      } 
   } 
   for (i = 0; i < N; ++i) { 
      for (j = 0; j < N; ++j) { 
         t = 0.0;
         for (k = 0; k < N; ++k) 
            if (k<j) t += T[i*N+k] * A[k*N+j]; 
         R[i*N+j] = t; 
      } 
      t = 0.0; 
      for (k = 0; k < N; ++k) 
         t += B[k] * T[i*N+k]; 
      c[i] = t; 
   } 
} 
 
void seidel2(float *x, float *y, float *a, float c) { 
   int j; 
   *x = c; 
   for (j = 0; j < N; ++j) *x -= a[j] * y[j]; 
} 
 
void report() { 
    int i; 
    print_string("X: "); 
    for (i = 0; i < N; ++i) { 
       print_float(x[i]); print_string(" "); 
    } 
    print_string(" - iter="); print_int(iter); 
    print_string("  e2="); print_float(e2); 
    print_string("\n"); 
}

int test_convergence() { 
    int j, r; 
    ++iter; e2 = 0; 
    for (j = 0; j < N; ++j) 
       e2 += (y[j] - x[j]) * (y[j] - x[j]); 
    r = (e2 < (EPSILON * EPSILON) || iter == MAXITER); 
    report(); 
    return r; 
 
} 

void compute() { 
    int i; 
    do { 
      for(i=0;i<N;++i) seidel2(&y[i], x, &R[N*i], c[i]); 
      for(i=0;i<N;++i) seidel2(&x[i], y, &R[N*i], c[i]); 
    } while (!test_convergence()); 
} 

int main() { 
   setup(); compute(); report(); exit(0); 
}