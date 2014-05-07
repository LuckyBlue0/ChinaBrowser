//
//  ShareSDKPackage.m
//

#import "ShareSDKPackage.h"

#import <AGCommon/UIDevice+Common.h>

#import <ShareSDK/ShareSDK.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"

#import "ViewIndicator.h"

#pragma mark - weibo 新浪微博
// weibo.com
#define app_key_sina  @"1378692948"
#define app_secret_sina  @"50153c82cc417a54e4092e1b5209e467"
#define url_redirect_sina  @"http://www.diankai.net/user.php?action=passport_callback&type=weibo"

#pragma mark - tx 腾讯微博
// t.qq.com
#define app_key_tx  @"801307492"
#define app_secret_tx  @"99949301e76894a88e1322150bcc4ff2"
#define url_redirect_tx  @"http://www.diankai.net/user.php?action=passport_callback&type=tqq"

#pragma mark - tx 腾讯QQ空间
#define QQSpaceKey @"100559322"
#define QQSpaceSecret @"ef201e36a5a5b7afe52c27d501b1fb53"

#pragma mark -微信
#define WeiXinKey @"wxe0376491a8240141"
#define WeiXinAppId @"wxe0376491a8240141"

#pragma mark - ShareSDK_AppKey
#define ShareSDK_AppKey @"cfaa442214b"

#define kTipsWithAuth @"授权成功后会自动分享"

@implementation ShareSDKPackage

static ShareSDKPackage *instance;

+ (ShareSDKPackage *)shareShareSDKPackage {
    if(instance == nil) {
        instance = [[ShareSDKPackage alloc] init];
    }
    return instance;
}

