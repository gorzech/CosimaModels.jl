struct NPendulum
    number_of_links::Int
    mass::Float64
    length::Float64
end

NPendulum(number_of_links) = NPendulum(number_of_links, 1.0, 1.0)
NPendulum() = NPendulum(1)

function create_system(p::NPendulum)
    m, l = p.mass, p.length
    b = Bodies()
    ground = RBody!(b, 1, ones(3))
    I_link_center = m * l^2 / 12
    Inertia = diagm([I_link_center / 1e3, I_link_center, I_link_center])
    link = RBody!(b, m, Inertia, [0.5l, 0, 0, 1, 0, 0, 0])

    joint_loc = [0.0, 0, 0]
    joints = [
        JointSimple(ground),  # Fix ground
        JointPoint(ground, link, joint_loc),  # Rotation between ground and dummy
        JointPerpend1(ground, link, [0, 1, 0], [0, 0, 1]),
        JointPerpend1(ground, link, [0, 1, 0], [1, 0, 0]),
    ]

    # add extra joints and bodies
    for i = 2:p.number_of_links
        q0_x = (i - 0.5) * l
        next_link = RBody!(b, m, Inertia, [q0_x, 0, 0, 1, 0, 0, 0])
        joint_loc[1] = (i - 1) * l
        append!(
            joints,
            [
                JointPoint(link, next_link, joint_loc),  # Rotation between ground and dummy
                JointPerpend1(link, next_link, [0, 1, 0], [0, 0, 1]),
                JointPerpend1(link, next_link, [0, 1, 0], [1, 0, 0]),
            ],
        )
    end

    return Mbs(b, joints, Force[], gv=[0, 0, -9.81])
end