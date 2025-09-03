function +(a::PolyVar, b::PolyVar)
    if a.name == b.name
        return RecursiveDensePolynomial{Int}(a.name,
            [RecursiveDensePolynomial{Int}("", [], true, 2)],
            false, zero(Int))
    elseif a.name < b.name
        return RecursiveDensePolynomial{Int}(b.name,
            [RecursiveDensePolynomial{Int}(a.name,
                    [zero(RecursiveDensePolynomial{Int}),
                        one(RecursiveDensePolynomial{Int})],
                    false, zero(Int)),
                one(RecursiveDensePolynomial{Int})],
            false, zero(Int))
    else
        return RecursiveDensePolynomial{Int}(a.name,
            [RecursiveDensePolynomial{Int}(b.name,
                    [zero(RecursiveDensePolynomial{Int}),
                        one(RecursiveDensePolynomial{Int})],
                    false, zero(Int)),
                one(RecursiveDensePolynomial{Int})],
            false, zero(Int))
    end
end

function *(a::PolyVar, b::PolyVar)
    if a.name == b.name
        return RecursiveDensePolynomial{Int}(a.name,
            [zero(RecursiveDensePolynomial{Int}),
                zero(RecursiveDensePolynomial{Int}),
                RecursiveDensePolynomial{Int}("", RecursiveDensePolynomial{Int}[], true, 1)],
            false, zero(Int))
    elseif a.name < b.name
        return RecursiveDensePolynomial{Int}(b.name,
            [zero(RecursiveDensePolynomial{Int}),
                RecursiveDensePolynomial{Int}(a.name,
                    [zero(RecursiveDensePolynomial{Int}),
                        one(RecursiveDensePolynomial{Int})],
                    false, zero(Int))],
            false, zero(Int))
    else
        return RecursiveDensePolynomial{Int}(a.name,
            [zero(RecursiveDensePolynomial{Int}),
                RecursiveDensePolynomial{Int}(b.name,
                    [zero(RecursiveDensePolynomial{Int}),
                        one(RecursiveDensePolynomial{Int})],
                    false, zero(Int))],
            false, zero(Int))
    end
end

function ^(a::PolyVar, n::Int)
    if n < 0
        throw(DomainError("Exponent must be non-negative"))
    end
    coefficients::Vector{RecursiveDensePolynomial{Int}} = [zero(RecursiveDensePolynomial{Int}) for _ in 1:n]
    push!(coefficients, one(RecursiveDensePolynomial{Int}))
    return RecursiveDensePolynomial{Int}(a.name,
        coefficients,
        false, zero(Int))
end