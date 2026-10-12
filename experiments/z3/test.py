from z3 import *
x, y = Ints('x y')
s = Solver()
s.add((x % 4) + 3 * (y / 2) > x - y)
print(s.sexpr())

print("---------------")
S = DeclareSort('S')
s = Const('s', S)
solve(ForAll(s, s != s))

print("---------------")
Z = IntSort()
B = BoolSort()
f = Function('f', B, Z)
g = Function('g', Z, B)
a = Bool('a')
solve(g(1+f(a)))
