//
//  RevenueCatView.swift
//  StoreKitConfigDemo
//
//  Created by Josh Holtz on 1/3/23.
//

import SwiftUI

import RevenueCat

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
        Purchases.configure(withAPIKey: "appl_RtoeNzWehEYzitXLjWUJSnPXmNr")

        do {
            self.offering = try await Purchases.shared.offerings().current
        } catch {
            print(error)
        }
    }
}
