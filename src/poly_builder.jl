# Additions 
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

function +(a::PolyVar, b::RecursiveDensePolynomial{T}) where T
    new_poly = copy(b)
    if a.name == b.variable
        new_poly.coeffs[2] = new_poly.coeffs[2] + one(RecursiveDensePolynomial{T})
        return new_poly
    end
    prev = new_poly
    curr = new_poly
    while curr.variable < a.name && !curr.isconst
        prev = curr
        curr = curr.coeffs[1]
    end
    if curr.variable == a.name
        curr.coeffs[1] = curr.coeffs[1] + one(RecursiveDensePolynomial{T})
        return new_poly
    elseif curr.variable > a.name || curr.isconst
        prev_connection = prev.coeffs[1]
        new_var_poly = RecursiveDensePolynomial{T}(a.name,
            [prev_connection,
                one(RecursiveDensePolynomial{T})],
            false, zero(T))
        prev.coeffs[1] = new_var_poly
    end
    return new_poly
end

function +(a::RecursiveDensePolynomial{T}, b::PolyVar) where T
    return b + a
end

function +(a::PolyVar, b::T) where T
    return RecursiveDensePolynomial{T}(a.name,
        [RecursiveDensePolynomial{T}("", [], true, b),
            one(RecursiveDensePolynomial{T})],
        false, zero(T))
end

function +(a::T, b::PolyVar) where T
    return b + a
end

function +(a::RecursiveDensePolynomial{T}, b::RecursiveDensePolynomial{T}) where T
    println("Adding two polynomials")
    if a.isconst && b.isconst
        println("Adding constant polynomials")
        return RecursiveDensePolynomial{T}("", RecursiveDensePolynomial{T}[], true, a.constvalue + b.constvalue)
    elseif a.isconst
        println("Adding constant polynomial to variable polynomial")
        return b + a.constvalue
    elseif b.isconst
        println("Adding variable polynomial to constant polynomial")
        return a + b.constvalue
    elseif a.variable == b.variable
        max_len = max(length(a.coeffs), length(b.coeffs))
        new_coeffs = Vector{RecursiveDensePolynomial{T}}(undef, max_len)
        for i in 1:max_len
            coeff_a = i <= length(a.coeffs) ? a.coeffs[i] : zero(RecursiveDensePolynomial{T})
            coeff_b = i <= length(b.coeffs) ? b.coeffs[i] : zero(RecursiveDensePolynomial{T})
            new_coeffs[i] = coeff_a + coeff_b
        end
        println("Adding coefficients of variable $(a.variable)")
        return RecursiveDensePolynomial{T}(a.variable, new_coeffs, false, zero(T))
    elseif a.variable < b.variable
        new_poly = copy(a)
        prev = new_poly
        curr = new_poly
        while curr.variable < b.variable && !curr.isconst
            prev = curr
            curr = curr.coeffs[1]
        end
        if curr.variable == b.variable
            curr.coeffs = (curr + b).coeffs
        elseif curr.variable > b.variable || curr.isconst
            prev_connection = prev.coeffs[1]
            # WRONG
            new_var_poly = RecursiveDensePolynomial{T}(b.variable,
                [prev_connection + b.coeffs[1],
                    b.coeffs[2:end]...],
                false, zero(T))
            prev.coeffs[1] = new_var_poly
        end
        println("Inserted polynomial with variable $(b.variable) into polynomial with variable $(a.variable)")
        return new_poly
    else # a.variable > b.variable
        println("Swapping")
        return b + a
    end
end

# Subtractions
function -(a::PolyVar, b::PolyVar)
    return a + (-1 * b)
end

function -(a::PolyVar, b::RecursiveDensePolynomial{T}) where T
    return a + (-1 * b)
end

function -(a::RecursiveDensePolynomial{T}, b::PolyVar) where T
    return a + (-1 * b)
end

function -(a::PolyVar, b::T) where T
    return a + (-b)
end

function -(a::T, b::PolyVar) where T
    return a + (-1 * b)
end

function -(a::RecursiveDensePolynomial{T}, b::RecursiveDensePolynomial{T}) where T
    return a + (-1 * b)
end

# Multiplications
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

#Negations
function -(a::PolyVar)
    return -1 * a
end

function -(a::RecursiveDensePolynomial{T}) where T
    return -1 * a
