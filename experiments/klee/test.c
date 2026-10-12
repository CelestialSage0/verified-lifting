#include <klee/klee.h>

struct Packet
{
    int src;
    int dst;
};

int process(struct Packet *p)
{
    p->src = p->src + 5;
    if (p->src == 10)
        return 1;

    return 0;
}

int main()
{
    struct Packet p;

    klee_make_symbolic(&p, sizeof(p), "pkt");

    process(&p);
}