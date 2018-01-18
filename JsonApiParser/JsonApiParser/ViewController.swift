//
//  ViewController.swift
//  JsonApiParser
//
//  Created by Vlaho Poluta on 15/01/2018.
//  Copyright © 2018 Vlaho Poluta. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let N = 50_000
//
//        //Simple
//        let simpleData = ExampleReader.importSimpleData()
//
//        let dateSimple = Date()
//        for _ in (0 ..< N) {
//            _ = ExampleReader.decode(data: simpleData)
//        }
//        print(Date().timeIntervalSince(dateSimple))

        //Json api
        let jsonApiData = ExampleReader.importData()
        let jsonApiSimpleData = ExampleReader.importSimpleData()

//        let date = Date()
//        for _ in (0 ..< N) {
        let jsonApi = ExampleReader.dataToJson(jsonApiData)
        let jsonApiSimple = ExampleReader.dataToJson(jsonApiSimpleData)

        let includeList = "activities,announcements,activities.relatedRecipe,activities.relatedTip,activities.relatedProfile,activities.relatedCollection,activities.subject,activities.subject.profileImage,activities.subject.countryInfo,activities.relatedProfile.profileImage,activities.relatedProfile.countryInfo,activities.relatedProfile.isFollowing,activities.relatedRecipe.profiles,activities.relatedRecipe.recipeTranslations,activities.relatedRecipe.coverImage,activities.relatedTip.profiles,activities.relatedTip.tipTranslations,activities.relatedTip.coverImage,activities.relatedCollection.recipeImages,activities.relatedCollection.profiles,activities.relatedCollection.latestRecipeImage,announcements.country,announcements.active,announcements.announcementType,announcements.categories,announcements.entityId,announcements.translations,announcements.defaultTranslation,announcements.image,announcements.relatedRecipe,announcements.relatedTip,announcements.relatedCollection,announcements.relatedProfile"
        let dicts = try! JSONAPIParser.Decoder.jsonObject(withJSONAPIObject: jsonApi, includeList: includeList)
        print(ExampleReader.prettyPrintJson(data: dicts as NSDictionary))
        
        
        let simpleDicts = try! JSONAPIParser.Decoder.jsonObject(withJSONAPIObject: jsonApiSimple)
        print(ExampleReader.prettyPrintJson(data: simpleDicts as NSDictionary))

        
        let data = try! JSONAPIParser.Decoder.data(withJSONAPIObject: jsonApi, includeList: includeList)
//            let normalData = ExampleReader.jsonToData(dicts)
//            _ = ExampleReader.decode(data: normalData)
//        }
//        print(Date().timeIntervalSince(date))
    }
    
    func unboxTest() {
        //        let resp1 = try! JsonApiParser.unbox(jsonApiInput: unboxTest)
        //        debugPrint(resp1 as NSDictionary)
        //        print("\n\n")
    }
    
    func wrapTest() {
        //        let resp2 = try! JsonApiParser.wrap(json: wrapTest)
        //        debugPrint(resp2 as NSDictionary)
        //        print("\n\n")
    }
    
}

