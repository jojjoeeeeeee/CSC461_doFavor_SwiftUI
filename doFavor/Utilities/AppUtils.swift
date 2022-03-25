//
//  AppUtils.swift
//  doFavor
//
//  Created by Phakkharachate on 21/3/2565 BE.
//

import Foundation
import SwiftyRSA
import JWTDecode

struct AppUtils {
    
    fileprivate static let UD_Device_uuid = "device_uuid"
    fileprivate static let USR_PRV_KEY = "privateKey"
    fileprivate static let USR_PBL_KEY = "publicKey"
    fileprivate static let ISAPP_FIRST_RUN = "isapp_firstrun"
    
    static func setAppFirstRun() {
        UserDefaults.standard.setValue(true, forKey: ISAPP_FIRST_RUN)
    }
    
    static func isAppFirstRun() -> Bool {
        if UserDefaults.standard.value(forKey: ISAPP_FIRST_RUN) == nil {
            return true
        }
        else {
            return false
        }
    }
    
    static func saveDeviceUUIDToken(token:String) {
        UserDefaults.standard.setValue(token, forKey: UD_Device_uuid)
    }
    
    static func getDeviceUUIDToken() -> String? {
        return UserDefaults.standard.value(forKey: UD_Device_uuid) as? String
    }
    
    static func saveUsrAuthToken(token:String) {
        UserDefaults.standard.setValue(token, forKey: Constants.AppConstants.CUR_USR_TOKEN)
    }
    
    static func getUsrAuthToken() -> String? {
        return UserDefaults.standard.value(forKey: Constants.AppConstants.CUR_USR_TOKEN) as? String
    }
    
    static func getUsrId() -> String? {
        return AppUtils.JWT.decryptUsrAuthToken()
    }
    
    static func saveUsrUsername(username:String) {
        UserDefaults.standard.setValue(username, forKeyPath: Constants.AppConstants.CUR_USR_USERNAME)
    }
    
    static func getUsrUsername() -> String? {
        return UserDefaults.standard.value(forKey: Constants.AppConstants.CUR_USR_USERNAME) as? String
    }
    
    static func saveUsrEmail(email:String) {
        UserDefaults.standard.setValue(email, forKeyPath: Constants.AppConstants.CUR_USR_EMAIL)
    }
    
    static func getUsrEmail() -> String? {
        return UserDefaults.standard.value(forKey: Constants.AppConstants.CUR_USR_EMAIL) as? String
    }
    
    static func saveUsrProfile(profile:String) {
        UserDefaults.standard.setValue(Constants.ENDPOINT+profile, forKeyPath: Constants.AppConstants.CUR_USR_PROFILE)
    }
    
    static func getUsrProfile() -> String? {
        return UserDefaults.standard.value(forKey: Constants.AppConstants.CUR_USR_PROFILE) as? String
    }
    
    static func saveUsrName(firstname:String, lastname:String) {
        UserDefaults.standard.setValue("\(firstname) \(lastname)", forKeyPath: Constants.AppConstants.CUR_USR_NAME)
    }
    
    static func getUsrName() -> String? {
        return UserDefaults.standard.value(forKey: Constants.AppConstants.CUR_USR_NAME) as? String
    }
    
    static func eraseAllUsrData() {
        UserDefaults.standard.removeObject(forKey: Constants.AppConstants.CUR_USR_TOKEN)
        UserDefaults.standard.removeObject(forKey: Constants.AppConstants.CUR_USR_EMAIL)
        UserDefaults.standard.removeObject(forKey: Constants.AppConstants.CUR_USR_NAME)
        UserDefaults.standard.removeObject(forKey: Constants.AppConstants.CUR_USR_PROFILE)
        UserDefaults.standard.removeObject(forKey: Constants.AppConstants.CUR_USR_USERNAME)
        
    }
    
    struct E2EE {
        
        static func generateKeyPair() {
            do {
                let keyPair = try SwiftyRSA.generateRSAKeyPair(sizeInBits: 2048)
                let privateKey = keyPair.privateKey
                let publicKey = keyPair.publicKey
                
                let publicPem = try publicKey.pemString()
                let privatePem = try privateKey.pemString()
                
                UserDefaults.standard.setValue(publicPem, forKey: AppUtils.USR_PBL_KEY)
                UserDefaults.standard.setValue(privatePem, forKey: AppUtils.USR_PRV_KEY)
                
            } catch {
                print("Error to generate key pair")
            }
        }
        
        static func encryptMessage(message: String, publicPem: String, completion: @escaping (Result<String,Error>) -> ()) {
            
            do {
                let publicKey = try PublicKey(pemEncoded: publicPem)
                
                let str = message
                let clear = try ClearMessage(string: str, using: .utf8)
                let encrypted = try clear.encrypted(with: publicKey, padding: .PKCS1)

                let data = encrypted.data
                let base64String = encrypted.base64String
                completion(.success(base64String))
            } catch {
                completion(.failure(error))
            }
            
            return
        }
        
        static func decryptMessage(base64String: String, privatePem: String, completion: @escaping(Result<String,Error>) -> ()) {
            
            do {
                let privateKey = try PrivateKey(pemEncoded: privatePem)
                
                let encrypted = try EncryptedMessage(base64Encoded: base64String)
                let clear = try encrypted.decrypted(with: privateKey, padding: .PKCS1)

                let data = clear.data
                let string = try clear.string(encoding: .utf8)
                
                completion(.success(string))
            } catch {
                completion(.failure(error))
            }
        }
        
        
    }
    
    struct JWT {
        
        static func decryptUsrAuthToken() -> String? {
            
            guard let authtoken = AppUtils.getUsrAuthToken() else {
                return nil
            }
            
            let token = authtoken.components(separatedBy: " ")[1]
            
            do {
                let jwt = try decode(jwt: token)
                let claim = jwt.claim(name: "id")
                if let id = claim.string {
                    return id
                }
            } catch {
                return nil
            }
            return nil
        }
        
    }
}
