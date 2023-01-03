# StoreKit Configuration File Demo

This is a demo Swift app to show how a StoreKit Configuration File can be used to with [RevenueCat](https://www.revenuecat.com/) and [StoreKit](https://developer.apple.com/storekit/) to test in-app purchases and subscriptions without needing to use App Store Connect.

## StoreKit Config File

This is already configured in this project but these were the steps take to create and use the [StoreKit Configuration File](https://developer.apple.com/documentation/xcode/setting-up-storekit-testing-in-xcode).

### Step 1: Create file

Creating a "StoreKit Configuration File" will prompt you with a checkbox for "Sync this file with an app in App Store Connect". This is new in Xcode 14 but was not enabled for _this_ project. This project is meant to run without needing to do anything on App Store Connect.

Syncing with App Store Connect is a great feature if/once you already have products configured and you don't want to manage your live products (in App Store Connect) and test products (in a StoreKit Configuration File) separately.

![Screen Shot 2023-01-03 at 5 47 23 AM](https://user-images.githubusercontent.com/401294/210351433-ec9ea8c5-7f2f-478c-b352-6d3ea11ff04d.png)

### Step 2: Add products

The StoreKit Configuration File allows you to create any number of:
- Consumable in-app purchases
- Non-consumable in-app purchases
- Non-renewing subscriptions
- Auto-renewable subscriptions

This project only added an lifetime non-consumable and two auto-renewable subscriptions.

![Screen Shot 2023-01-03 at 5 39 06 AM](https://user-images.githubusercontent.com/401294/210350236-2691af88-dd44-4404-bcfe-d27abaf2bc7d.png)

### Step 3: Enable in scheme

The Xcode scheme needs to be configured to load products from the StoreKit Configuration File. This can be done by selecting your file in the `Run > StoreKit Configuration`.

![Screen Shot 2023-01-03 at 5 45 23 AM](https://user-images.githubusercontent.com/401294/210351363-6f273050-f078-4615-aa2d-f08d63a0b780.png)

### Step 4: Running and debugging

Now the app is ready to load products and make test purchases using the StoreKit Configuration File and Xcode.

`Debug > StoreKit > Manage Transactions`

![Screen Shot 2023-01-03 at 5 58 35 AM](https://user-images.githubusercontent.com/401294/210352972-a9969d68-ed54-4c81-b744-f9b498c56b64.png)

## Demo

The demo app is contains a separate view for each implementation:
- [RevenueCatView](https://github.com/joshdholtz/storekit-config-file-demo/blob/main/StoreKitConfigDemo/Views/RevenueCatView.swift)
- [StoreKitView](https://github.com/joshdholtz/storekit-config-file-demo/blob/main/StoreKitConfigDemo/Views/StoreKitView.swift)

Both work with the StoreKit Configuration File 

### RevenueCat

```swift
struct RevenueCatView: View {
    @State private var offering: Offering?

    var body: some View {
        VStack(spacing: 10) {
            Text("With RevenueCat")
                .padding()

            if let offering = self.offering {
                ForEach(offering.availablePackages) { package in
                    Button {
                        Task {
                            try await Purchases.shared.purchase(package: package)
                        }
                    } label: {
                        Text(package.storeProduct.localizedTitle)
                    }

                }
            }
        }
        .padding()
        .task {
            await self.loadSKProducts()
        }
    }

    private func loadSKProducts() async {
        // This should go in App but here because demo
        Purchases.configure(withAPIKey: "your_api_key")

        do {
            self.offering = try await Purchases.shared.offerings().current
        } catch {
            print(error)
        }
    }
}
```

### StoreKit 2

```swift
struct StoreKitView: View {
    @State private var products: [Product] = []

    var body: some View {
        VStack(spacing: 10) {
            Text("With StoreKit 2")
                .padding()

            ForEach(self.products) { product in
                Button {
                    Task {
                        try await product.purchase()
                    }
                } label: {
                    Text(product.displayName)
                }
            }
        }
        .padding()
        .task {
            await self.loadSKProducts()
        }
    }

    private func loadSKProducts() async {
        let productIds = ["com.revenuecat.pro.monthly",
                          "com.revenuecat.pro.yearly",
                          "com.revenuecat.pro.lifetime"]
        do {
            self.products = try await Product.products(for: productIds)
        } catch {
            print(error)
        }
    }
}
```