- (void)registerSDK_KEYS {
    [ShareSDK registerApp:ShareSDK_AppKey];//sharesdk key
    
    [ShareSDK connectMail];
    
    //添加新浪微博应用
    [ShareSDK connectSinaWeiboWithAppKey:app_key_sina
                               appSecret:app_secret_sina
                             redirectUri:url_redirect_sina];
    
    //添加腾讯微博应用
    [ShareSDK connectTencentWeiboWithAppKey:app_key_tx
                                  appSecret:app_secret_tx
                                redirectUri:url_redirect_tx];
    //添加QQ空间应用
    [ShareSDK connectQZoneWithAppKey:QQSpaceKey
                           appSecret:QQSpaceSecret
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
    //添加微信应用
    [ShareSDK connectWeChatWithAppId:WeiXinKey       //此参数为申请的微信AppID
                           wechatCls:[WXApi class]];
    //添加QQ应用
    [ShareSDK connectQQWithQZoneAppKey:QQSpaceKey                 //该参数填入申请的QQ AppId
                     qqApiInterfaceCls:[QQApiInterface class]
                       tencentOAuthCls:[TencentOAuth class]];
}

- (void)shareWithType:(int)type andTitle:(NSString *)title andContent:(NSString *)content andUrl:(NSString *)url andDescription:(NSString *)description andImage:(NSString *)imagePath {
    title = title?title:@"";
    content = content?content:@"";
    url = url?url:@"";
    description = description?description:@"";
    imagePath = imagePath?imagePath:@"";
    
    //创建容器
    id<ISSContainer> container = [ShareSDK container];
    
    if ([[UIDevice currentDevice] isPad]) {
        [container setIPadContainerWithView:[UIApplication sharedApplication].keyWindow
                                arrowDirect:UIPopoverArrowDirectionUp];
    }
    else
    {
        [container setIPhoneContainerWithViewController:_rootViewController];
    }
    
    id<ISSContent> publishContent = [ShareSDK content:content
                                       defaultContent:content
                                                image:[ShareSDK imageWithPath:imagePath]
                                                title:title
                                                  url:url
                                          description:description
                                            mediaType:SSPublishContentMediaTypeNews];
    
    [publishContent addSinaWeiboUnitWithContent:[NSString stringWithFormat:@"%@ @%@ %@",description,kAppName,url] image:INHERIT_VALUE];
    [publishContent addTencentWeiboUnitWithContent:[NSString stringWithFormat:@"%@ %@ %@",description,kAppName,url] image:INHERIT_VALUE];
    [publishContent addQQUnitWithType:[NSNumber numberWithInt:SSPublishContentMediaTypeNews] content:[NSString stringWithFormat:@"%@ %@ %@",description,kAppName,url] title:title url:url image:INHERIT_VALUE];
    //定制微信好友信息
    [publishContent addWeixinSessionUnitWithType:INHERIT_VALUE
                                         content:[NSString stringWithFormat:@"%@ %@ %@",description,kAppName,url]
                                           title:INHERIT_VALUE
                                             url:INHERIT_VALUE
                                           image:INHERIT_VALUE
                                    musicFileUrl:nil
                                         extInfo:nil
                                        fileData:nil
                                    emoticonData:nil];
    [publishContent addWeixinTimelineUnitWithType:[NSNumber numberWithInteger:SSPublishContentMediaTypeMusic]
                                          content:[NSString stringWithFormat:@"%@ %@ %@",description,kAppName,url]
                                            title:INHERIT_VALUE
                                              url:url
                                            image:INHERIT_VALUE
                                     musicFileUrl:nil
                                          extInfo:nil
                                         fileData:nil
                                     emoticonData:nil];
    //定制邮件信息
    [publishContent addMailUnitWithSubject:title
                                   content:[NSString stringWithFormat:@"%@ %@ %@",description,kAppName,url]
                                    isHTML:[NSNumber numberWithBool:YES]
                               attachments:INHERIT_VALUE
                                        to:nil
                                        cc:nil
                                       bcc:nil];
    
    //分享设置
//    id<ISSShareOptions> shareOptions = [ShareSDK defaultShareOptionsWithTitle:nil
//                                                              oneKeyShareList:[NSArray defaultOneKeyShareList]
//                                                               qqButtonHidden:NO
//                                                        wxSessionButtonHidden:NO
//                                                       wxTimelineButtonHidden:NO
//                                                         showKeyboardOnAppear:NO
//                                                            shareViewDelegate:nil
//                                                          friendsViewDelegate:nil
//                                                        picViewerViewDelegate:nil];
    //分享认证
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:nil];
    
    if(type == ShareTypeSinaWeibo) {
        if([ShareSDK hasAuthorizedWithType:ShareTypeSinaWeibo])
            [ViewIndicator showWithStatus:@"新浪微博分享中..."];
        else {
            [ViewIndicator showSuccessWithStatus:kTipsWithAuth duration:1.0];
        }
        
        [ShareSDK shareContent:publishContent
                          type:ShareTypeSinaWeibo
                   authOptions:authOptions
                 statusBarTips:YES
                        result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                            
                            if (state == SSPublishContentStateSuccess)
                            {
                                [ViewIndicator showSuccessWithStatus:@"新浪微博分享成功!" duration:1.0];
                            }
                            else if (state == SSPublishContentStateFail)
                            {
                                [ViewIndicator showErrorWithStatus:@"新浪微博分享失败！" duration:1.0];
                                NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
                            }
                        }];
    }
    else if (type == ShareTypeTencentWeibo) {
        if([ShareSDK hasAuthorizedWithType:ShareTypeTencentWeibo])
            [ViewIndicator showWithStatus:@"腾讯微博分享中..."];
        else [ViewIndicator showSuccessWithStatus:kTipsWithAuth duration:1.0];
        [ShareSDK shareContent:publishContent
                          type:ShareTypeTencentWeibo
                   authOptions:authOptions
                 statusBarTips:YES
                        result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                            
                            if (state == SSPublishContentStateSuccess) {
                                [ViewIndicator showSuccessWithStatus:@"腾讯微博分享成功!" duration:1.0];
                                NSLog(@"分享成功");
                            }
                            else if (state == SSPublishContentStateFail)
                            {
                                [ViewIndicator showErrorWithStatus:@"腾讯微博分享失败!" duration:1.0];
                                NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
                            }
                        }];
    }
    else if(type == ShareTypeQQSpace) {
        if([ShareSDK hasAuthorizedWithType:ShareTypeQQSpace])
            [ViewIndicator showWithStatus:@"QQ空间分享中..."];
        else
            [ViewIndicator showSuccessWithStatus:kTipsWithAuth duration:1.0];
        [ShareSDK shareContent:publishContent
                          type:ShareTypeQQSpace
                   authOptions:authOptions
                 statusBarTips:YES
                        result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                            
                            if (state == SSPublishContentStateSuccess)
                            {
                                [ViewIndicator showSuccessWithStatus:@"QQ空间分享成功!" duration:1.0];
                                NSLog(@"分享成功");
//                                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationShareSNS object:nil];
                            }
                            else if (state == SSPublishContentStateFail)
                            {
                                [ViewIndicator showErrorWithStatus:@"QQ空间分享失败!" duration:1.0];
                                NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
                            }
                        }];
    }
    //    SHARE_TYPE_NUMBER(ShareTypeWeixiSession),
    //    SHARE_TYPE_NUMBER(ShareTypeWeixiTimeline),
    //    SHARE_TYPE_NUMBER(ShareTypeQQ),
    //    SHARE_TYPE_NUMBER(ShareTypeMail),
    else if (type == ShareTypeWeixiSession) {
        [ShareSDK shareContent:publishContent
                          type:ShareTypeWeixiSession
                   authOptions:authOptions
                 statusBarTips:YES
                        result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                            
                            if (state == SSPublishContentStateSuccess)
                            {
                                NSLog(@"success");
                                [ViewIndicator showSuccessWithStatus:@"发送微信成功!" duration:1.0];
//                                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationShareSNS object:nil];
                            }
                            else if (state == SSPublishContentStateFail)
                            {
                                if ([error errorCode] == -22003)
                                {
                                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                                        message:[error errorDescription]
                                                                                       delegate:nil
                                                                              cancelButtonTitle:@"知道了"
                                                                              otherButtonTitles:nil];
                                    [alertView show];
                                }
                            }
                        }];
    }
    else if (type == ShareTypeWeixiTimeline) {
        [ShareSDK shareContent:publishContent
                          type:ShareTypeWeixiTimeline
                   authOptions:authOptions
                 statusBarTips:YES
                        result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                            
                            if (state == SSPublishContentStateSuccess)
                            {
                                NSLog(@"success");
                                [ViewIndicator showSuccessWithStatus:@"发送微信成功!" duration:1.0];
//                                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationShareSNS object:nil];
                            }
                            else if (state == SSPublishContentStateFail)
                            {
                                if ([error errorCode] == -22003)
                                {
                                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                                        message:[error errorDescription]
                                                                                       delegate:nil
                                                                              cancelButtonTitle:@"知道了"
                                                                              otherButtonTitles:nil];
                                    [alertView show];
                                }
                            }
                        }];
    }
    else if (type == ShareTypeQQ) {
        [ShareSDK shareContent:publishContent
                          type:ShareTypeQQ
                   authOptions:authOptions
                 statusBarTips:YES
                        result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                            
                            if (state == SSPublishContentStateSuccess)
                            {
                                NSLog(@"success");
                                [ViewIndicator showSuccessWithStatus:@"发送QQ信息成功!" duration:1.0];
//                                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationShareSNS object:nil];
                            }
                            else if (state == SSPublishContentStateFail)
                            {
                                [ViewIndicator showErrorWithStatus:[error errorDescription] duration:1.0];
                                NSLog(@"fail");
                            }
                        }];
    }
    else if (type == ShareTypeMail) {
        [ShareSDK showShareViewWithType:ShareTypeMail
                              container:container
                                content:publishContent
                          statusBarTips:YES
                            authOptions:authOptions
                           shareOptions:[ShareSDK defaultShareOptionsWithTitle:nil
                                                               oneKeyShareList:[NSArray defaultOneKeyShareList]
                                                                qqButtonHidden:NO
                                                         wxSessionButtonHidden:NO
                                                        wxTimelineButtonHidden:NO
                                                          showKeyboardOnAppear:NO
                                                             shareViewDelegate:nil
                                                           friendsViewDelegate:nil
                                                         picViewerViewDelegate:nil]
                                 result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                     
                                     if (state == SSPublishContentStateSuccess)
                                     {
                                         NSLog(@"发表成功");
                                         [ViewIndicator showSuccessWithStatus:@"发送成功!" duration:1.0];
//                                         [[NSNotificationCenter defaultCenter] postNotificationName:NotificationShareSNS object:nil];
                                         
                                     }
                                     else if (state == SSPublishContentStateFail)
                                     {
                                         NSLog(@"发布失败!error code == %d, error code == %@", [error errorCode], [error errorDescription]);
                                         [ViewIndicator showErrorWithStatus:[error errorDescription] duration:1.0];
                                     }
                                 }];
    }
}

