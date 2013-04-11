//
//  NewRecord.m
//  masterDemo
//
//  Created by Edward on 13-3-6.
//  Copyright (c) 2013年 Edward. All rights reserved.
//

#import "NewRecord.h"
#import "Record.h"
#import "InputNewRecord.h"
#import <QuartzCore/QuartzCore.h>
#define medNameLabelTag 1
#define pymLabeltag 2
#define selectContLabelTag 3
@interface NewRecord ()
- (BOOL)saveToRecordTablePatientName:(NSString *)patientName Office:(NSString *)office;
@end

@implementation NewRecord
@synthesize inputNewRecord,selectBQ;
@synthesize popoverController,table;
@synthesize data;
@synthesize addBtn;
@synthesize field;
@synthesize navBar = _navBar;
@synthesize selectedBQLabel;//////显示目前的病区
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.table.delegate = self;
    self.table.dataSource = self;
    self.field.delegate = self;
    self.field.returnKeyType = UIReturnKeyDone;
    self.addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.addBtn setFrame:CGRectMake(450, 65, 44, 44)];
    [addBtn setBackgroundImage:[UIImage imageNamed:@"button_icon_close"] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(deleteRow:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addBtn];
    [_navBar setBackImage];
    [self.selectedBQLabel setText:[US objectForKey:@"BQ"]];    
}
- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    selectBQ.delegate = self;
    
}
- (void)passSelectedBQ:(NSString *)BQ {
    self.selectedBQLabel.text = BQ;
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}
- (IBAction)showPopover:(id)sender {
    
    if (popoverController == nil) {
        if (inputNewRecord==nil) {
            inputNewRecord = [[InputNewRecord alloc] initWithNibName:@"InputNewRecord" bundle:nil];
        }
        UIPopoverController *pop = [[UIPopoverController alloc] initWithContentViewController:inputNewRecord];
        self.popoverController = pop;
        [pop release];
        CGRect popoverRect =  CGRectMake(130, 330, 1, 1);
        [popoverController presentPopoverFromRect:popoverRect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        popoverController.delegate = self;
    }
}
- (IBAction)hide:(id)sender {
    self.field.text = @"";
    [self.data removeAllObjects];
    [self.table reloadData];
    [self setInputNewRecord:nil];
    [inputNewRecord release];
}

- (IBAction)showBQ:(id)sender {
    if (popoverController == nil) {
        UIPopoverController *pop = [[UIPopoverController alloc] initWithContentViewController:selectBQ];
        self.popoverController = pop;
        [pop release];
        CGRect popoverRect =  CGRectMake(130, 330, 1, 1);
        [popoverController presentPopoverFromRect:popoverRect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        popoverController.delegate = self;
    }
}



#pragma mark 数据库插入
- (BOOL)checkData {
    
    BOOL isOK = NO;
    
    if ([self.field.text length]!=0&&[US objectForKey:@"BQ"]!=nil&&[self.data count]>0) {
        
        isOK = [Record checkisExistSameRecordByOffice:[US objectForKey:@"BQ"] andPatientName:self.field.text];
        if (isOK) {
            NSString *message = [NSString stringWithFormat:@"%@已经有名叫%@的记录了,请检查或修改",[US objectForKey:@"BQ"],self.field.text];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:message delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
            return NO;
        } else {
            return YES;
        }
    }
    
    return isOK;
}

- (BOOL)saveToRecordTablePatientName:(NSString *)patientName Office:(NSString *)office {
    BOOL isOK = NO;
    isOK = [Record insertNewRecordIntoRecordTable:patientName Office:office];
    return isOK;
}
#pragma mark -
- (IBAction)saveBtnTapped:(id)sender {
     BOOL recordOK = [self checkData];
    if (recordOK) {
        if ([self saveToRecordTablePatientName:self.field.text Office:[US objectForKey:@"BQ"]]) {
            ////////////录入病区和病人///查找刚录入的病人主键
            NSInteger ID = [Record findDetailIDByPatientName:self.field.text Office:[US objectForKey:@"BQ"]];
            if (ID != -1) {
                BOOL isInsertIntoDetailOK = NO;
                for (int i = 0 ;i<[self.data count]; i++) {
                    NSDictionary *recordDic = [self.data objectAtIndex:i];
                    
                    isInsertIntoDetailOK = [Record insertNewDetailsIntoDetailTable:ID Name:[recordDic objectForKey:@"Name"] PYM:[recordDic objectForKey:@"PYM"] Count:[NSString stringWithFormat:@"%@",[recordDic objectForKey:@"Content"]]];
                }
                NSString *msg = isInsertIntoDetailOK ? @"记录创建完毕" : @"录入失败";
                [Help ShowGCDMessage:msg andView:self.view andDelayTime:1.0f];
                [self performSelector:@selector(hide:)];
            }
            
        }
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"数据异常，请检查" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
}


- (void) runSpinAnimationOnView:(UIView*)view duration:(CGFloat)duration rotations:(CGFloat)rotations repeat:(float)repeat;
{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI_2* rotations];
    rotationAnimation.duration = duration;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = repeat;
    [view.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}


- (void)deleteRow:(id)sender {
    
   [self.table setEditing:!table.editing animated:YES];
    int dir = [self.table isEditing] ? -1 : 1;

    [self runSpinAnimationOnView:self.addBtn duration:0.5f rotations:dir repeat:1];
}
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)PopoverController {
    
    if (PopoverController == popoverController) {
        debugLog(@"PopoverController release");
        self.data = [inputNewRecord.contentArray retain];
        [self.table reloadData];
        [popoverController release];
        popoverController = nil;
    }
}

#pragma mark UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.field resignFirstResponder];
    return YES;
}
#pragma mark UITableView DelegeteMethods
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.data count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *CellID = @"LiHang";
    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellID] autorelease];
        
        
        
        //预览药名
        UILabel *medNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, -6, 150, 36)];
        medNameLabel.tag = medNameLabelTag;
        [cell.contentView addSubview:medNameLabel];
        [medNameLabel release];
        
        //拼音码
        
        UILabel *pymLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, 150, 36)];
        pymLabel.tag = pymLabeltag;
        [cell.contentView addSubview:pymLabel];
        [pymLabel release];
        //用药量
        
        UILabel *contLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, 20, 150, 44)];
        contLabel.tag = selectContLabelTag;
        [cell.contentView addSubview:contLabel];
        [contLabel release];
        //
    
    }
    NSDictionary *dic = [self.data objectAtIndex:indexPath.row];
    
    UILabel *_medNameLabel = (UILabel *)[cell.contentView viewWithTag:medNameLabelTag];
    [_medNameLabel setBackgroundColor:[UIColor clearColor]];
    [_medNameLabel setText:[dic objectForKey:@"Name"]];
    
    UILabel *_pymLabel = (UILabel *)[cell.contentView viewWithTag:pymLabeltag];
    [_pymLabel setBackgroundColor:[UIColor clearColor]];
    [_pymLabel setText:[dic objectForKey:@"PYM"]];
    
    UILabel *_contLabel = (UILabel *)[cell.contentView viewWithTag:selectContLabelTag];
    [_contLabel setBackgroundColor:[UIColor clearColor]];
    [_contLabel setText:[NSString stringWithFormat:@"%@",[dic objectForKey:@"Content"]]];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.data removeObjectAtIndex:indexPath.row];
    [self.table deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (!table.editing) {
        return UITableViewCellEditingStyleNone;
    } else {
        return UITableViewCellEditingStyleDelete;
    }
}
#pragma mark -
- (void)dealloc {
    [field release];
    [data release];
    [addBtn release];
    [data release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setField:nil];
    [self setNavBar:nil];
    [self setSelectBQ:nil];
    [self setAddBtn:nil];
    [self setTable:nil];
    [self setSelectedBQLabel:nil];
    [self setData:nil];
    [super viewDidUnload];
}
@end
