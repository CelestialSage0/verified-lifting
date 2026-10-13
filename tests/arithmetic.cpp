#include <klee/klee.h>

int main(void)
{
    int x;
    klee_make_symbolic(&x, sizeof(x), "x");

    if (x + 1 == 10)
    {
        return 1;
    }

    return 0;
}