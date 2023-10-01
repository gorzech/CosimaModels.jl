struct NPendulum
    number_of_links::Int
    mass::Float64
    length::Float64
end

NPendulum(number_of_links) = NPendulum(number_of_links, 1.0, 1.0)
NPendulum() = NPendulum(1)

function create_system(p::NPendulum)
    m, l = p.mass, p.length
    sys = Mbs(gv=[0, 0, -9.81])
    ground = RBody!(sys, 1, ones(3))
    I_link_center = m * l^2 / 12
    Inertia = diagm([I_link_center / 1e3, I_link_center, I_link_center])
    link = RBody!(sys, m, Inertia, [0.5l, 0, 0, 1, 0, 0, 0])

    joint_loc = [0.0, 0, 0]
    JointSimple!(sys, ground)  # Fix ground
    JointPoint!(sys, ground, link, joint_loc)  # Rotation between ground and dummy
    JointPerpend1!(sys, ground, link, [0, 1, 0], [0, 0, 1])
    JointPerpend1!(sys, ground, link, [0, 1, 0], [1, 0, 0])

    # add extra joints and bodies
    for i = 2:p.number_of_links
        q0_x = (i - 0.5) * l
        next_link = RBody!(sys, m, Inertia, [q0_x, 0, 0, 1, 0, 0, 0])
        joint_loc[1] = (i - 1) * l
        JointPoint!(sys, link, next_link, joint_loc)  # Rotation between ground and dummy
        JointPerpend1!(sys, link, next_link, [0, 1, 0], [0, 0, 1])
        JointPerpend1!(sys, link, next_link, [0, 1, 0], [1, 0, 0])
    end

    return sys
end