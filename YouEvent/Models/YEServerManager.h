//
//  IGServerManager.h
//  YouEvent
//
//  Created by Igor guk on 20.11.15.
//  Copyright (c) 2015 Igor Guk. All rights reserved.
//

@import Foundation;
@import CoreData;

@interface YECategory : NSObject

@property(nonatomic, assign) NSUInteger identifier;
@property(nonatomic, assign) NSUInteger order;
@property(nonatomic, strong) NSString *title;

@end

typedef NS_ENUM(NSUInteger, YEStatusCode) {
    YEStatusCodeInvalidResponse = 0,
    YEStatusCodeCategoriesOK = 100,
    YEStatusCodeCategoriesMySQLError = 101,
    YEStatusCodeCategoriesNoCategories = 102,
    YEStatusCodeFeedOK = 200,
    YEStatusCodeFeedMySQLError = 201,
};

@interface YEParser : NSObject

@end

@interface YECategoryParser : YEParser

@property(nonatomic, strong) NSManagedObjectContext *context;

@end

@interface YEServerManager : NSObject

@property (nonatomic, strong) YECategoryParser *categoryParser;

+ (YEServerManager *)sharedManager;
- (void)getCategoriesWithOrder:(NSInteger)order
                     onSuccess:(void(^)(NSArray *categories, YEStatusCode statusCode))success
                     onFailure:(void(^)(NSError *error, YEStatusCode statusCode))failure;

@end