end

# Multiplications
function *(a::PolyVar, b::RecursiveDensePolynomial{T}) where T
    new_poly = copy(b)
    if a.name == b.variable
        # Multiply each coefficient by the variable
        new_coeffs = Vector{RecursiveDensePolynomial{T}}(undef, length(new_poly.coeffs) + 1)
        new_coeffs[1] = zero(RecursiveDensePolynomial{T})
        for i in 1:length(new_poly.coeffs)
            new_coeffs[i+1] = new_poly.coeffs[i]
        end
        new_poly.coeffs = new_coeffs
        return new_poly
    elseif a.name < b.variable
        return RecursiveDensePolynomial{T}(b.variable,
            [zero(RecursiveDensePolynomial{T}),
                new_poly.coeffs...],
            false, zero(T))
    else
        for i in 1:length(new_poly.coeffs)
            new_poly.coeffs[i] = a * new_poly.coeffs[i]
        end
        return new_poly
    end
end

function *(a::RecursiveDensePolynomial{T}, b::PolyVar) where T
    return b * a
end

function *(a::PolyVar, b::T) where T
    return RecursiveDensePolynomial{T}(a.name,
        [zero(RecursiveDensePolynomial{T}),
            RecursiveDensePolynomial{T}("", RecursiveDensePolynomial{T}[], true, b)],
        false, zero(T))
end

function *(a::T, b::PolyVar) where T
    return b * a
end

function *(a::RecursiveDensePolynomial{T}, b::RecursiveDensePolynomial{T}) where T
    if a.isconst && b.isconst
        return RecursiveDensePolynomial{T}("", RecursiveDensePolynomial{T}[], true, a.constvalue * b.constvalue)
    end
    if a.isconst
        if a.constvalue == zero(T)
            return zero(RecursiveDensePolynomial{T})
        elseif a.constvalue == one(T)
            return b
        else
            new_coeffs = [a.constvalue * coeff for coeff in b.coeffs]
            return RecursiveDensePolynomial{T}(b.variable, new_coeffs, b.isconst, a.constvalue * b.constvalue)
        end
    elseif b.isconst
        if b.constvalue == zero(T)
            return zero(RecursiveDensePolynomial{T})
        elseif b.constvalue == one(T)
            return a
        else
            new_coeffs = [b.constvalue * coeff for coeff in a.coeffs]
            return RecursiveDensePolynomial{T}(a.variable, new_coeffs, a.isconst, a.constvalue * b.constvalue)
        end
    elseif a.variable == b.variable
        max_len = length(a.coeffs) + length(b.coeffs) - 1
        new_coeffs = [zero(RecursiveDensePolynomial{T}) for _ in 1:max_len]
        for i in 1:length(a.coeffs)
            for j in 1:length(b.coeffs)
                new_coeffs[i+j-1] = new_coeffs[i+j-1] + (a.coeffs[i] * b.coeffs[j])
            end
        end
        return RecursiveDensePolynomial{T}(a.variable, new_coeffs, false, zero(T))
    elseif a.variable < b.variable
        new_coeffs = [zero(RecursiveDensePolynomial{T}) for _ in 1:length(b.coeffs)]
        for i in 1:length(b.coeffs)
            new_coeffs[i] = a * b.coeffs[i]
        end
        return RecursiveDensePolynomial{T}(b.variable, new_coeffs, b.isconst, zero(T))
    else # a.variable > b.variable
        return b * a
    end
end

function *(a::RecursiveDensePolynomial{T}, b::T) where T
    if b == zero(T)
        return zero(RecursiveDensePolynomial{T})
    elseif b == one(T)
        return a
    elseif b.isconst
        return RecursiveDensePolynomial{T}(a.variable,
            [], true, a.constvalue * b)
    else
        new_coeffs = [b * coeff for coeff in a.coeffs]
        return RecursiveDensePolynomial{T}(a.variable, new_coeffs, false, zero(T))
    end
end

# Exponentiations
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

function ^(a::RecursiveDensePolynomial{T}, n::Int) where T
    if n < 0
        throw(DomainError("Exponent must be non-negative"))
    elseif n == 0
        return one(RecursiveDensePolynomial{T})
    elseif n == 1
        return a
    else
        result = copy(a)
        for _ in 2:n
            result = result * a
        end
        return result
    end
end
