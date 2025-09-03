using Pkg

Pkg.activate(".")
Pkg.instantiate()

using PolyCalc

x = PolyVar("x")
y = PolyVar("y")

show(x + y)
println()
show(x * y)
println()
show(x^3)
println()
show(x * x)
println()