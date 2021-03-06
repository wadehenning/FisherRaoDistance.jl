module FisherRaoDistance

using KernelDensityEstimate
using MultivariateStats
using StatsBase


export
    get_low_dim_points,
    calc_vec_dist,
    fisherraodistance,
    fisherraotest,
    transform, #from MultivariateStats
    kde!, #from package KernelDensityEstimate
    evaluateDualTree,
    sample



# source files
include("dfr_functions.jl")

end #module