- (void)showTheShareSheetWithTitle:(NSString *)title andContent:(NSString *)content andUrl:(NSString *)url andDescription:(NSString *)description andImage:(NSString *)imagePath andSender:(UIView *)sender {
    title = title?title:@"";
    content = content?content:@"";
    url = url?url:@"";
    description = description?description:@"";
    imagePath = imagePath?imagePath:@"";
    
    //创建容器
    id<ISSContainer> container = [ShareSDK container];
    
    if ([[UIDevice currentDevice] isPad]) {
        [container setIPadContainerWithView:sender
                                arrowDirect:UIPopoverArrowDirectionUp];
    }
    else
    {
        [ViewIndicator showErrorWithStatus:@"要调用iphone的方法" duration:1.0];
        [container setIPhoneContainerWithViewController:_rootViewController];
    }
    
    //定义分享内容
    
    id<ISSContent> publishContent = [ShareSDK content:content
                                       defaultContent:content
                                                image:[ShareSDK imageWithPath:imagePath]
                                                title:title
                                                  url:url
                                          description:description
                                            mediaType:SSPublishContentMediaTypeNews];
    
    [publishContent addSinaWeiboUnitWithContent:[NSString stringWithFormat:@"%@ @%@ %@",description,kAppName,url] image:INHERIT_VALUE];
    [publishContent addTencentWeiboUnitWithContent:[NSString stringWithFormat:@"%@ %@ %@",description,kAppName,url] image:INHERIT_VALUE];
    [publishContent addQQUnitWithType:[NSNumber numberWithInt:SSPublishContentMediaTypeNews] content:[NSString stringWithFormat:@"%@ %@ %@",description,kAppName,url] title:title url:url image:INHERIT_VALUE];
    //定制微信好友信息
    [publishContent addWeixinSessionUnitWithType:INHERIT_VALUE
                                         content:[NSString stringWithFormat:@"%@ %@ %@",description,kAppName,url]
                                           title:INHERIT_VALUE
                                             url:INHERIT_VALUE
                                           image:INHERIT_VALUE
                                    musicFileUrl:nil
                                         extInfo:nil
                                        fileData:nil
                                    emoticonData:nil];
    [publishContent addWeixinTimelineUnitWithType:[NSNumber numberWithInteger:SSPublishContentMediaTypeMusic]
                                          content:[NSString stringWithFormat:@"%@ %@ %@",description,kAppName,url]
                                            title:INHERIT_VALUE
                                              url:url
                                            image:INHERIT_VALUE
                                     musicFileUrl:nil
                                          extInfo:nil
                                         fileData:nil
                                     emoticonData:nil];
    //定制邮件信息
    [publishContent addMailUnitWithSubject:title
                                   content:[NSString stringWithFormat:@"%@ %@ %@",description,kAppName,url]
                                    isHTML:[NSNumber numberWithBool:YES]
                               attachments:INHERIT_VALUE
                                        to:nil
                                        cc:nil
                                       bcc:nil];
    
    //分享设置
    id<ISSShareOptions> shareOptions = [ShareSDK defaultShareOptionsWithTitle:nil
                                                              oneKeyShareList:[NSArray defaultOneKeyShareList]
                                                               qqButtonHidden:NO
                                                        wxSessionButtonHidden:NO
                                                       wxTimelineButtonHidden:NO
                                                         showKeyboardOnAppear:NO
                                                            shareViewDelegate:nil
                                                          friendsViewDelegate:nil
                                                        picViewerViewDelegate:nil];
    //分享认证
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:nil];
    
    //自定义新浪微博分享菜单项
    id<ISSShareActionSheetItem> sinaItem = [ShareSDK shareActionSheetItemWithTitle:[ShareSDK getClientNameWithType:ShareTypeSinaWeibo]
                                                                              icon:[ShareSDK getClientIconWithType:ShareTypeSinaWeibo]
                                                                      clickHandler:^{
                                                                          if([ShareSDK hasAuthorizedWithType:ShareTypeSinaWeibo])
                                                                              [ViewIndicator showWithStatus:@"新浪微博分享中..."];
                                                                          else
                                                                          {
                                                                              [ViewIndicator showSuccessWithStatus:kTipsWithAuth duration:1.0];
                                                                          }
                                                                          
                                                                          [ShareSDK shareContent:publishContent
                                                                                            type:ShareTypeSinaWeibo
                                                                                     authOptions:authOptions
                                                                                   statusBarTips:YES
                                                                                          result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                                                                              
                                                                                              if (state == SSPublishContentStateSuccess)
                                                                                              {
                                                                                                  [ViewIndicator showSuccessWithStatus:@"新浪微博分享成功!" duration:1.0];
                                                                                              }
                                                                                              else if (state == SSPublishContentStateFail)
                                                                                              {
                                                                                                  [ViewIndicator showErrorWithStatus:@"新浪微博分享失败！" duration:1.0];                                NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
                                                                                              }
                                                                                          }];
                                                                      }];
    //自定义腾讯微博分享菜单项
    id<ISSShareActionSheetItem> tencentItem = [ShareSDK shareActionSheetItemWithTitle:[ShareSDK getClientNameWithType:ShareTypeTencentWeibo]
                                                                                 icon:[ShareSDK getClientIconWithType:ShareTypeTencentWeibo]
                                                                         clickHandler:^{
                                                                             if([ShareSDK hasAuthorizedWithType:ShareTypeTencentWeibo])                [ViewIndicator showWithStatus:@"腾讯微博分享中..."];
                                                                             else   [ViewIndicator showSuccessWithStatus:kTipsWithAuth duration:1.0];
                                                                             [ShareSDK shareContent:publishContent
                                                                                               type:ShareTypeTencentWeibo
                                                                                        authOptions:authOptions
                                                                                      statusBarTips:YES
                                                                                             result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                                                                                 
                                                                                                 if (state == SSPublishContentStateSuccess)
                                                                                                 {
                                                                                                     [ViewIndicator showSuccessWithStatus:@"腾讯微博分享成功!" duration:1.0];                               NSLog(@"分享成功");
                                                                                                 }
                                                                                                 else if (state == SSPublishContentStateFail)
                                                                                                 {
                                                                                                     [ViewIndicator showErrorWithStatus:@"腾讯微博分享失败!" duration:1.0];
                                                                                                     NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
                                                                                                 }
                                                                                             }];
                                                                         }];
    
    //自定义QQ空间分享菜单项
    id<ISSShareActionSheetItem> qzoneItem = [ShareSDK shareActionSheetItemWithTitle:[ShareSDK getClientNameWithType:ShareTypeQQSpace]
                                                                               icon:[ShareSDK getClientIconWithType:ShareTypeQQSpace]
                                                                       clickHandler:^{
                                                                           if([ShareSDK hasAuthorizedWithType:ShareTypeQQSpace])
                                                                               [ViewIndicator showWithStatus:@"QQ空间分享中..."];
                                                                           else
                                                                               [ViewIndicator showSuccessWithStatus:kTipsWithAuth duration:1.0];
                                                                           [ShareSDK shareContent:publishContent
                                                                                             type:ShareTypeQQSpace
                                                                                      authOptions:authOptions
                                                                                    statusBarTips:YES
                                                                                           result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                                                                               
                                                                                               if (state == SSPublishContentStateSuccess)
                                                                                               {
                                                                                                   [ViewIndicator showSuccessWithStatus:@"QQ空间分享成功!" duration:1.0];
                                                                                                   NSLog(@"分享成功");
                                                                                               }
                                                                                               else if (state == SSPublishContentStateFail)
                                                                                               {
                                                                                                   [ViewIndicator showErrorWithStatus:@"QQ空间分享失败!" duration:1.0];
                                                                                                   NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
                                                                                               }
                                                                                           }];
                                                                       }];
    
    id<ISSShareActionSheetItem> myItem = [ShareSDK shareActionSheetItemWithTitle:@"保存到相册"
                                                                            icon:[UIImage imageNamed:@"safepic.png"]
                                                                    clickHandler:^{
                                                                        NSLog(@"执行你的分享代码!");
                                                                        UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
                                                                        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
                                                                        [ViewIndicator showSuccessWithStatus:@"保存图片成功!" duration:1.0];
                                                                        
                                                                    }];
    
    NSArray *shareList = [ShareSDK customShareListWithType:
                          sinaItem,
                          tencentItem,
                          qzoneItem,
                          SHARE_TYPE_NUMBER(ShareTypeWeixiSession),
                          SHARE_TYPE_NUMBER(ShareTypeWeixiTimeline),
                          SHARE_TYPE_NUMBER(ShareTypeQQ),
                          SHARE_TYPE_NUMBER(ShareTypeMail),
                          myItem,
                          nil];
    
    
    [ShareSDK showShareActionSheet:container
                         shareList:shareList
                           content:publishContent
                     statusBarTips:YES
                       authOptions:authOptions
                      shareOptions:shareOptions
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                if (state == SSPublishContentStateSuccess)
                                {
                                    NSLog(@"发表成功");
                                    [ViewIndicator showSuccessWithStatus:@"发表成功!" duration:1.0];
                                }
                                else if (state == SSPublishContentStateFail)
                                {
                                    NSLog(@"发布失败!error code == %d, error code == %@", [error errorCode], [error errorDescription]);
                                    [ViewIndicator showErrorWithStatus:[error errorDescription] duration:1.0];
                                }
                            }];
}

