//
//  ModelUrl_ipad.m
//

#import "ModelUrl_ipad.h"

@implementation ModelUrl_ipad

+ (ModelUrl_ipad *)model {
    ModelUrl_ipad *modelUrl = [[ModelUrl_ipad alloc] init];
    return modelUrl;
}

+ (ModelUrl_ipad *)modelWithDic:(NSDictionary *)dic {
    if (![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    ModelUrl_ipad *modelUrl = [self model];
    NSString *title = [dic objectForKey:@"name"];
    if ([title isKindOfClass:[NSString class]]) {
        modelUrl.title = title;
    }
    NSString *link = [dic objectForKey:@"link"];
    if ([link isKindOfClass:[NSString class]]) {
        modelUrl.link = link;
    }
    NSString *icon = [dic objectForKey:@"icon"];
    if ([icon isKindOfClass:[NSString class]]) {
        modelUrl.icon = icon;
    }
    
    return modelUrl;
}

@end
