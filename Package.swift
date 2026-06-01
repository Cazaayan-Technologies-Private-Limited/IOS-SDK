// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "HemSdkQuickKyc",
    platforms: [.iOS(.v13)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "HemSdkQuickKyc",
            targets: ["HemSdkQuickKyc"]
        ),
    ],
    dependencies: [
        // ✅ Add DGCharts dependency here
        .package(url: "https://github.com/danielgindi/Charts.git", from: "5.1.0"),
        .package(url: "https://github.com/hackiftekhar/IQKeyboardManager.git", from: "6.5.0"),
        .package(url: "https://github.com/TimOliver/TOCropViewController.git",from: "2.0.0"),
        .package(url: "https://github.com/alankarmisra/SwiftSignatureView.git", exact: "3.2.1"),
        .package(url: "https://github.com/google/GoogleSignIn-iOS.git", from: "7.0.0")
    ],
    
    targets: [
        .target(
            name: "HemSdkQuickKyc",
            dependencies: [
                .product(name: "DGCharts", package: "Charts"),// ✅ Import DGCharts
                .product(name: "IQKeyboardManagerSwift", package: "IQKeyboardManager"),
                .product(name: "CropViewController", package: "TOCropViewController"),
                .product(name: "SwiftSignatureView", package: "SwiftSignatureView"),
                .product(name: "GoogleSignInSwift", package: "GoogleSignIn-iOS")
            ],
            resources: [
                .process("DashboardVC.storyboard"),
                .process("terms.storyboard"),
                .process("Nominee.storyboard"),
                .process("DigiLocker.storyboard"),
                .process("Assets.xcassets"),
                .process("TokenModel.xcdatamodeld"),
                .process("relationshipTVC.xib"),
                .process("TradingandDemat.storyboard"),
                .process("TradingandDematCVC.xib"),
                .process("Demat.storyboard"),
                .process("viewAllTVC.xib"),
                .process("BrokerageTVC.xib"),
                .process("BrokerageVC.storyboard"),
                .process("CommodityTVC.xib"),
                .process("popupValuecells.xib"),
                .process("Bank.storyboard"),
                .process("customTVC.xib"),
                .process("OtherDetails.storyboard"),
                .process("NomineeCVC.xib"),
                .process("Document.storyboard"),
                .process("incomeCVC.xib"),
                .process("RejectionCVC.xib"),
                .process("Rejection.storyboard"),
                .process("Esign.storyboard"),
                .process("ApplicationStatusVC.storyboard")
            ],
            swiftSettings: [
                .define("SWIFT_PACKAGE")
            ]
        ),
    ]
)
