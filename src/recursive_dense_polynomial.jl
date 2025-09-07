include("constants.jl")

struct RecursiveDensePolynomial{T}
    variable::String
    coeffs::Vector{RecursiveDensePolynomial{T}}
    isconst::Bool
    constvalue::T

    function RecursiveDensePolynomial{T}(variable::String, coeffs::Vector{RecursiveDensePolynomial{T}}, isconst::Bool, constvalue::T) where T
        new{T}(variable, coeffs, isconst, constvalue)
    end
end

function expanded_form(poly::RecursiveDensePolynomial{T})::String where T
    if poly.isconst
        if poly.constvalue == one(T)
            return ""
        end
        return string(poly.constvalue)
    end
    terms = String[]
    for (i, coeff) in enumerate(poly.coeffs)
        exp_str = ""
        if i > 2
            for c in string(i - 1)
                digit = parse(Int, c)
                exp_str *= EXPONENT_UNICODES[digit]

            end
        end
        push!(terms, expanded_form(coeff) * (i > 1 ? "$(poly.variable)$exp_str" : ""))
    end
    terms = filter(t -> !startswith(t, "0"), terms)
    result = ""
    for term in terms
        if isempty(result)
            result *= term
        elseif startswith(term, "-")
            result *= " - " * lstrip(term, '-')
        else
            result *= " + " * term
        end
    end
    return result
end


function show(io::IO, ::MIME"text/plain", p::RecursiveDensePolynomial{T}) where T
    print(io, expanded_form(p))
end

function zero(::Type{RecursiveDensePolynomial{T}}) where T
    return RecursiveDensePolynomial{T}("", RecursiveDensePolynomial{T}[],
        true, zero(T))
end

function one(::Type{RecursiveDensePolynomial{T}}) where T
    return RecursiveDensePolynomial{T}("", RecursiveDensePolynomial{T}[],
        true, one(T))
end

function copy(p::RecursiveDensePolynomial{T}) where T
    return RecursiveDensePolynomial{T}(p.variable, RecursiveDensePolynomial{T}[copy(c) for c in p.coeffs], p.isconst, p.constvalue)
end