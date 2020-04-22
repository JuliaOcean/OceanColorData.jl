using OceanColorData
using Test

@testset "OceanColorData.jl" begin

wvbd_out=[412, 443, 490, 510, 555, 670]
wvbd_in=[400,425,450,475,500,525,550,575,600,625,650,675,700]
rirr_in=1e-3*[23.7641,26.5037,27.9743,30.4914,28.1356,
    21.9385,18.6545,13.5100,5.6338,3.9272,2.9621,2.1865,1.8015]
rrs_ref=1e-3*[4.4099, 4.8533, 5.1247, 4.5137, 3.0864, 0.4064]
chla_ref=0.6101219875535429
fcm_ref=[5.683734365402806e-26, 4.958850399758996e-64, 2.0058235898296587e-43,
  2.399985306394786e-23, 1.0914931954631329e-15, 3.610712128260008e-8,
  0.06660122938880934, 0.4566726319832639, 0.001153891939362191, 5.901424234631198e-11,
  1.8433658038301877e-10, 0.4133547888920851, 0.027225883646784382, 0.005595266829573927]

rrs_out=RemotelySensedReflectance(rirr_in,wvbd_in,wvbd_out)
chla_out=RrsToChla(rrs_out; Eqn="OC4")
(M,Sinv)=Jackson2017()
fcm_out=FuzzyClassification(M,Sinv,rrs_out)

    @test isapprox(rrs_out,rrs_ref,atol=1e-5)
    @test isapprox(chla_out,chla_ref,atol=1e-5)
    @test isapprox(fcm_out,fcm_ref,atol=1e-5)
end
