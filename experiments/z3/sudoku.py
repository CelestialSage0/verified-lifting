from z3 import *

s = Solver()

cell = Function('cell', IntSort(), IntSort(), IntSort())

n = 3

## Domain
for i in range(0, n):
    for j in range(n):
        s.add(cell(i, j) <= n)
        s.add(cell(i, j) >= 1)

## Solving Rows
for i in range(n):
    for ji in range(n):
        for jj in range(ji+1, n):
            s.add(cell(i, ji) != cell(i, jj))

## Solving Columns
for j in range(n):
    for ii in range(n):
        for ij in range(ii+1, n):
            s.add(cell(ii, j) != cell(ij, j))

print(s.check())
print(s.model())