- (void)showTheShareSheetWithTitle:(NSString *)title andContent:(NSString *)content andUrl:(NSString *)url andDescription:(NSString *)description andImage:(NSString *)imagePath {
    
    title = title?title:@"";
    content = content?content:@"";
    url = url?url:@"";
    description = description?description:@"";
    imagePath = imagePath?imagePath:@"";
    
    //创建容器
    id<ISSContainer> container = [ShareSDK container];
    
    if ([[UIDevice currentDevice] isPad]) {
        [ViewIndicator showErrorWithStatus:@"请调用ipad的方法" duration:1.0];
        return;
        //        [container setIPadContainerWithView:[UIApplication sharedApplication].keyWindow
        //                                arrowDirect:UIPopoverArrowDirectionUp];
    }
    else
    {
        [container setIPhoneContainerWithViewController:_rootViewController];
    }
    
    //定义分享内容
    
    id<ISSContent> publishContent = [ShareSDK content:content
                                       defaultContent:content
                                                image:[ShareSDK imageWithPath:imagePath]
                                                title:title
                                                  url:url
                                          description:description
                                            mediaType:SSPublishContentMediaTypeNews];
    
    [publishContent addSinaWeiboUnitWithContent:[NSString stringWithFormat:@"%@ @%@ %@",description,kAppName,url] image:INHERIT_VALUE];
    [publishContent addTencentWeiboUnitWithContent:[NSString stringWithFormat:@"%@ %@ %@",description,kAppName,url] image:INHERIT_VALUE];
    [publishContent addQQUnitWithType:[NSNumber numberWithInt:SSPublishContentMediaTypeNews] content:[NSString stringWithFormat:@"%@ %@ %@",description,kAppName,url] title:title url:url image:INHERIT_VALUE];
    //定制微信好友信息
    [publishContent addWeixinSessionUnitWithType:INHERIT_VALUE
                                         content:[NSString stringWithFormat:@"%@ %@ %@",description,kAppName,url]
                                           title:INHERIT_VALUE
                                             url:INHERIT_VALUE
                                           image:INHERIT_VALUE
                                    musicFileUrl:nil
                                         extInfo:nil
                                        fileData:nil
                                    emoticonData:nil];
    [publishContent addWeixinTimelineUnitWithType:[NSNumber numberWithInteger:SSPublishContentMediaTypeMusic]
                                          content:[NSString stringWithFormat:@"%@ %@ %@",description,kAppName,url]
                                            title:INHERIT_VALUE
                                              url:url
                                            image:INHERIT_VALUE
                                     musicFileUrl:nil
                                          extInfo:nil
                                         fileData:nil
                                     emoticonData:nil];
    //定制邮件信息
    [publishContent addMailUnitWithSubject:title
                                   content:[NSString stringWithFormat:@"%@ %@ %@",description,kAppName,url]
                                    isHTML:[NSNumber numberWithBool:YES]
                               attachments:INHERIT_VALUE
                                        to:nil
                                        cc:nil
                                       bcc:nil];
    
    //分享设置
    id<ISSShareOptions> shareOptions = [ShareSDK defaultShareOptionsWithTitle:nil
                                                              oneKeyShareList:[NSArray defaultOneKeyShareList]
                                                               qqButtonHidden:NO
                                                        wxSessionButtonHidden:NO
                                                       wxTimelineButtonHidden:NO
                                                         showKeyboardOnAppear:NO
                                                            shareViewDelegate:nil
                                                          friendsViewDelegate:nil
                                                        picViewerViewDelegate:nil];
    //分享认证
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:nil];
    
    //自定义新浪微博分享菜单项
    id<ISSShareActionSheetItem> sinaItem = [ShareSDK shareActionSheetItemWithTitle:[ShareSDK getClientNameWithType:ShareTypeSinaWeibo]
                                                                              icon:[ShareSDK getClientIconWithType:ShareTypeSinaWeibo]
                                                                      clickHandler:^{
                                                                          if([ShareSDK hasAuthorizedWithType:ShareTypeSinaWeibo])
                                                                              [ViewIndicator showWithStatus:@"新浪微博分享中..."];
                                                                          else
                                                                          {
                                                                              [ViewIndicator showSuccessWithStatus:kTipsWithAuth duration:1.0];
                                                                          }
                                                                          
                                                                          [ShareSDK shareContent:publishContent
                                                                                            type:ShareTypeSinaWeibo
                                                                                     authOptions:authOptions
                                                                                   statusBarTips:YES
                                                                                          result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                                                                              
                                                                                              if (state == SSPublishContentStateSuccess)
                                                                                              {
                                                                                                  [ViewIndicator showSuccessWithStatus:@"新浪微博分享成功!" duration:1.0];
                                                                                              }
                                                                                              else if (state == SSPublishContentStateFail)
                                                                                              {
                                                                                                  [ViewIndicator showErrorWithStatus:@"新浪微博分享失败！" duration:1.0];                                NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
                                                                                              }
                                                                                          }];
                                                                      }];
    //自定义腾讯微博分享菜单项
    id<ISSShareActionSheetItem> tencentItem = [ShareSDK shareActionSheetItemWithTitle:[ShareSDK getClientNameWithType:ShareTypeTencentWeibo]
                                                                                 icon:[ShareSDK getClientIconWithType:ShareTypeTencentWeibo]
                                                                         clickHandler:^{
                                                                             if([ShareSDK hasAuthorizedWithType:ShareTypeTencentWeibo])                [ViewIndicator showWithStatus:@"腾讯微博分享中..."];
                                                                             else   [ViewIndicator showSuccessWithStatus:kTipsWithAuth duration:1.0];
                                                                             [ShareSDK shareContent:publishContent
                                                                                               type:ShareTypeTencentWeibo
                                                                                        authOptions:authOptions
                                                                                      statusBarTips:YES
                                                                                             result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                                                                                 
                                                                                                 if (state == SSPublishContentStateSuccess)
                                                                                                 {
                                                                                                     [ViewIndicator showSuccessWithStatus:@"腾讯微博分享成功!" duration:1.0];                               NSLog(@"分享成功");
                                                                                                 }
                                                                                                 else if (state == SSPublishContentStateFail)
                                                                                                 {
                                                                                                     [ViewIndicator showErrorWithStatus:@"腾讯微博分享失败!" duration:1.0];
                                                                                                     NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
                                                                                                 }
                                                                                             }];
                                                                         }];
    
    //自定义QQ空间分享菜单项
    id<ISSShareActionSheetItem> qzoneItem = [ShareSDK shareActionSheetItemWithTitle:[ShareSDK getClientNameWithType:ShareTypeQQSpace]
                                                                               icon:[ShareSDK getClientIconWithType:ShareTypeQQSpace]
                                                                       clickHandler:^{
                                                                           if([ShareSDK hasAuthorizedWithType:ShareTypeQQSpace])
                                                                               [ViewIndicator showWithStatus:@"QQ空间分享中..."];
                                                                           else
                                                                               [ViewIndicator showSuccessWithStatus:kTipsWithAuth duration:1.0];
                                                                           [ShareSDK shareContent:publishContent
                                                                                             type:ShareTypeQQSpace
                                                                                      authOptions:authOptions
                                                                                    statusBarTips:YES
                                                                                           result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                                                                               
                                                                                               if (state == SSPublishContentStateSuccess)
                                                                                               {
                                                                                                   [ViewIndicator showSuccessWithStatus:@"QQ空间分享成功!" duration:1.0];
                                                                                                   NSLog(@"分享成功");
                                                                                               }
                                                                                               else if (state == SSPublishContentStateFail)
                                                                                               {
                                                                                                   [ViewIndicator showErrorWithStatus:@"QQ空间分享失败!" duration:1.0];
                                                                                                   NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
                                                                                               }
                                                                                           }];
                                                                       }];
    
    id<ISSShareActionSheetItem> myItem = [ShareSDK shareActionSheetItemWithTitle:@"保存到相册"
                                                                            icon:[UIImage imageNamed:@"safepic.png"]
                                                                    clickHandler:^{
                                                                        NSLog(@"执行你的分享代码!");
                                                                        UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
                                                                        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
                                                                        [ViewIndicator showSuccessWithStatus:@"保存图片成功!" duration:1.0];
                                                                        
                                                                    }];
    
    NSArray *shareList = [ShareSDK customShareListWithType:
                          sinaItem,
                          tencentItem,
                          qzoneItem,
                          SHARE_TYPE_NUMBER(ShareTypeWeixiSession),
                          SHARE_TYPE_NUMBER(ShareTypeWeixiTimeline),
                          SHARE_TYPE_NUMBER(ShareTypeQQ),
                          SHARE_TYPE_NUMBER(ShareTypeMail),
                          myItem,
                          nil];
    
    
    [ShareSDK showShareActionSheet:container
                         shareList:shareList
                           content:publishContent
                     statusBarTips:YES
                       authOptions:authOptions
                      shareOptions:shareOptions
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                if (state == SSPublishContentStateSuccess)
                                {
                                    NSLog(@"发表成功");
                                    [ViewIndicator showSuccessWithStatus:@"发表成功!" duration:1.0];
                                }
                                else if (state == SSPublishContentStateFail)
                                {
                                    NSLog(@"发布失败!error code == %d, error code == %@", [error errorCode], [error errorDescription]);
                                    [ViewIndicator showErrorWithStatus:[error errorDescription] duration:1.0];
                                }
                            }];
}

@end
