//
//  PollHelper.swift
//  Swish
//
//  Created by Atemnkeng Fontem on 5/1/20.
//  Copyright © 2020 Atemnkeng Fontem. All rights reserved.
//

import Foundation
import FirebaseFunctions

class PollHelper {
    
    static func getPolls(completion : @escaping ([PollQuestion]) -> Void){
        
        functions.httpsCallable("getPolls").call([]) { (result, error) in
            
            if let err = error{
                print("getting polls error : \(err.localizedDescription)")
            }
            
            var pollQuestions : [PollQuestion] = [PollQuestion]()
            
            if let resultData = result?.data as? [String : Any],
                let pollsData = resultData["polls"] as? [[String : Any]]{

                for pollData in pollsData{
                    
                    if let response = PollQuestionResponse(data: pollData){
                        
                        pollQuestions.append(PollQuestion(response: response))
                
                    }

                }
   
            }
            completion(pollQuestions)
        }
        
    }
    
    static func completePoll(completedPoll : CompletedPollQuestion){
        let chosenID = completedPoll.chosenUser.uid
        let docRef = db.collection("users").document(chosenID).collection("inbox").document()
        
        let inboxItem = InboxItem(question: completedPoll, documentID: docRef.documentID)
        if let data = inboxItem.getDictionary(){
        docRef.setData(data)
        }
    
         }
    
    static func revealUser(poll: CompletedPollQuestion, completion : @escaping () -> Void){
        functions.httpsCallable("revealUser").call(["pollId":poll.id]) { (result, error) in
            if let err = error{
                print("rxFpoevealing polls error : \(err.localizedDescription)")
            }else{
                completion()
            }
        }
    }
    
    static func skipQuestion(index: Int, completion : @escaping (PollQuestion) -> Void){
        functions.httpsCallable("skipQuestion").call(["index":index,"schoolID" : User.shared!.schoolID]) { (result, error) in
            if let err = error{
                print("skipping questions error : \(err.localizedDescription)")
            }else{
                let docRef = db.collection("users").document(User.shared!.uid).collection("polls").document(String(index))
                docRef.getDocument { (document, error) in
                    if error == nil{
                        if let data = document!.data(), let response = PollQuestionResponse(data: data){
                            completion(PollQuestion(response: response))
                        }
                    }else{
                        print("skip quesiton document reaidng error: \(error!.localizedDescription)")
                    }
                }
            }
        }
    }
         
     }
    


