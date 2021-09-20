using DifferentialEquations, BenchmarkTools, StaticArrays

# out-of-place
function henon(u, p, t)
    dx = u[3]
    dy = u[4]
    dpx = -u[1] - 2u[1]*u[2]
    dpy = -u[2] - (u[1]^2 - u[2]^2)
    [dx, dy, dpx, dpy]
end


# in-place
function henon!(du, u, p, t)
    du[1] = u[3]
    du[2] = u[4]
    du[3] = -u[1] - 2u[1]*u[2]
    du[4] = -u[2] - (u[1]^2 - u[2]^2)
end


# out-of-place static
function henon_static(u, p, t)
    dx = u[3]
    dy = u[4]
    dpx = -u[1] - 2u[1]*u[2]
    dpy = -u[2] - (u[1]^2 - u[2]^2)
    @SVector [dx, dy, dpx, dpy]
end


# benchmark
u0 = [0, -0.25, 0.42081,0]
tspan = (0.0, 100.0)
prob_out = ODEProblem(henon, u0, tspan)
prob_in  = ODEProblem(henon!, u0, tspan)

@benchmark solve(prob_out)
@benchmark solve(prob_in)

u0 = @SVector [0, -0.25, 0.42081,0]
prob_out_static = ODEProblem(henon_static, u0, tspan)
@benchmark solve(prob_out_static)
