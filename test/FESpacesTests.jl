using Numa, Test

using Numa.Quadratures
using Numa.Polytopes
using Numa.RefFEs
using Numa.Meshes
using Numa.FESpaces

using Numa.Polytopes: PointInt
using Numa.CellValues



#       1,2,3,4,5,6,7,8,9,0,1,2
data = [2,3,1,3,6,7,3,2,5,6,3,4]
ptrs = [1,4,4,7,13]

ca = CellVectorFromDataAndPtrs(data,ptrs)

@test length(ca) == length(ptrs)-1
@test ca[1] == data[1:3]
@test ca[2] == data[4:3]
@test ca[3] == data[4:6]
@test ca[4] == data[7:12]

# @santiagobadia : Consider a "constant pointer"

@test cellsize(ca) == (6,)


##
D = 2
nparts1d = 2
nparts = nparts1d*ones(Int64,D)
order=1
orders=order*ones(Int64,D)
extrusion = PointInt{D}(ones(Int64,D))
polytope = Polytopes.Polytope(extrusion)
reffe = LagrangianRefFE(polytope,orders)
mesh = StructHexMesh(nparts)
fesp = FESpace(reffe,mesh)
@test fesp.l2giddof[end][end]==(nparts1d+1)^D
##

##
# Vector FE space
D = 2
nparts1d = 2
nparts = nparts1d*ones(Int64,D)
order=2
orders=order*ones(Int64,D)
extrusion = PointInt{D}(ones(Int64,D))
polytope = Polytopes.Polytope(extrusion)
reffe = LagrangianRefFE(polytope,orders)
gps=[2,2]
quad=Quadratures.TensorProductQuadrature(orders = tuple(2*orders...))
shfscal = shfsps(reffe,quad.coords)
reffe = LagrangianRefFE(polytope,orders,2)
shftens = shfsps(reffe,quad.coords)
@test shftens[36,1,2,2]==shfscal[9,1,1]
##
points=quad.coords
reffe = LagrangianRefFE(polytope,orders,0)
gradscal = gradshfsps(reffe,points)
reffe = LagrangianRefFE(polytope,orders,1)
gradtens = gradshfsps(reffe,points)
@test gradtens[10,1,2,2]==gradscal[1,1,2]
@test gradtens[10,3,2,2]==gradscal[1,3,2]
@test gradtens[1,3,2,1]==gradscal[1,3,2]
@test gradtens[1,3,2,2]==0.0
@test gradtens[10,3,2,1]==0.0
##
