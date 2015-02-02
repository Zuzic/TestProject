//
//  NSArray+Filter.m
//  TestProject
//
//  Created by Yury Zenko on 01.02.15.
//  Copyright (c) 2015 zenkoyury. All rights reserved.
//

#import "NSArray+Filter.h"
#import "ContactModel.h"

#define CITY_NAME @"SAN FRANCISCO"

@implementation NSArray (Filter)

-(void) filterArrayByCity:(NSString*)cityName contactArray:(NSArray*)contactArray callback:(ArrayFilterCallback) callback{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *correctCity = [NSArray new];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"city like[cd] %@", cityName];
        NSArray *filteredArray = [contactArray filteredArrayUsingPredicate:predicate];
        
        if(filteredArray.count>0){
            correctCity = filteredArray;
            
            NSMutableArray *fullContactArray = [NSMutableArray arrayWithArray:contactArray];
            [fullContactArray removeObjectsInArray:correctCity];
            
            if(callback)
                dispatch_async(dispatch_get_main_queue(), ^{
                    callback(correctCity, fullContactArray);
                });
        }
        else{
            if(callback)
                dispatch_async(dispatch_get_main_queue(), ^{
                    callback(correctCity, contactArray);
                });
            
        }
    });

}

-(void) filterArrayCurrentCityWithArray:(NSArray*)contactArray callback:(ArrayFilterCallback) callback{
    [self filterArrayByCity:CITY_NAME contactArray:contactArray callback:callback];
}

+(NSArray*) searchByText:(NSString*)searchText array:(NSArray*)array{
    if(array.count>1){
        NSArray *currentCityArray = [array objectAtIndex:0];
        NSArray *otherArray = [array objectAtIndex:1];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"city contains[cd] %@ OR firstName contains[cd] %@ OR lastName contains[cd] %@", searchText.lowercaseString, searchText.lowercaseString, searchText.lowercaseString];
        NSArray *filteredArray = [currentCityArray filteredArrayUsingPredicate:predicate];
        
        currentCityArray = [NSArray new];
        if(filteredArray.count>0){
            currentCityArray = filteredArray;
        }
        
        filteredArray = [otherArray filteredArrayUsingPredicate:predicate];
        otherArray = [NSArray new];
        
        if(filteredArray.count>0){
            otherArray = filteredArray;
        }
        
        return @[currentCityArray, otherArray];
    }
    else{
        return @[[NSArray new], [NSArray new]];
    }
}

@end
