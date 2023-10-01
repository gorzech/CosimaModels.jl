struct SpatialSliderCrank
    q_crank::SVector{7,Float64}
    q_rod::SVector{7,Float64}
    q_cylinder::SVector{7,Float64}
    q_slider::SVector{7,Float64}
end

SpatialSliderCrank() = SpatialSliderCrank([0.0, 0.1, 0.16, 1.0, 0.0, 0.0, 0.0], 
        [0.09999999999999998, 0.05, 0.1, -0.9128709291792899, 0.0, -0.3651483716620847, 0.18257418583104235], 
        [0.19999999999999996, -0.0, -0.0, 1.0, 0.0, 0.0, 0.0], 
        [0.19999999999999996, -0.0, -0.0, 1.0, 0.0, 0.0, 0.0])

function create_system(p::SpatialSliderCrank)
    # %% Joints
    v_OA = SA[0.0, 0.1, 0.12]
    v_AB = SA[0.0, 0.0, 0.08]
    # 1 - revolute ground-crank (0-1)
    j_loc_1 = v_OA
    j_axis_1 = SA[1.0, 0.0, 0.0]
    # 2 - spherical crank - connecting rod at B (1-2)
    j_loc_2 = v_OA + v_AB
    # 3 - revolute rod - cylinder (2-3)
    j_loc_3 = p.q_cylinder[1:3]
    j_axis_3 = p.q_rod[5:end]  # this is an axis of rotation of body 2

    # 4 - revolute cylinder slider (3-4)
    j_axis_4 = j_axis_1
    # 5 - translational slider ground
    # modeled as simple joint except of x coordinate (that is body rotation and translation in y and z are restrickted)
    grav_z = -9.81
    sys = Mbs(gv=SA[0.0, 0.0, grav_z], baumg_params=(30.0, 30.0))
    ground = RBody!(sys, 1.0, ones(3))
    crank = RBody!(sys, 0.12, [1e-4, 1e-5, 1e-4], p.q_crank)
    slider = RBody!(sys, 2.0, [1e-4, 1e-4, 1e-4], p.q_slider)

    rod_length = 0.3
    rod_side_len = 0.01
    rod_density = 2710

    rod_V = rod_length * rod_side_len * rod_side_len # rod's volume
    m_rod = rod_density * rod_V
    Ic_rod =
        1 / 12 * m_rod .* (rod_side_len^2 .+ [rod_side_len^2, rod_length^2, rod_length^2])
    rod = RBody!(sys, m_rod, Ic_rod, p.q_rod)

    # # 1 - revolute ground-crank (0-1)
    JointPoint!(sys, ground, crank, j_loc_1)
    JointPerpend1!(sys, ground, crank, [0.0, 1.0, 0.0], j_axis_1)
    JointPerpend1!(sys, ground, crank, [0.0, 0.0, 1.0], j_axis_1)
    # # 2 - spherical crank - connecting rod at B (1-2)
    JointPoint!(sys, crank, rod, j_loc_2)
    # # 3 - revolute rod - slider (2-3)
    JointPoint!(sys, rod, slider, j_loc_3)
    JointPerpend1!(sys, rod, slider, [1.0, 0.0, 0.0], j_axis_3)
    JointPerpend1!(sys, rod, slider, cross([1.0, 0.0, 0.0], j_axis_3), j_axis_3)
    # # 5 - cylindrical slider ground
    JointSimple!(sys, slider, [2, 3], false) # false - do not fix rotation only y and z
    JointPerpend1!(sys, slider, ground, [0.0, 1.0, 0.0], j_axis_4)
    JointPerpend1!(sys, slider, ground, [0.0, 0.0, 1.0], j_axis_4)
    JointSimple!(sys, ground)

    return sys
end