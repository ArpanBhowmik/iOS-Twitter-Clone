//
//  Constants.swift
//  Twitter Clone
//
//  Created by m-arpan-b on 18/1/23.
//

import Firebase

let STORAGE_REF = Storage.storage().reference()
let STORAGE_PROFILE_IMAGES = STORAGE_REF.child("profile_image")

let DB_REF = Database.database().reference()
let REF_USERS = DB_REF.child("user")
let REF_TWEETS = DB_REF.child("tweets")
let REF_USER_TWEETS = DB_REF.child("user-tweets")
