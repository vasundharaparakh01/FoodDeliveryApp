//
//  SCoreDataHelper.swift
//  FanServe
//
//  Created by McCoy Mart on 27/06/22.
//

import UIKit
import CoreData

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}

class SCoreDataHelper: NSObject {
    
    static let shared = SCoreDataHelper()
    let appDel = UIApplication.shared.delegate as! AppDelegate
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "Serve")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                            fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        container.viewContext.mergePolicy = NSMergePolicy(merge: .overwriteMergePolicyType)
        return container
    }()
    
    
    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        
        if context.hasChanges {
            do {
                context.refreshAllObjects()
                try context.save()
            } catch {
                let nserror = error as NSError
                print("Unresolved error \(nserror), \(nserror.userInfo)")
                // fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: This is used to clear all the data from database
    func clearAllDBData(){
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "SAppUser")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        let context = persistentContainer.viewContext
        
        context.performAndWait {
            do {
                try context.execute(deleteRequest)
                try context.save()
            } catch {
                print ("There was an error")
            }
            
            //            let model = persistentContainer.managedObjectModel
            //            let entities =   model.entities
            //            // Use to delete the object which are not associated with the relations
            //            for entity in entities {
            //                print(" ===== \(entity.name ?? "")")
            //                let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity.name!)
            //                let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
            //                do {
            //                    try context.execute(deleteRequest)
            //                } catch {
            //                }
            //            }
            
        }
        self.saveContext()
    }
    
    func currentUser() -> SAppUser? {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "SAppUser")
        
        request.predicate = NSPredicate(format: "isCurrentUser == \(true)")
        
        do {
            let result = try persistentContainer.viewContext.fetch(request)
            
            if result.count > 0 {
                let   appUser = result.first as? SAppUser
                
                return appUser
            }else {
                return nil
            }
            
        } catch {
            DLog("Failed")
            return nil
        }
    }
    
    //MARK:- Create AppUser
    
    func createAppUser(params: Dictionary<String, Any>?){
        
        if let appUser = self.currentUser(){
            if params != nil{
                self.updateAppUser(user: appUser, params: params!)
            }else{
                appUser.isCurrentlyLogin = false
                appUser.isCurrentUser = true
            }
        }else{
            let appUser = SAppUser.newObject(entityName: "SAppUser") as! SAppUser
            if params != nil{
                self.updateAppUser(user: appUser, params: params!)
            }else{
                appUser.isCurrentlyLogin = false
                appUser.isCurrentUser = true
            }
        }
        self.saveContext()
    }
    
    fileprivate func updateAppUser(user : SAppUser, params : Dictionary<String, Any>){
        
        if let userDic = params["user"] as? Dictionary<String, Any>{
            user.isCurrentlyLogin = true
            user.isCurrentUser = true
            user.userId = userDic.validatedStringValue("id")
            user.role = userDic.validatedStringValue("role")
            user.loyaltyPoints = userDic.validatedStringValue("loyalityPoints")
            user.isEmailVerified = userDic.validatedBoolValue("isEmailVerified")
            user.isMobileVerified = userDic.validatedBoolValue("isMobileVerified")
            user.accountStatus = userDic.validatedStringValue("accountStatus")
            user.mobile = userDic.validatedStringValue("mobile")
            user.email = userDic.validatedStringValue("email")
            user.countryCode = userDic.validatedStringValue("countryCode")
            user.lastName = userDic.validatedStringValue("lastName")
            user.dob = userDic.validatedStringValue("dob")
            user.firstName = userDic.validatedStringValue("firstName")
            user.profileImage = userDic.validatedStringValue("profile")
            user.address = userDic.validatedStringValue("address")
        }
    }
    
    func updateTicketDetailData(params : Dictionary<String, Any>){
        
        let user = self.currentUser()
        if let dataArr = params["data"] as? Array<Dictionary<String, Any>>, dataArr.count > 0{
            if let dic = dataArr.first{
                let obj = SFTicket.newObject(entityName: "SFTicket") as! SFTicket
                obj.ticketHolder = dic.validatedStringValue("ticketHolder")
                obj.matchName = dic.validatedStringValue("matchName")
                obj.stadiumName = dic.validatedStringValue("stadiumname")
                obj.homeClub = dic.validatedStringValue("homeClub")
                obj.awayClub = dic.validatedStringValue("awayClub")
                obj.homeClubLogo = dic.validatedStringValue("homeClubLogo")
                obj.awayClubLogo = dic.validatedStringValue("awayClubLogo")
                obj.enterenceGate = dic.validatedStringValue("entranceGate")
                obj.stadiumZone = dic.validatedStringValue("zone")
                obj.seatNumber = dic.validatedStringValue("seatNumber")
                if let dateStr = dic["matchDate"] as? String{
                    obj.matchDate = dateStr.formatedDate(formatter: "yyyy-MM-dd HH:mm:ss")
                }
                user?.ticketDetail = obj
            }
        }
        self.saveContext()
    }
    
    func updateMatchListData(params : Dictionary<String, Any>){
        
        let user = self.currentUser()
        if let dataArr = params["data"] as? Array<Dictionary<String, Any>>{
            user?.removeFromMatchList((user?.matchList)!)
            for dic in dataArr{
                let obj = SFMatch.newObject(entityName: "SFMatch") as! SFMatch
                obj.orderIndex = dic.validatedInt16Value("orderIndex")
                obj.matchName = dic.validatedStringValue("matchName")
                obj.stadiumName = dic.validatedStringValue("stadiumname")
                obj.homeClub = dic.validatedStringValue("homeClub")
                obj.awayClub = dic.validatedStringValue("awayClub")
                obj.homeClubLogo = dic.validatedStringValue("homeClubLogo")
                obj.awayClubLogo = dic.validatedStringValue("awayClubLogo")
                if let dateStr = dic["matchDate"] as? String{
                    obj.matchDate = dateStr.formatedDate(formatter: "yyyy-MM-dd'T'HH:mm:ss.SSSZ")
                }
                user?.addToMatchList(obj)
            }
        }
        self.saveContext()
    }
    
    func updateNewsListData(params : Dictionary<String, Any>){
        
        let user = self.currentUser()
        if let dataDic = params["data"] as? Dictionary<String, Any>{
            if let dataArr = dataDic["results"] as? Array<Dictionary<String, Any>>{
                user?.removeFromNewsList((user?.newsList)!)
                for dic in dataArr{
                    let obj = SFNews.newObject(entityName: "SFNews") as! SFNews
                    obj.newId = dic.validatedStringValue("_id")
                    obj.title = dic.validatedStringValue("title")
                    obj.newsDescription = dic.validatedStringValue("description")
                    obj.newsBody = dic.validatedStringValue("body")
                    obj.coverImage = dic.validatedStringValue("coverImage")
                    obj.mainImage = dic.validatedStringValue("mainImage")
                    if let dateStr = dic["createdAt"] as? String{
                        obj.newsDate = dateStr.formatedDate(formatter: "yyyy-MM-dd'T'HH:mm:ss.SSSZ")
                    }
                    user?.addToNewsList(obj)
                }
            }
        }
        self.saveContext()
    }
    
    func updatePlayerListData(params : Dictionary<String, Any>){
        
        let user = self.currentUser()
        if let dataArr = params["data"] as? Array<Dictionary<String, Any>>{
            user?.removeFromPlayerSections((user?.playerSections)!)
            for dic in dataArr{
                let objSec = SFSection.newObject(entityName: "SFSection") as! SFSection
                objSec.categoryName = dic.validatedStringValue("category")
                if let goalArr = dic["players"] as? Array<Dictionary<String, Any>>{
                    for dic in goalArr{
                        let obj = SFPlayer.newObject(entityName: "SFPlayer") as! SFPlayer
                        self.updateMatchListDicToObj(player: obj, param: dic)
                        objSec.addToPlayers(obj)
                    }
                }
                user?.addToPlayerSections(objSec)
            }
        }
        self.saveContext()
    }
    
    fileprivate func updateMatchListDicToObj(player : SFPlayer, param : Dictionary<String, Any>){
        
        player.playerId = param.validatedStringValue("id")
        player.firstName = param.validatedStringValue("firstName")
        player.lastName = param.validatedStringValue("lastName")
        player.playerNumber = param.validatedStringValue("playerNumber")
        if let catDic = param["playerCategory"] as? Dictionary<String, Any>{
            player.playerCategory = catDic.validatedStringValue("name")
        }
        player.clubId = param.validatedStringValue("clubId")
        player.pictureUrl = param.validatedStringValue("picture")
    }
    
    func updateRestaurantListData(params : Dictionary<String, Any>){
        
        let user = self.currentUser()
        if let dataDic = params["data"] as? Dictionary<String, Any>{
            if let goalArr = dataDic["results"] as? Array<Dictionary<String, Any>>{
                user?.removeFromRestaurants((user?.restaurants)!)
                for dic in goalArr{
                    let obj = SFRestaurant.newObject(entityName: "SFRestaurant") as! SFRestaurant
                    self.updateRestaurantDicToObj(obj: obj, param: dic)
                    user?.addToRestaurants(obj)
                }
            }
        }
        self.saveContext()
    }
    
    fileprivate func updateRestaurantDicToObj(obj : SFRestaurant, param: Dictionary<String, Any>){
        
        if let locDic = param["location"] as? Dictionary<String, Any>{
            obj.address = locDic.validatedStringValue("address")
        }
        obj.role = param.validatedStringValue("role")
        obj.accountStatus = param.validatedStringValue("accountStatus")
        obj.isEmailVerified = param.validatedBoolValue("isEmailVerified")
        obj.isMobileVerified = param.validatedBoolValue("isMobileVerified")
        obj.email = param.validatedStringValue("email")
        obj.name = param.validatedStringValue("name")
        obj.mobile = param.validatedStringValue("mobile")
        obj.countryCode = param.validatedStringValue("countryCode")
        obj.profileImage = param.validatedStringValue("profile")
        obj.cusine = param.validatedStringValue("cusine")
        obj.restaurantId = param.validatedStringValue("id")
        obj.rating = param.validatedStringValue("rating")
    }
    
    func updateRestaurantMenuListData(resto : SFRestaurant, params : Dictionary<String, Any>){
        
        if let dataArr = params["data"] as? Array<Dictionary<String, Any>>{
            resto.removeFromMenuSections((resto.menuSections)!)
            for dic in dataArr{
                let objSec = SFSection.newObject(entityName: "SFSection") as! SFSection
                objSec.categoryName = dic.validatedStringValue("category")
                if let menuArr = dic["menu"] as? Array<Dictionary<String, Any>>{
                    for dic in menuArr{
                        let obj = SFMenuItem.newObject(entityName: "SFMenuItem") as! SFMenuItem
                        self.updateMenuListDicToObj(product: obj, param: dic)
                        objSec.addToItems(obj)
                    }
                }
                resto.addToMenuSections(objSec)
            }
        }
        self.saveContext()
    }
    
    fileprivate func updateMenuListDicToObj(product : SFMenuItem, param : Dictionary<String, Any>){
        
        product.status = param.validatedBoolValue("status")
        product.isRecommended = param.validatedBoolValue("recommended")
        product.type = param.validatedStringValue("type")
        product.productId = param.validatedStringValue("_id")
        product.name = param.validatedStringValue("name")
        product.price = param.validatedDoubleValue("price")
        product.productImage = param.validatedStringValue("image")
        if let images = param["images"] as? Array<String>{
            product.productImage = images.first
            for strImage in images{
                let obj = SFSubItem.newObject(entityName: "SFSubItem") as! SFSubItem
                obj.image = strImage
                product.addToImageList(obj)
            }
        }
        if let dataArr = param["variants"] as? Array<Dictionary<String, Any>>{
            for dic in dataArr{
                let varientobj = SFSubItem.newObject(entityName: "SFSubItem") as! SFSubItem
                varientobj.status = dic.validatedBoolValue("status")
                varientobj.itemId = dic.validatedStringValue("_id")
                varientobj.name = dic.validatedStringValue("name")
                varientobj.price = dic.validatedDoubleValue("price")
                product.addToVarients(varientobj)
            }
        }
        
        if let dataArr = param["additionalItems"] as? Array<Dictionary<String, Any>>{
            for dic in dataArr{
                let varientobj = SFSubItem.newObject(entityName: "SFSubItem") as! SFSubItem
                varientobj.status = dic.validatedBoolValue("status")
                varientobj.itemId = dic.validatedStringValue("_id")
                varientobj.name = dic.validatedStringValue("name")
                varientobj.price = dic.validatedDoubleValue("price")
                varientobj.image = dic.validatedStringValue("image")
                product.addToAdditionalItems(varientobj)
            }
        }
        
        if let cartDic = param["cart"] as? Dictionary<String, Any>{
            
            product.quantity = cartDic.validatedInt64Value("quantity")
            product.lastQuantity = cartDic.validatedInt64Value("lastQuantity")
            product.menuId = cartDic.validatedStringValue("_id")
            product.lastVarientId = cartDic.validatedStringValue("variant")
            if let dataArr = param["additionalItems"] as? Array<Dictionary<String, Any>>{
                var itemArr = [String]()
                for dic in dataArr{
                    itemArr.append(dic.validatedStringValue("_id"))
                }
                if itemArr.count > 0{
                    product.lastAdditionalItem = itemArr.joined(separator: ",")
                }
            }
        }
    }
    
    func updateRestaurantSouvenierListData(resto : SFRestaurant, params : Dictionary<String, Any>){
        
        if let dataArr = params["data"] as? Array<Dictionary<String, Any>>{
            resto.removeFromSouvenierList((resto.souvenierList)!)
            for dic in dataArr{
                let objSec = SFMenuItem.newObject(entityName: "SFMenuItem") as! SFMenuItem
                self.updateSouveniorListDicToObj(product: objSec, param: dic)
                resto.addToSouvenierList(objSec)
            }
        }
        self.saveContext()
    }
    
    func updatePlayerSouvenierListData(resto : SFPlayer, params : Dictionary<String, Any>){
        
        if let dataArr = params["data"] as? Array<Dictionary<String, Any>>{
            resto.removeFromSouvenierList((resto.souvenierList)!)
            for dic in dataArr{
                let objSec = SFMenuItem.newObject(entityName: "SFMenuItem") as! SFMenuItem
                self.updateSouveniorListDicToObj(product: objSec, param: dic)
                resto.addToSouvenierList(objSec)
            }
        }
        self.saveContext()
    }
    
    fileprivate func updateSouveniorListDicToObj(product : SFMenuItem, param : Dictionary<String, Any>){
        
        product.status = param.validatedBoolValue("status")
        product.productId = param.validatedStringValue("id")
        product.name = param.validatedStringValue("name")
        product.price = param.validatedDoubleValue("price")
        product.restaurantId = param.validatedStringValue("restaurant")
        
        if let images = param["images"] as? Array<String>{
            product.productImage = images.first
            for strImage in images{
                let obj = SFSubItem.newObject(entityName: "SFSubItem") as! SFSubItem
                obj.image = strImage
                product.addToImageList(obj)
            }
        }
        product.stock = param.validatedInt64Value("stock")
        
        if let cartDic = param["cart"] as? Dictionary<String, Any>{
            
            product.quantity = cartDic.validatedInt64Value("quantity")
            product.menuId = cartDic.validatedStringValue("_id")
            product.lastQuantity = cartDic.validatedInt64Value("lastQuantity")
            product.lastVarientId = cartDic.validatedStringValue("variant")
        }
        
        if let varients = param["variants"] as? Array<Dictionary<String, Any>>{
            for dic in varients{
                let varientobj = SFSubItem.newObject(entityName: "SFSubItem") as! SFSubItem
                varientobj.itemId = dic.validatedStringValue("_id")
                varientobj.name = dic.validatedStringValue("name")
                varientobj.price = dic.validatedDoubleValue("price")
                varientobj.image = dic.validatedStringValue("image")
                product.addToVarients(varientobj)
            }
        }
//        if let playerIdDic = param["playerId"] as? Dictionary<String, Any>{
//            product.productId = playerIdDic.validatedStringValue("id")
//        }
        
    }
    
    func updateUserCartData(params : Dictionary<String, Any>){
        
        let appUser = self.currentUser()
        if let dataDic = params["data"] as? Dictionary<String, Any>{
            
            if let items = dataDic["items"] as? Array<Dictionary<String, Any>>{
                appUser?.userCart?.removeFromCartItems((appUser?.userCart?.cartItems)!)
                for dic in items{
                    let obj = SFMenuItem.newObject(entityName: "SFMenuItem") as! SFMenuItem
                    self.updateCartItemDicToObj(product: obj, param: dic)
                    appUser?.userCart?.addToCartItems(obj)
                }
            }
            
            if let restoDic = dataDic["restaurantId"] as? Dictionary<String, Any>{
                
                let obj = SFRestaurant.newObject(entityName: "SFRestaurant") as! SFRestaurant
                obj.name = restoDic.validatedStringValue("name")
                obj.profileImage = restoDic.validatedStringValue("profile")
                obj.cusine = restoDic.validatedStringValue("cusine")
                obj.restaurantId = restoDic.validatedStringValue("id")
                obj.rating = restoDic.validatedStringValue("rating")
                appUser?.userCart?.restaurant = obj
            }
        }
        self.saveContext()
    }
    
    fileprivate func updateCartItemDicToObj(product : SFMenuItem, param : Dictionary<String, Any>){
        
        product.productId = param.validatedStringValue("_id")
        product.quantity = param.validatedInt64Value("quantity")
        product.varientId = param.validatedStringValue("variant")
        product.totalPrice = param.validatedDoubleValue("totalPrice")
        
        if let additionalItems = param["additionalItems"] as? Array<Dictionary<String, Any>>{
            for dic in additionalItems{
                let varientobj = SFSubItem.newObject(entityName: "SFSubItem") as! SFSubItem
                varientobj.itemId = dic.validatedStringValue("_id")
                varientobj.name = dic.validatedStringValue("name")
                varientobj.price = dic.validatedDoubleValue("price")
                varientobj.image = dic.validatedStringValue("image")
                product.addToAdditionalItems(varientobj)
            }
        }
        if let itemDic = param["menuId"] as? Dictionary<String, Any>{
            
            product.menuId = itemDic.validatedStringValue("_id")
            product.status = itemDic.validatedBoolValue("status")
            product.name = itemDic.validatedStringValue("name")
            product.price = itemDic.validatedDoubleValue("price")
            if let images = itemDic["images"] as? [String], images.count > 0{
                product.productImage = images.first
            }
            //product.productImage = itemDic.validatedStringValue("image")
            product.restaurantId = itemDic.validatedStringValue("restaurant")
            if let varients = itemDic["variants"] as? Array<Dictionary<String, Any>>{
                let selVarients = varients.filter { dic in
                    return dic.validatedStringValue("_id") == product.varientId
                }
                for dic in selVarients{
                    let varientobj = SFSubItem.newObject(entityName: "SFSubItem") as! SFSubItem
                    varientobj.itemId = dic.validatedStringValue("_id")
                    varientobj.name = dic.validatedStringValue("name")
                    varientobj.price = dic.validatedDoubleValue("price")
                    varientobj.image = dic.validatedStringValue("image")
                    product.addToVarients(varientobj)
                }
            }
        }else if let itemDic = param["souvenierId"] as? Dictionary<String, Any>{
            product.isSauvenior = true
            product.menuId = itemDic.validatedStringValue("id")
            product.status = itemDic.validatedBoolValue("status")
            product.name = itemDic.validatedStringValue("name")
            product.price = itemDic.validatedDoubleValue("price")
            if let images = itemDic["images"] as? [String], images.count > 0{
                product.productImage = images.first
            }
            if let varients = itemDic["variants"] as? Array<Dictionary<String, Any>>{
                let selVarients = varients.filter { dic in
                    return dic.validatedStringValue("_id") == product.varientId
                }
                for dic in selVarients{
                    let varientobj = SFSubItem.newObject(entityName: "SFSubItem") as! SFSubItem
                    varientobj.itemId = dic.validatedStringValue("_id")
                    varientobj.name = dic.validatedStringValue("name")
                    varientobj.price = dic.validatedDoubleValue("price")
                    varientobj.image = dic.validatedStringValue("image")
                    product.addToVarients(varientobj)
                }
            }
        }
    }
    
    func updateNotificationListData(params : Dictionary<String, Any>){
        
        let appUser = self.currentUser()
        if let dataDic = params["data"] as? Dictionary<String, Any>{
            if let list = dataDic["results"] as? Array<Dictionary<String, Any>>{
                appUser?.removeFromNotificationList((appUser?.notificationList)!)
                for dic in list{
                    let obj = SFNotification.newObject(entityName: "SFNotification") as! SFNotification
                    self.updateNotificationDicToObj(obj: obj, param: dic)
                    appUser?.addToNotificationList(obj)
                }
            }
        }
    }
    
    fileprivate func updateNotificationDicToObj(obj : SFNotification, param : Dictionary<String, Any>){
        
        obj.isRead = param.validatedBoolValue("read")
        obj.useFor = param.validatedStringValue("for")
        obj.userId = param.validatedStringValue("userId")
        obj.type = param.validatedStringValue("type")
        obj.message = param.validatedStringValue("message")
        obj.notificationId = param.validatedStringValue("id")
        obj.orderId = param.validatedStringValue("orderId")
        obj.orderNumber = param.validatedStringValue("customOrderId")
        if let dateStr = param["createdAt"] as? String{
            obj.notificationDate = dateStr.formatedDate(formatter: "yyyy-MM-dd'T'HH:mm:ss.SSSZ")
        }
    }
    
    func updatePassbookListData(params : Dictionary<String, Any>){
        
        let appUser = self.currentUser()
        if let dataDic = params["data"] as? Dictionary<String, Any>{
            if let list = dataDic["results"] as? Array<Dictionary<String, Any>>{
                appUser?.removeFromUserPassbookEntries((appUser?.userPassbookEntries)!)
                for dic in list{
                    let obj = SFNotification.newObject(entityName: "SFNotification") as! SFNotification
                    self.updatePassbookDicToObj(obj: obj, param: dic)
                    appUser?.addToUserPassbookEntries(obj)
                }
            }
        }
    }
    
    fileprivate func updatePassbookDicToObj(obj : SFNotification, param : Dictionary<String, Any>){
        
        obj.type = param.validatedStringValue("type")
        obj.notificationId = param.validatedStringValue("_id")
        obj.message = param.validatedStringValue("description")
        obj.amount = param.validatedDoubleValue("amount")
        obj.useFor = param.validatedStringValue("currency")
        obj.title = param.validatedStringValue("title")
        
        if let dateStr = param["createdAt"] as? String{
            obj.notificationDate = dateStr.formatedDate(formatter: "yyyy-MM-dd'T'HH:mm:ss.SSSZ")
        }
    }
    
    func updateOrderListData(isPagination : Bool, params : Dictionary<String, Any>){
        
        let appUser = self.currentUser()
        if let dataDic = params["data"] as? Dictionary<String, Any>{
            if let list = dataDic["results"] as? Array<Dictionary<String, Any>>{
                if !isPagination{
                    appUser?.removeFromMyOrders((appUser?.myOrders)!)
                }
                for dic in list{
                    let obj = SFOrder.newObject(entityName: "SFOrder") as! SFOrder
                    self.updateOrderDicToObj(obj: obj, param: dic)
                    appUser?.addToMyOrders(obj)
                }
            }
        }
        self.saveContext()
    }
    
    fileprivate func updateOrderDicToObj(obj : SFOrder, param : Dictionary<String, Any>){
        
        obj.orderId = param.validatedStringValue("id")
        obj.customId = param.validatedStringValue("customId")
        obj.orderType = param.validatedStringValue("orderType")
        obj.tipAmount = param.validatedDoubleValue("tipAmount")
        obj.status = param.validatedStringValue("status")
        obj.deliveryMode = param.validatedStringValue("deliveryMode")
        obj.orderTime = param.validatedStringValue("orderTime")
        obj.orderPrice = param.validatedDoubleValue("price")
        obj.rating = param.validatedDoubleValue("isRated")
        if let date = param["orderDate"] as? String{
            obj.orderDate = date.formatedDate(formatter: "yyyy-MM-dd'T'HH:mm:ss.SSSZ")
        }
        
        if let restaurentDic = param["restaurantId"] as? Dictionary<String, Any>{
            
            let objResto = SFRestaurant.newObject(entityName: "SFRestaurant") as! SFRestaurant
            objResto.name = restaurentDic.validatedStringValue("name")
            objResto.profileImage = restaurentDic.validatedStringValue("profile")
            objResto.restaurantId = restaurentDic.validatedStringValue("id")
            if let locDic = restaurentDic["location"] as? Dictionary<String, Any>{
                objResto.address = locDic.validatedStringValue("address")
            }
            obj.restaurent = objResto
        }
        if let cartArr = param["cart"] as? Array<Dictionary<String, Any>>{
            
            for dic in cartArr{
                let objItem = SFMenuItem.newObject(entityName: "SFMenuItem") as! SFMenuItem
                objItem.price = dic.validatedDoubleValue("unitPrice")
                objItem.quantity = dic.validatedInt64Value("quantity")
                if let menuDic = dic["menuId"] as? Dictionary<String, Any>{
                    objItem.productImage = menuDic.validatedStringValue("image")
                    objItem.name = menuDic.validatedStringValue("name")
                }else if let menuDic = dic["souvenierId"] as? Dictionary<String, Any>{
                    objItem.name = menuDic.validatedStringValue("name")
                    if let images = menuDic["images"] as? [String], images.count > 0{
                        objItem.productImage = images.first
                    }
                }
                obj.addToItems(objItem)
            }
        }
        if let trackArr = param["trakingList"] as? Array<Dictionary<String, Any>>{
            
            for dic in trackArr{
                let objItem = SFSection.newObject(entityName: "SFSection") as! SFSection
                objItem.status = dic.validatedBoolValue("select")
                objItem.categoryName = dic.validatedStringValue("key")
                obj.addToTrackList(objItem)
            }
        }
    }
    
    func updateOrderDetailData(isFromCustomIdOrder : Bool = false, order: SFOrder, params : Dictionary<String, Any>){
        
        if let dataDic = params["data"] as? Dictionary<String, Any>{
            
            if isFromCustomIdOrder{
                self.updateOrderDicToObj(obj: order, param: dataDic)
            }
            order.deliveryCharge = dataDic.validatedDoubleValue("deliveryCharge")
            order.seatDetails = dataDic.validatedStringValue("seatDetails")
            order.seatNumber = dataDic.validatedStringValue("seatNumber")
            order.paymentMode = dataDic.validatedStringValue("paymentMode")
            order.deliveryMode = dataDic.validatedStringValue("deliveryMode")
        }
        self.saveContext()
    }

}

