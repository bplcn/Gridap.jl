module AutodiffTests

using Gridap.Arrays

function user_cell_energy(cell_u)
  function f(u)
    e = zero(eltype(u))
    for ui in u
      e += ui^2
    end
    e
  end
  apply(f,cell_u)
end

function user_cell_residual(cell_u)
  function f(u)
    r = copy(u)
    r .= zero(eltype(u))
    for (i,ui) in enumerate(u)
      r[i] = 2*ui
    end
    r
  end
  apply(f,cell_u)
end

function user_cell_jacobian(cell_u)
  function f(u)
    n = length(u)
    j = zeros(n,n)
    for i in 1:n
      j[i,i] = 2
    end
    j
  end
  apply(f,cell_u)
end

l = 10
cell_u = [ rand(3) for i in 1:l ]

cell_e = user_cell_energy(cell_u)
cell_r = user_cell_residual(cell_u)
cell_j = user_cell_jacobian(cell_u)
cell_h = cell_j

cell_r_auto = autodiff_array_gradient(user_cell_energy,cell_u)
cell_j_auto = autodiff_array_jacobian(user_cell_residual,cell_u)
cell_h_auto = autodiff_array_hessian(user_cell_energy,cell_u)

test_array(cell_r_auto,cell_r)
test_array(cell_j_auto,cell_j)
test_array(cell_h_auto,cell_h)

end # module