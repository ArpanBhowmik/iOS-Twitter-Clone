//
//  AuthService.swift
//  Twitter Clone
//
//  Created by m-arpan-b on 18/1/23.
//

import UIKit
import Firebase

struct AuthCredentials {
    let email: String
    let password: String
    let fullname: String
    let username: String
    let profileImage: UIImage
}

enum AuthenticationError: Error {
    case nilImageData
    case imageUploadFailure
    case urlFetchError
    case registrationError
    case userDataUploadFailure
}

struct AuthService {
    static let shared = AuthService()
    
    func logUserIn(withEmail email: String, password: String, completion: ((AuthDataResult?, Error?) -> Void)?) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
    func registerUser(credentials: AuthCredentials, completion: @escaping ((AuthenticationError?) -> Void)) {
        guard let imageData = credentials.profileImage.jpegData(compressionQuality: 0.3) else {
            completion(.nilImageData)
            return
        }
        
        let fileName = NSUUID().uuidString
        let storageRef = STORAGE_PROFILE_IMAGES.child(fileName)
        
        storageRef.putData(imageData, metadata: nil) { _, error in
            if let error {
                print("Error uploading profile image: \(error.localizedDescription)")
                completion(.imageUploadFailure)
                return
            }
            
            storageRef.downloadURL { url, error in
                if let error {
                    print("Could not fetch url error: \(error.localizedDescription)")
                    completion(.urlFetchError)
                    return
                }
                guard let profileImageUrl = url?.absoluteString else { return }
                
                Auth.auth().createUser(withEmail: credentials.email, password: credentials.password) { result, error in
                    if let error {
                        print("error while registering user: \(error.localizedDescription)")
                        completion(.registrationError)
                        return
                    }
                    
                    guard let uid = result?.user.uid else { return }
                    let values = ["email": credentials.email,
                                  "username": credentials.username,
                                  "fullname": credentials.fullname,
                                  "profileImageUrl": profileImageUrl
                    ]
                    
                    REF_USERS.child(uid).updateChildValues(values) { error, ref in
                        if let error {
                            print("Couldn't upload user data. error = \(error.localizedDescription)")
                            completion(.userDataUploadFailure)
                            return
                        }
                        print("successfully updated user information")
                        completion(nil)
                    }
                }
            }
        }
    }
}
