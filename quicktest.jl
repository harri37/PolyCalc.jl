using Pkg

Pkg.activate(".")
Pkg.instantiate()

using PolyCalc

x = PolyVar("x")
y = PolyVar("y")

println(expanded_form(x + y))
println(expanded_form(x * y))
println(expanded_form(x^3))
println(expanded_form(x * x))
println(expanded_form(2 * x + y))
println(expanded_form(2 * x))
println(expanded_form(2 * y))
println(expanded_form(2 * x + 2 * y))