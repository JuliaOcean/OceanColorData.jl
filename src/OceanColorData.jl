module OceanColorData

export RemotelySensedReflectance, RrsToChla

"""
    RemotelySensedReflectance(rirr_in,wvbd_in,wvbd_out)

Compute remotely sensed reflectance at wvbd_out from
irradiance reflectance at wvbd_in.

```
wvbd_out=Float64.([412, 443, 490, 510, 555, 670])
wvbd_in=Float64.([400,425,450,475,500,525,550,575,600,625,650,675,700])
rirr_in=1e-3*[23.7641,26.5037,27.9743,30.4914,28.1356,
    21.9385,18.6545,13.5100,5.6338,3.9272,2.9621,2.1865,1.8015]

rrs_out=RemotelySensedReflectance(rirr_in,wvbd_in,wvbd_out)

using Plots
plot(vec(rrs_out),linewidth=4,lab="recomputed RRS")
rrs_ref=1e-3*[4.4099, 4.8533, 5.1247, 4.5137, 3.0864, 0.4064]
plot!(rrs_ref,linewidth=4,ls=:dash,lab="reference result")

```
"""
function RemotelySensedReflectance(rirr_in,wvbd_in,wvbd_out)
    rrs_out=similar(wvbd_out)

    nin=length(wvbd_in)
    nout=length(wvbd_out)

    jj=Array{Int64,1}(undef,nin)
    ww=Array{Float64,1}(undef,nin)
    for ii=1:6
        tmp=wvbd_out[ii].-wvbd_in
        kk=maximum(findall(tmp.>=0))
        jj[ii]=kk
        ww[ii]=tmp[kk]/(wvbd_in[kk+1]-wvbd_in[kk])
    end

    tmp=rirr_in/3
    rrs_tmp=(0.52*tmp)./(1.0 .-1.7*tmp);

    rrs_out=Array{Float64,1}(undef,nout)
    for vv=1:6
        tmp0=rrs_tmp[jj[vv]]
        tmp1=rrs_tmp[jj[vv]+1]
        rrs_out[vv]=tmp0.*(1-ww[vv])+tmp1.*ww[vv]
    end

    return rrs_out
end


"""
    RrsToChla(Rrs)

Satellite `Chl_a` estimates typicaly derive from remotely sensed reflectances
using the blue/green reflectance ratio method and a polynomial formulation.

```
wvbd_out=Float64.([412, 443, 490, 510, 555, 670])
wvbd_in=Float64.([400,425,450,475,500,525,550,575,600,625,650,675,700])
rirr_in=1e-3*[23.7641,26.5037,27.9743,30.4914,28.1356,
    21.9385,18.6545,13.5100,5.6338,3.9272,2.9621,2.1865,1.8015]

rrs_out=RemotelySensedReflectance(rirr_in,wvbd_in,wvbd_out)
chla_out=RrsToChla(rrs_out; Eqn=1)
```
"""
function RrsToChla(Rrs;Eqn=1)
    RRSB=max.(Rrs[2],Rrs[3]) #blue
    RRSG=Rrs[5] #green
    X = log10.(RRSB./RRSG) #ratio of blue to green

    if Eqn==1
        C=[0.3272, -2.9940, +2.7218, -1.2259, -0.5683] #OC4 algorithms (SeaWifs, CCI)
    else
        error("this case has not been implemented yet...")
    end

    a0=C[1]; a1=C[2]; a2=C[3]; a3=C[4]; a4=C[5];
    chld=exp10.(a0.+a1*X+a2*X.^2+a3*X.^3+a4*X.^4); #apply polynomial recipe
end

end # module
