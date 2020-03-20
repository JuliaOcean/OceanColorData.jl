using OceanColorData
using Test

@testset "OceanColorData.jl" begin

wvbd_out=[412, 443, 490, 510, 555, 670]
wvbd_in=[400,425,450,475,500,525,550,575,600,625,650,675,700]
rirr_in=1e-3*[23.7641,26.5037,27.9743,30.4914,28.1356,
    21.9385,18.6545,13.5100,5.6338,3.9272,2.9621,2.1865,1.8015]
rrs_ref=1e-3*[4.4099, 4.8533, 5.1247, 4.5137, 3.0864, 0.4064]

rrs_out=RemotelySensedReflectance(rirr_in,wvbd_in,wvbd_out)

    @test isapprox(rrs_out,rrs_ref,atol=1e-5)
end
