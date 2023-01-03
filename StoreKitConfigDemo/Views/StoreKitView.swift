//
//  StoreKitView.swift
//  StoreKitConfigDemo
//
//  Created by Josh Holtz on 1/3/23.
//

import SwiftUI
import StoreKit

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
