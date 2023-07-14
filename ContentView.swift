//
//  ContentView.swift
//  Boss5207418
//
//  Created by Rachelle Ford on 6/13/23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var session: SessionStore

    var body: some View {
        NavigationView {
            Group {
                if let _ = session.session {
                    HomeView()
                } else {
                    HomeView()
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                session.listen()
            }
        }
    }
}
