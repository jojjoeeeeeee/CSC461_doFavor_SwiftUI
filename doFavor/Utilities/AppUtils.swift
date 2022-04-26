//
//  AppUtils.swift
//  doFavor
//
//  Created by Phakkharachate on 21/3/2565 BE.
//

import Foundation
import SwiftyRSA
import CryptoKit
import JWTDecode

struct AppUtils {
    
    fileprivate static let UD_Device_uuid = "device_uuid"
    fileprivate static let USR_PRV_KEY = "privateKey"
    fileprivate static let USR_PBL_KEY = "publicKey"
    fileprivate static let SIGN_PRV_KEY = "sprivateKey"
    fileprivate static let SIGN_PBL_KEY = "spublicKey"
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
    
    //get user id userid
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
        
        static func test() {
            do {
                
                AppUtils.E2EE.encryptMessage(for: "", otherPublicKey: "", conversation_id: "") { result in
                    switch result {
                    case .success(let msg):
                        print("Encrypted message",msg) //msg send to firebase
                    case .failure(let error):
                        print("Error to encrypt",error)
                    }
                }
                
                AppUtils.E2EE.decryptMessage(for: "", otherPublicKey: "", conversation_id: "") { result in
                    switch result {
                    case .success(let msg):
                        print("Decryped message",msg) //append to array
                    case .failure(let error):
                        print("Error to decrypt",error)
                    }
                }
            }
        }
        
        static func generateKeyPair() {
            let privateKey = Curve25519.KeyAgreement.PrivateKey()
            let publicKey = privateKey.publicKey
            
            let base64prv = privateKey.rawRepresentation.base64EncodedString()
            let base64pbl = publicKey.rawRepresentation.base64EncodedString()
            
            UserDefaults.standard.setValue(base64pbl, forKey: AppUtils.USR_PBL_KEY)
            UserDefaults.standard.setValue(base64prv, forKey: AppUtils.USR_PRV_KEY)
        }
        
        static func getBase64PublicKey() -> String {
            return UserDefaults.standard.string(forKey: AppUtils.USR_PBL_KEY) ?? ""
        }
        
        static func encryptMessage(for message: String, otherPublicKey: String, conversation_id: String, completion: @escaping(Result<String,Error>) -> ()) {
            
            do {
                let privateString = UserDefaults.standard.string(forKey: AppUtils.USR_PRV_KEY) ?? ""
                let privatekeyData = Data(base64Encoded: privateString)
                let privateKey = try Curve25519.KeyAgreement.PrivateKey(rawRepresentation: privatekeyData!)
                
                let keyData = Data(base64Encoded: otherPublicKey)
                let keyFromData = try Curve25519.KeyAgreement.PublicKey(rawRepresentation: keyData!)
                
                let sharedSecret = try privateKey.sharedSecretFromKeyAgreement(with: keyFromData)
                let symmetricKey = sharedSecret.hkdfDerivedSymmetricKey(using: SHA256.self,
                                                                        salt: conversation_id.data(using: .utf8)!,
                                                                        sharedInfo: Data(),
                                                                        outputByteCount: 32)
                
                let sensitiveMessage = message.data(using: .utf8)!
                let encryptedData = try ChaChaPoly.seal(sensitiveMessage, using: symmetricKey).combined
                let base64encrypted = encryptedData.base64EncodedString()
                completion(.success(base64encrypted))
            } catch {
                completion(.failure(error))
            }
        }
        
        static func decryptMessage(for encryptedMessage: String, otherPublicKey: String, conversation_id: String, completion: @escaping(Result<String,Error>) -> ()) {
            
            do {
                let privateString = UserDefaults.standard.string(forKey: AppUtils.USR_PRV_KEY) ?? ""
                let privatekeyData = Data(base64Encoded: privateString)
                let privateKey = try Curve25519.KeyAgreement.PrivateKey(rawRepresentation: privatekeyData!)
                
                let keyData = Data(base64Encoded: otherPublicKey)
                let keyFromData = try Curve25519.KeyAgreement.PublicKey(rawRepresentation: keyData!)
                
                let sharedSecret = try privateKey.sharedSecretFromKeyAgreement(with: keyFromData)
                let symmetricKey = sharedSecret.hkdfDerivedSymmetricKey(using: SHA256.self,
                                                                        salt: conversation_id.data(using: .utf8)!,
                                                                        sharedInfo: Data(),
                                                                        outputByteCount: 32)
                
                let encryptedData = Data(base64Encoded: encryptedMessage)
                
                guard let encryptedDataUnwrraped = encryptedData else { throw NSError.init() }
                let sealedBox = try ChaChaPoly.SealedBox(combined: encryptedDataUnwrraped)
                let decryptedData = try ChaChaPoly.open(sealedBox, using: symmetricKey)
                
                let message = String(data: decryptedData, encoding: .utf8)
                completion(.success(message!))
            } catch {
                completion(.failure(error))
            }
        }
        
        
        //For more security
        static func generateSignKeyPair() {
            do {
                let keyPair = try SwiftyRSA.generateRSAKeyPair(sizeInBits: 2048)
                let privateKey = keyPair.privateKey
                let publicKey = keyPair.publicKey

                let publicPem = try publicKey.pemString()
                let privatePem = try privateKey.pemString()


                UserDefaults.standard.setValue(publicPem, forKey: AppUtils.SIGN_PBL_KEY)
                UserDefaults.standard.setValue(privatePem, forKey: AppUtils.SIGN_PRV_KEY)

            } catch {
                print("Error to generate sign key pair")
            }
        }
        
        static func sign(for base64encryptedMsg: String, completion: @escaping (Result<String,Error>) -> ()) {
            let privatePem = UserDefaults.standard.string(forKey: AppUtils.SIGN_PRV_KEY) ?? ""
            
            do {
                let privateKey = try PrivateKey(pemEncoded: privatePem)
                let clear = try ClearMessage(string: base64encryptedMsg, using: .utf8)
                let signature = try clear.signed(with: privateKey, digestType: .sha1)

                let data = signature.data
                let base64String = signature.base64String
                completion(.success(base64String))
            } catch {
                print("Error to sign base64encryptedMsg")
                completion(.failure(error))
            }
        }
        
        static func verify(for base64encryptedMsg: String, by signature: String, otherPublicKey: String) -> Bool {
            do {
                let publicKey = try PublicKey(pemEncoded: otherPublicKey)
                let signature = try Signature(base64Encoded: signature)
                let clear = try ClearMessage(string: base64encryptedMsg, using: .utf8)
                let isSuccessful = try clear.verify(with: publicKey, signature: signature, digestType: .sha1)
                return isSuccessful
            } catch {
                print("Error to verify base64encryptedMsg")
                return false
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
