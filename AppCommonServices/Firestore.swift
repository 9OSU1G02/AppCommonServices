//
//  Firestore.swift
//  AppCommonServices
//
//  Created by 9OSU1G02 on 8/31/23.
//

import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

class FirestoreUtil {
    static let db = Firestore.firestore()
    static let storate = Storage.storage()
    static func createNewUser(name: String) {
        Self.db.collection("users").addDocument(data: ["name": name]) { error in
            if let error {
                print("Error adding document: \(error)")
            } else {
                print("User added with name: \(name)")
            }
        }
    }
    
    static func deleteUser(id: String) {
        Self.db.collection("users").document(id).delete { error in
            if let error {
                print("Error deleting document: \(error)")
            } else {
                print("User deleted with id: \(id)")
            }
        }
    }
    
    static func getUsers() {
        Self.db.collection("users").getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else {
                print("error", error?.localizedDescription ?? "error getUsers")
                return
            }
            print("getUsers",documents)
        }
    }
    
    static func createAccount(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let result {
                print("create user result", result)
            }
            if let error {
                print("create user error", error)
            }
        }
    }
    
    static func signInAccount(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let result {
                Self.uploadImage(url: Bundle.main.url(forResource: "cat", withExtension: ".JPG")!)
                print("signInAccount result", result)
            }
            if let error {
                print("signInAccount error", error)
            }
        }
    }
    
    static func uploadImage(url: URL) {
        let storageRef = storate.reference()
        let imagesRef = storageRef.child("images/cat.jpg")
        imagesRef.putFile(from: url) { result in
            switch result {
            case .success(let success):
                print("success upload image name:", success.name ?? "")
            case .failure(let failure):
                print("failed upload image:", failure.localizedDescription)
            }
        }
    }
}
