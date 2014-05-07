//
//  ControllerHistory.h
//

#import <UIKit/UIKit.h>

@protocol VcHistoryDelegate;

@interface ControllerHistory : UIViewController <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, UIActionSheetDelegate> {
    NSMutableArray *_arrUrl;
    UrlType        _urlType;
}

@property (nonatomic, assign) id<VcHistoryDelegate> delegate;

- (void)reloadData;
- (void)clearHistory;

@end

@protocol VcHistoryDelegate <NSObject>

@required
- (void)vcHistory:(ControllerHistory *)vcHistory didSelectUrl:(NSString *)url;
@optional
- (void)vcHistory:(ControllerHistory *)vcHistory didDeleteFavUrl:(NSString *)url;


@end
