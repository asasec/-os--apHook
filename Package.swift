let package: Package = .init(
    name: "Asasecİap",
    platforms: [.iOS(minFirmware)],
    products: [
        .library(
            name: "Asasecİap",
            targets: ["Asasecİap"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/Paisseon/Jinx.git", branch: "development")
    ],
    targets: [
        .target(
            name: "Asasecİap",
            dependencies: [
                .product(name: "Jinx", package: "Jinx")
            ],
            path: "Sources/asasecmod",
            sources: [
                "Tweak.swift",
                "Hooks",
                "İmgui",
                "Helper",
                "KittyMemory",
                "Listener"
            ],
            swiftSettings: [.unsafeFlags(swiftFlags)]
        )
    ]
)
