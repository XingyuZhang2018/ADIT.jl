using ADIT
using Random
using CUDA
using TeneT

#####################################    parameters      ###################################
Random.seed!(42)
atype = Array
Ni, Nj = 1, 1
D, χ = 2, 10
No = 50
S = 1.0
model = Kitaev(S,1.0,1.0,1.0)
Dz = 0.0
# method = :brickwall
method = :merge
folder = "data/$method/Dz$Dz/$model/$(Ni)x$(Nj)/"

boundary_alg = VUMPS(ifupdown=true,
                     ifdownfromup=false, 
                     ifsimple_eig=true,
                     maxiter=30, 
                     miniter=1,
                     maxiter_ad=0,
                     miniter_ad=0,
                     verbosity=3,
                     show_every=1
)
params = iPEPSOptimize{method}(boundary_alg=boundary_alg,
                               reuse_env=true, 
                               ifflatten=false,
                               verbosity=4, 
                               maxiter=1000,
                               tol=1e-10,
                               folder=folder
)
A = init_ipeps(;atype, model, params, No, D, χ, Ni, Nj)
# A = ADIT.init_ipeps_h5(;atype, params, ifWp=false, ifreal=true, model, file="./data/kitsShf_sikh3nfr1D4D4.h5", D, Ni, Nj)
############################################################################################

e, mag = observable(A, model, Dz, χ, params)
