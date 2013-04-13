//
//  SelectBQ.h
//  masterDemo
//
//  Created by Edward on 13-3-14.
//  Copyright (c) 2013年 Edward. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PassSelectedBQDelegete <NSObject>
@required
- (void)passSelectedBQ:(NSString *)_selectedBQ;
@end
@interface SelectBQ : UIViewController <UISearchBarDelegate,UISearchDisplayDelegate,UITableViewDelegate,UITableViewDataSource> {
    
    IBOutlet UITableView *table;
    NSString *BQStr;
    id <PassSelectedBQDelegete> delegete;
    
}
@property (strong, nonatomic) IBOutlet UISearchBar *search;
@property (nonatomic, copy) NSString *BQStr;
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, weak) id <PassSelectedBQDelegete> delegate;
@end
