#include <klee/klee.h>

int func(int x)
{
    int a = 10, b = 5;
    if (a + b > x)
        return 1;
    else
        return 0;
}

int main()
{
    int x;

    klee_make_symbolic(&x, sizeof(x), "x");

    int y = func(x);

    if (y == 1)
        x = 100;
    else
        x = 200;

    return 0;
}