fp =   (R = 8.314472e-3, # Universal gas constant, kJ K-1 mol-1
	O2ₐ = 0.209, # volume of O2 in the air, L L-1
	BD = 1.5396, # Soil bulk density, g cm-3  
	PD = 2.52, # Soil particle density, g cm-3
	pₛₓ = 2.4e-2, # Fraction of soil C that is considered soluble
	Dₗᵢ = 3.17, # Diffusion coeff of substrate in liquid phase, dimensionless
	Dₒₐ = 1.67, # Diffusion coefficient of oxygen in air, dimensionless
	Sxₜₒₜ = 0.0125)

function DAMM(x, p, fp)
	porosity = 1-fp.BD/fp.PD # total porosity
     # Independent variables
	Tₛ = x[:, 1]
	θ = x[:, 2]
     # Parameters to fit
	Eaₛₓ = p[1]
	αₛₓ = p[2]
	kMₒ₂ = p[3]
	kMₛₓ = p[4]
     # DAMM model
	Sₓ = @. fp.Sxₜₒₜ * fp.Dₗᵢ * θ^3
	O2 = @. fp.Dₒₐ * fp.O2ₐ * ((porosity - θ)^(4/3))
	MMₛₓ = @. Sₓ / (kMₛₓ + Sₓ)
	MMₒ₂ = @. O2 / (kMₒ₂ + O2)
	Vmaxₛₓ = @. (αₛₓ * exp(-Eaₛₓ/(fp.R * (273.15 + Tₛ))))
	Resp = @. Vmaxₛₓ * MMₛₓ * MMₒ₂ * 2314.8148 # 2314 to convert mgC hr-1 to umol s-1
end

# test
x = [18.0 0.3; 22.0 0.22]
p = [62.0, 1e8, 2.0e-3, 3.46e-8]
DAMM(x, p, fp)

