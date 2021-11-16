#define len 9
#define enroll 2
#define elem_sz 4

void _start()
{
    int _x[] = {1,2,3,4,5,6,7,31,9};
    int x2, x3, x4, x5, x31;

    int *x1 = _x;
    int *x20 = x1 + len;
    x31 = x1[0];
    x1 += 1;

    do
    {
        x2 = x1[0];
        x3 = x1[1];
        if (x2>=x31)
            x31 = x2;
        if (x3>=x31)
            x31 = x3;
        x1 += enroll;
    } while(x1 != x20);

    x1 += enroll;

    while(1){}
}
