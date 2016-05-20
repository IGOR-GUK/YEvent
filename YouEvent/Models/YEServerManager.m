//
//  IGServerManager.m
//  YouEvent
//
//  Created by Igor guk on 20.11.15.
//  Copyright (c) 2015 Igor Guk. All rights reserved.
//

#import "YEServerManager.h"
#import "AFNetworking.h"

@import CoreData;

@implementation YECategory

@end

@implementation YEParser

- (NSError *)errorFromResponse:(id)responseObject {
    return nil;
}

- (YEStatusCode)statusCodeFromResponse:(id)responseObject {
    NSDictionary *response = responseObject;
    return [response[@"status"] integerValue];
}

- (id)decodedDataFromResponse:(id)responseObject {
    return nil;
}

@end

@implementation YECategoryParser

- (NSError *)errorFromResponse:(id)responseObject {
    NSDictionary *response = responseObject;
    
    if ([response isKindOfClass:[NSDictionary class]] == NO) {
        return [NSError errorWithDomain:@"dictionary response expected" code:2 userInfo:nil];
    }
    YEStatusCode statusCode = [self statusCodeFromResponse:responseObject];
    
    if (statusCode == YEStatusCodeCategoriesMySQLError) {
        return [NSError errorWithDomain:@"got MySQL error" code:3 userInfo:nil];
    }
    return nil;
}

- (id)validatedValue:(id)value {
    NSNull *null = [NSNull null];
    
    if (value == null) {
        return nil;
    } else {
        return value;
    }
}

- (id)decodedDataFromResponse:(id)responseObject {
    
    NSDictionary *response = responseObject;
    NSArray *categoryDictionaries = response[@"result"];
    NSMutableArray *categories = [[NSMutableArray alloc] initWithCapacity:categoryDictionaries.count];
    
    for (NSDictionary *categoryDictionary in categoryDictionaries) {
        
        NSString *identifier = [self validatedValue:categoryDictionary[@"cat_id"]];
        NSString *order      = [self validatedValue:categoryDictionary[@"order"]];
        NSString *title      = [self validatedValue:categoryDictionary[@"title"]];
        
        YECategory *category = [self existingCategoryWithId:[identifier integerValue]];
        if (category == nil) {
            category = [self newCategory];
        }
        category.identifier = [identifier integerValue];
        category.order      = [order integerValue];
        category.title      = title;
        [categories addObject:category];
    }
    
    [categories sortedArrayUsingComparator:^NSComparisonResult(YECategory* obj1, YECategory *obj2) {
        
        if (obj1.order == obj2.order) {
            return NSOrderedSame;
        }
        return obj1.order < obj2.order? NSOrderedAscending : NSOrderedDescending;
    }];
    return categories;
}

- (YECategory *)existingCategoryWithId:(NSUInteger)catId {
    return nil;
}

- (YECategory *)newCategory {
    return [YECategory new];
}

@end

@interface YEServerManager ()

@property (nonatomic, strong) AFHTTPRequestOperationManager *requestOperationManager;

@end

@implementation YEServerManager

+ (YEServerManager *)sharedManager {
    static YEServerManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[YEServerManager alloc] init];
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.categoryParser = [self defaultCategoryParser];
        NSURL *url = [NSURL URLWithString:@"http://event.ideanet.com.ua/api/"];
        self.requestOperationManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
        
        NSMutableSet *acceptableContentTypes = [self.requestOperationManager.responseSerializer.acceptableContentTypes mutableCopy];
        if (acceptableContentTypes == nil) {
            acceptableContentTypes = [NSMutableSet new];
        }
        [acceptableContentTypes addObject:@"text/html"];
        self.requestOperationManager.responseSerializer.acceptableContentTypes = acceptableContentTypes;
    }
    return self;
}

- (YECategoryParser *)defaultCategoryParser {
    YECategoryParser *parser = [YECategoryParser new];
    return parser;
}

- (void)getDataFromServerAtEndpoint:(NSString *)endpoint
                         parameters:(NSDictionary *)params
                             parser:(YEParser *)parser
                          onSuccess:(void(^)(NSArray *categories, YEStatusCode statusCode))success
                          onFailure:(void(^)(NSError *error, YEStatusCode statusCode))failure {
    
    if (parser == nil) {
        if (failure) {
            failure([NSError errorWithDomain:@"" code:0 userInfo:nil], YEStatusCodeInvalidResponse);
        }
        return;
    }
    
    [self.requestOperationManager GET:endpoint
                           parameters:params
                              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                  NSError *error = [parser errorFromResponse:responseObject];
                                  YEStatusCode statusCode = [parser statusCodeFromResponse:responseObject];
                                  
                                  if (error == nil) {
                                      if (success) {
                                          id decodedData = [parser decodedDataFromResponse:responseObject];
                                          success(decodedData, statusCode);
                                      }
                                  } else {
                                      if (failure) {
                                          failure(error, statusCode);
                                      }
                                  }
                              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                  if (failure) {
                                      failure(error, YEStatusCodeInvalidResponse);
                                  }
                              }];
}

- (void)getCategoriesWithOrder:(NSInteger)order
                     onSuccess:(void(^)(NSArray *categories, YEStatusCode statusCode))success
                     onFailure:(void(^)(NSError *error, YEStatusCode statusCode))failure {
    
    [self getDataFromServerAtEndpoint:@"categories"
                           parameters:nil
                               parser:self.categoryParser
                            onSuccess:success
                            onFailure:failure];
}

@end
