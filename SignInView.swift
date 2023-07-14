//
//  SignInView.swift
//  Boss5207418
//
//  Created by Rachelle Ford on 6/16/23.
//

import SwiftUI
import FirebaseAuth
import Firebase

struct SignInView: View {
    @EnvironmentObject var session: SessionStore
    @State private var navigateToMain = false
    
    func listen(){
        session.listen()
    }
    
    @State private var email: String = ""
    @State private var password: String = ""
    
    @State private var error:String = ""
    @State private var showingAlert = false
    @State private var alertTitle: String = "Oh No😭"
    
    func errorCheck() -> String? {
        if email.trimmingCharacters(in: .whitespaces).isEmpty ||
            password.trimmingCharacters(in: .whitespaces).isEmpty
        {
            
            return "Please fill in all fields"
        }
        return nil
        
    }
    func clear(){
        self.email = ""
        self.password = ""
        
        
    }
    func signIn() {
        if let error = errorCheck() {
            self.error = error
            self.showingAlert = true
            self.clear()
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print("Error signing in: \(error.localizedDescription)")
                self.error = "Failed to sign in. Please check your credentials and try again."
                self.showingAlert = true
                return
            }
            
            self.clear()
            self.session.listen()
            self.navigateToMain = true
        }
    }
    
    
    
    var body: some View {
        
        NavigationView {
            ZStack {
                Image("back1284")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 5) {
                    GeometryReader { geometry in
                        Image("applogofront 2")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 135, height: 135)
                            .background(Color.white)
                            .cornerRadius(10)
                            .padding()
                            .position(x: geometry.size.width / 2, y: geometry.size.height / 2 - 20)
                    }
                    
                    VStack(alignment: .center, spacing: 5) {
                        Text("Welcome Back")
                            .font(.system(size: 32, weight: .heavy))
                            .offset(y: -150)
                        
                        Text("Sign In To Continue")
                            .font(.system(size: 16, weight: .medium))
                            .offset(y: -150)
                    }
                    
                    FormField(value: $email, icon: "envelope.fill", placeholder: "Email")
                        .offset(y: -150) // Apply a negative offset to move it higher on the screen
                    
                    FormField(value: $password, icon: "lock.fill", placeholder: "Password", isSecure: true)
                        .offset(y: -150) // Apply a negative offset to move it higher on the screen
                    
                    Button(action: {
                        signIn()
                        listen()
                    }) {
                        Text("Sign In")
                            .font(.title)
                            .modifier(ButtonModifiers())
                    }
                    .offset(y: -150) // Apply a negative offset to move it higher on the screen
                    .alert(isPresented: $showingAlert) {
                        Alert(title: Text(alertTitle), message: Text(error), dismissButton: .default(Text("OK")))
                    }
                    
                    HStack {
                        Text("New?")
                        NavigationLink(destination: SignUpView()) {
                            Text("Create an Account")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.black)
                        }
                    }
                    .offset(y: -150) // Apply a negative offset to move it higher on the screen
                }
                .padding()
            }
            .onAppear {
                listen() // Call listen when the view appears
            }
            .background(
                NavigationLink(destination: HomeView(), isActive: $navigateToMain) {
                    EmptyView()
                }
            )
        }
    }
}