//MARK ManagedObject
extension NSManagedObject {
    
    class func newObject(entityName : String) -> NSManagedObject? {
        
//        guard  let entityName = self.entity().name else {
//            return nil
//        }
        
        let context = SCoreDataHelper.shared.persistentContainer.viewContext
        let managedObject = NSEntityDescription.insertNewObject(forEntityName: entityName, into: context)
        return managedObject
    }
    
    func deepCopy(copyRelations: Bool, excludeKey:[String]?) -> NSManagedObject? {
        
        guard let context = managedObjectContext, let entityName = entity.name else { return nil }
        let copied = NSEntityDescription.insertNewObject(forEntityName: entityName, into: context)
        let attributes = entity.attributesByName
        for (attrKey, _) in attributes {
            copied.setValue(value(forKey: attrKey), forKey: attrKey)
        }
        
        if copyRelations {
            let relations = entity.relationshipsByName
            
            for (relKey, relValue) in relations {
                
                if !(excludeKey?.contains(relKey))! {
                    if relValue.isToMany {
                        
                        if relValue.isOrdered {
                            let sourceSet = mutableOrderedSetValue(forKey: relKey)
                            let clonedSet = copied.mutableOrderedSetValue(forKey: relKey)
                            let enumerator = sourceSet.objectEnumerator()
                            
                            while let relatedObject = enumerator.nextObject()  {
                                let clonedRelatedObject = (relatedObject as! NSManagedObject).deepCopy(copyRelations: false, excludeKey: nil)
                                clonedSet.add(clonedRelatedObject!)
                            }
                        }else {
                            let sourceSet = mutableSetValue(forKey: relKey)
                            let clonedSet = copied.mutableSetValue(forKey: relKey)
                            let enumerator = sourceSet.objectEnumerator()
                            
                            while let relatedObject = enumerator.nextObject()  {
                                let clonedRelatedObject = (relatedObject as! NSManagedObject).deepCopy(copyRelations: false, excludeKey: nil)
                                clonedSet.add(clonedRelatedObject!)
                            }
                        }
                    }else {
                        copied.setValue(value(forKey: relKey), forKey: relKey)
                    }
                }
            }
        }
        
        return copied
    }
}
