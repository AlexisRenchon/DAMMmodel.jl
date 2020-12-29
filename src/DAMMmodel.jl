module DAMMmodel

using Makie
using AbstractPlotting.MakieLayout
using UnicodeFun
using LsqFit
using CSV

include("DAMM.jl")
include("DAMM_param.jl")
include("Makie_DAMM.jl")
include("DAMM_LsqFit.jl")

end
