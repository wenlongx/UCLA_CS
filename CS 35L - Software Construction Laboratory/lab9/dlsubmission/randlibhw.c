#include "randlib.h"
#include <immintrin.h>

/* Hardware implementation.  */

/* Return a random value, using hardware operations.  */
extern long long
hardware_rand64 (void)
{
  unsigned long long int x;
  while (! _rdrand64_step (&x))
    continue;
  return x;
}
