//
//  HomeView.swift
//  Boss5207418
//
//  Created by Rachelle Ford on 6/16/23.
//


import SwiftUI

struct HomeView: View {


    var body: some View {
        NavigationView {
            CustomTabView()
                .navigationBarTitle("")
                .navigationBarHidden(true)
        }
        .accentColor(.red)
        .environmentObject(CameraModel()) // Provide the CameraModel as an environment object
    }
}

var tabs = ["house.fill", "video.fill", "camera.viewfinder", "envelope.fill", "person.fill"]

struct CustomTabView: View {
    @State var selectedTab = "house.fill"
    @State var edge = UIApplication.shared.windows.first?.safeAreaInsets
    
    
    var body: some View{
        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
            
            TabView(selection: $selectedTab) {
                    MainView()
                        .tag("house.fill")
                    Breels()
                        .tag("video.fill")
                    CameraView()
                        .tag("camera.viewfinder")
                    MainMessagesView()
                        .tag("envelope.fill")
                    Profile()
                        .tag("person.fill")
                
                
                }
            
            
            
            HStack(spacing: 0) {
                ForEach(tabs, id: \.self){
                    image in
                    TabButton(image: image, selectedTab: $selectedTab)
                    
                    if image != tabs.last {
                        Spacer(minLength: 0)
                    }
                }
            }
            .padding(.horizontal, 25)
            .padding(.vertical, 5)
            .background(Color.white)
            .clipShape(Capsule())
            .shadow(color: Color.black.opacity(0.15), radius: 5, x: 5, y: 5)
            .shadow(color: Color.black.opacity(0.15), radius: 5, x: -5, y: -5)
            .padding(.horizontal)
            .padding(.bottom, edge!.bottom == 0 ? 20: 0)
            
        }
        //   .ignoresSafeArea(.keyboard, edges: .bottom)
        //     .background(Color.black.opacity(0.05).ignoresSafeArea(.all, edges: .all))
    }
    
    struct TabButton: View {
        var image: String
        @Binding var selectedTab: String
        
        var body: some View {
            Button(action: {
                selectedTab = image
            }) {
                Image(systemName: "\(image)")
                    .foregroundColor(selectedTab == image ? Color.red : Color.gray)
                    .padding()
            }
            .navigationBarHidden(true) // Hide the navigation bar in HomeView
        }
    }
}
