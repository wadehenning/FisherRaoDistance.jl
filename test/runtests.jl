using FisherRaoDistance
using Test

sum(sum(calc_vec_dist(ones(5,10))))

@testset "FisherRaoDistance.jl" begin

    @test sum(sum(calc_vec_dist(ones(5,10))))==0.00
    
end
