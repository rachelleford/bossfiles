//
//  SignUpView.swift
//  Boss5207418
//
//  Created by Rachelle Ford on 6/16/23.
//

import SwiftUI
import FirebaseFirestore

struct SignUpView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var username: String = ""
    @State private var profileImage: Image?
    @State private var pickedImage: Image?
    @State private var showingActionSheet = false
    @State private var showingImagePicker = false
    @State private var imageData: Data = Data()
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var error:String = ""
    @State private var showingAlert = false
    @State private var alertTitle: String = "Oh No😭"
    @State private var isLinkActive = false
    
    
    func loadImage() {
        guard let inputImage = pickedImage else {return
        }
        
        profileImage = inputImage
    }
    
    func errorCheck() -> String? {
        if email.trimmingCharacters(in: .whitespaces).isEmpty ||
            password.trimmingCharacters(in: .whitespaces).isEmpty ||
            username.trimmingCharacters(in: .whitespaces).isEmpty ||
            imageData.isEmpty{
            
            return "Please fill in all fields and upload an image"
        }
        return nil
        
    }
    
    func clear(){
        self.email = ""
        self.username = ""
        self.password = ""
        self.imageData = Data()
        self.profileImage = Image(systemName: "person.circle.fill")
        
    }
    
    func signUp() {
        if let error = errorCheck() {
            self.error = error
            self.showingAlert = true
            return
        }
        
        AuthService.signUp(username: username, email: email, password: password, imageData: imageData, onSuccess: {
            (user) in
            let userRef = Firestore.firestore().collection("users").document(user.uid)
               let userData: [String: Any] = [
                   "email": self.email,
                   "username": self.username,
                   "verified": false
               ]
               
               userRef.setData(userData) { error in
                   if let error = error {
                       // Handle error during user document creation
                       print("Error creating user document: \(error.localizedDescription)")
                   } else {
                       // User registration and document creation successful
                       // Proceed with other actions
                       self.clear()
                   }
               }
               
           }) { (errorMessage) in
               print("Error \(errorMessage)")
               self.error = errorMessage
               self.showingAlert = true
               return
           }
       }
    
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                VStack(alignment: .center, spacing: 5) {
                    Text("Boss Nation Network")
                        .font(.system(size: 32, weight: .heavy))
                    
                    Text("Sign Up To Start")
                        .font(.system(size: 16, weight: .medium))
                }
                
                VStack {
                    Group {
                        if profileImage != nil {
                            profileImage!
                                .resizable()
                                .clipShape(Circle())
                                .frame(width: 150, height: 150)
                                .padding(.top, 5)
                                .onTapGesture {
                                    self.showingActionSheet = true
                                }
                            
                        } else {
                            Image("profilepic")
                                .resizable()
                                .clipShape(Circle())
                                .frame(width: 150, height: 150)
                                .padding(.top, 5)
                                .onTapGesture {
                                    self.showingActionSheet = true
                                }
                        }
                    }
                }
                
                Group {
                    FormField(value: $username, icon: "person.fill", placeholder: "Username")
                        .padding(.bottom, -30)
                    
                    FormField(value: $email, icon: "envelope.fill", placeholder: "Email")
                        .padding(.bottom, -30)
                    
                    FormField(value: $password, icon: "lock.fill", placeholder: "Password", isSecure: true)
                }
                
                NavigationLink(destination: SignInView()) {
                    Button(action: {
                        signUp()
                    }) {
                        Text("Sign Up")
                            .font(.title)
                            .modifier(ButtonModifiers())
                    }
                }
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text(alertTitle), message: Text(error), dismissButton: .default(Text("OK")))
                }

            }
            .padding()
        }
        .background(
            Image("back1284")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
        )
        .sheet(isPresented: $showingImagePicker, onDismiss: loadImage){
            ImagePicker(pickedImage: self.$pickedImage, showingImagePicker: self.$showingImagePicker, imageData: self.$imageData)
        }
        .actionSheet(isPresented: $showingActionSheet) {
            ActionSheet(
                title: Text(""),
                buttons: [
                    .default(Text("Choose A Photo")) {
                        self.sourceType = .photoLibrary
                        self.showingImagePicker = true
                    },
                    .default(Text("Take a Photo")) {
                        self.sourceType = .camera
                        self.showingImagePicker = true
                    },
                    .cancel()
                ])
        }
    }


}
