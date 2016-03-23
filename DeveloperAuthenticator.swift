
import Foundation
import Alamofire
import AWSCore
import SwiftyJSON

class DeveloperAuthenticator: CognitoAuthenticator {
    
    func retrieveToken(success: (identityId: String?, token: String?, userIdentifier: String?) -> Void, failure: (error: NSError) -> Void) {
        let endpoint = "HTTP endpoint that retrieves a cognito developer token"
        // sample lambda function: https://github.com/jwalstrom/aws-lambda-cognito-auth
        Alamofire.request(.POST, endpoint, parameters: tokenParams(), encoding: .JSON)
            .validate()
            .responseJSON{ response in
                switch response.result {
                case.Success(let data):
                    let json = JSON(data)
                    success(identityId: json["identityId"].string, token: json["token"].string, userIdentifier: json["userIdentifier"].string)
                case.Failure(let error):
                    failure(error: error)
                }
        }
    }
    
    private func tokenParams() -> Dictionary<String, AnyObject> {
        // these values should come from keychain or some type of internal app storage
        var params = Dictionary<String, AnyObject>()
        params["userIdentifier"] = "KEY THAT IDENTIFIES THE USER THAT WILL LOOKUP AND GENERATE TOKEN FROM SERVER"
        params["identityId"] = "COGNITO IDENTITYID | USED IF GOING FROM UNAUTHED TO AUTHED OTHERWISE CAN BE REMOVED"
        return params
    }
}