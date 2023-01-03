//
//  ContentView.swift
//  StoreKitConfigDemo
//
//  Created by Josh Holtz on 1/3/23.
//

import SwiftUI

import StoreKit

struct ContentView: View {
    var body: some View {
        StoreKitView()
        Divider()
        RevenueCatView()
    }
}
