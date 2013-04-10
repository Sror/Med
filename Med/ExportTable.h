//
//  ExportTable.h
//  Med
//
//  Created by Edward on 13-3-26.
//  Copyright (c) 2013年 Edward. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHCSVWriter.h"
@interface ExportTable : UIViewController <MBProgressHUDDelegate> {
    MBProgressHUD *HUD;
}

+ (CHCSVWriter *)sharedWriter;
//- (IBAction)ExportTable
- (BOOL)exportSearchResult:(NSArray *)array andFileName:(NSString *)fileName andseg:(NSInteger)segIndex;
- (void)myProgressTask;
@property (retain, nonatomic) IBOutlet UINavigationBar *navBar;
@end
