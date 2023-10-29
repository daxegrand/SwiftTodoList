//
//  RegisterViewViewModel.swift
//  TodoList
//
//  Created by Dax Granados on 10/22/23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class RegisterViewViewModel : ObservableObject {
    @Published var fullname = ""
    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage = ""
    
    init() {
        
    }
    
    func register() {
        guard validate() else {
            return
        }
        
        //attempt to register via firebase
        Auth.auth().createUser(withEmail: email, password: password) {
            [weak self] result, error in
            guard let userId = result?.user.uid else {
                return
            }
            
            self?.insertUserRecord(id: userId)
        }
    }
    
    private func insertUserRecord(id: String) {
        let newUser = User(id: id, fullname: fullname, email: email, joined: Date().timeIntervalSince1970)
        
        let db = Firestore.firestore()
        
        db.collection("users")
            .document(id)
            .setData(newUser.asDictionary())
    }
    
    private func validate() -> Bool {
        //init errorMessage
        errorMessage = ""
        guard !fullname.trimmingCharacters(in: .whitespaces).isEmpty, !email.trimmingCharacters(in: .whitespaces).isEmpty, !password.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Please fill in all fields"
            return false
        }
        
        guard isValidEmailAddress(emailAddressString: email) else {
            errorMessage = "Please enter a valid email address"
            return false
        }
        
        guard isValidPassword(password) else {
            errorMessage = "Your password must be 8 characters long, have at least one digit, have at leaset one letter, and doesnt contain any whitespaces."
            return false
        }
        
        return true
    }
    
    private func isValidEmailAddress(emailAddressString: String) -> Bool {
        
        var returnValue = true
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = emailAddressString as NSString
            let results = regex.matches(in: emailAddressString, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0
            {
                returnValue = false
            }
            
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        
        return  returnValue
    }
    
    private func isValidPassword(_ password: String) -> Bool {
        //At least 8 characters
        if password.count < 8 {
            return false
        }
        //At least one digit
        if password.range(of: #"\d+"#, options: .regularExpression) == nil {
            return false
        }
        //At least one letter
        if password.range(of: #"\p{Alphabetic}+"#, options: .regularExpression) == nil {
            return false
        }
        //No whitespace charcters
        if password.range(of: #"\s+"#, options: .regularExpression) != nil {
            return false
        }
        return true
    }
}
