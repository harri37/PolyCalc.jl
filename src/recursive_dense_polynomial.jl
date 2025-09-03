include("constants.jl")

struct RecursiveDensePolynomial{T} <: AbstractPolynomial{T}
    variable::String
    coeffs::Vector{RecursiveDensePolynomial{T}}
    isconst::Bool
    constvalue::T

    function RecursiveDensePolynomial{T}(variable::String, coeffs::Vector{RecursiveDensePolynomial{T}}, isconst::Bool, constvalue::T) where T
        new{T}(variable, coeffs, isconst, constvalue)
    end
end

function show(io::IO, ::MIME"text/plain", p::RecursiveDensePolynomial{T}) where T
    # Handle constant polynomials
    if p.isconst
        print(io, p.constvalue)
        return
    end

    # Handle empty coefficient list (should be zero)
    if isempty(p.coeffs)
        print(io, "0")
        return
    end

    first_term = true
    for (i, coeff) in enumerate(p.coeffs)
        # Skip zero coefficients (check if coefficient polynomial represents zero)
        if coeff.isconst && coeff.constvalue == 0
            continue
        end

        if !first_term
            print(io, " + ")
        end

        # Handle the coefficient
        if coeff.isconst
            # Coefficient is a constant
            if coeff.constvalue == 1 && i > 1
                # Don't print coefficient 1 for non-constant terms
            elseif coeff.constvalue == -1 && i > 1
                if first_term
                    print(io, "-")
                else
                    print(io, " - ")
                end
            else
                print(io, coeff.constvalue)
            end
        else
            # Coefficient is a polynomial - wrap in parentheses
            print(io, "(")
            show(io, MIME"text/plain"(), coeff)
            print(io, ")")
        end

        # Add variable and exponent for non-constant terms
        if i > 1
            print(io, p.variable)
            if i > 2  # Only add exponent for degree > 1
                exponent_string = ""
                for c in string(i - 1)
                    digit = parse(Int, c)
                    if digit + 1 <= length(EXPONENT_UNICODES)
                        exponent_string *= EXPONENT_UNICODES[digit]
                    else
                        exponent_string *= "^$(i-1)"  # Fallback for large exponents
                        break
                    end
                end
                print(io, exponent_string)
            end
        end

        first_term = false
    end

    # Handle case where all coefficients were zero
    if first_term
        print(io, "0")
    end
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