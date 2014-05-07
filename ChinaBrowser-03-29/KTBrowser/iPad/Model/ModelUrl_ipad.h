//
//  ModelUrl_ipad.h
//

#import <Foundation/Foundation.h>

#import "ModelFavorite.h"

@interface ModelUrl_ipad : ModelFavorite

@property (nonatomic, strong) NSString *icon;

+ (ModelUrl_ipad *)model;
+ (ModelUrl_ipad *)modelWithDic:(NSDictionary *)dic;

@end
