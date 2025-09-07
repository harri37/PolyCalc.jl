using PolyCalc
using Test

@testset "PolyCalc.jl" begin
    
    coeff_type = Int
    
    test_poly::RecursiveDensePolynomial{coeff_type} = RecursiveDensePolynomial("x", [], false, zero(coeff_type))
end
