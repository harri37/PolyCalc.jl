module PolyCalc

# Write your package code here.
using MultivariatePolynomials
import Base: +, *, ^, zero, one, copy, show

include("poly_var.jl")
include("recursive_dense_polynomial.jl")
include("poly_builder.jl")

export PolyVar

end
