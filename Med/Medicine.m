//
//  Medicine.m
//  fmdbtest
//
//  Created by Edward on 13-3-2.
//  Copyright (c) 2013年 Edward. All rights reserved.
//

#import "Medicine.h"

@implementation Medicine
@synthesize stringID;

+ (int)countAllMedicine {
    int count = 0;
    FMDatabase *dataBase = [dataBaseManager createDataBase];
    if ([dataBase open]) {
    FMResultSet *rs = [dataBase executeQuery:@"SELECT COUNT(*) FROM Medicine"];
        if ([rs next]) {
            count = [rs intForColumnIndex:0];
        }
        [dataBase close];
    }
    debugLog(@"总共:%d",count);
    return count;
}

+ (NSArray *)findAllMedicineToArray {
    debugMethod();
    FMDatabase *dataBase = [dataBaseManager createDataBase];
    NSMutableArray *mutableArray = [NSMutableArray array];
    if ([dataBase open]) {
        FMResultSet *rs = [dataBase executeQuery:@"SELECT * FROM Medicine"];
        while ([rs next]) {
//            NSDictionary *recordDic = [NSDictionary dictionaryWithObjectsAndKeys:
//                                       [rs stringForColumn:@"Name"],@"Name",
//                                       [rs stringForColumn:@"Specifi"],@"Specifi",
//                                       [rs stringForColumn:@"Unit"],@"Unit",
//                                       [rs stringForColumn:@"Content"],@"Content",
//                                       [rs stringForColumn:@"PYM"],@"PYM",nil];
           
            NSDictionary *dic = @{@"Name": [rs stringForColumn:@"Name"],
                                  @"Specifi":[rs stringForColumn:@"Specifi"],
                                  @"Unit":[rs stringForColumn:@"Unit"],
                                  @"Content":[rs stringForColumn:@"Content"],
                                  @"PYM":[rs stringForColumn:@"PYM"]};
            [mutableArray addObject:dic];
        }
        [dataBase close];
    }
    NSArray *resultArray = [mutableArray copy];
     NSSortDescriptor *soter = [[NSSortDescriptor alloc] initWithKey:@"PYM" ascending:YES];
     NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&soter count:1];
     NSArray *array = [resultArray sortedArrayUsingDescriptors:sortDescriptors];
    return array;
}


+ (int)countSomeMedicineByName:(NSString *)_name {
    int count = 0;
    FMDatabase *dataBase = [dataBaseManager createDataBase];
    if ([dataBase open]) {
    FMResultSet *resultSet = [dataBase executeQuery:@"SELECT COUNT(*) FROM Medicine WHERE Name = ?",_name];
    if ([resultSet next]) {
        count = [resultSet intForColumnIndex:0];
    }
        [dataBase close];
    }
    return count;
}


+ (NSMutableArray *)findSomeMedicineByName:(NSString *)_name {
    debugMethod();
    FMDatabase *dataBase = [dataBaseManager createDataBase];
    NSMutableArray *mutableArry = [NSMutableArray array];
    if ([dataBase open]) {
        FMResultSet *rs = [dataBase executeQuery:@"SELECT * FROM Medicine WHERE Name = ?",_name];
        while ([rs next]) {
        NSDictionary *recordDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [rs stringForColumn:@"Name"],@"Name",
                                   [rs stringForColumn:@"Specifi"],@"Specifi",
                                   [rs stringForColumn:@"Unit"],@"Unit",
                                   [rs stringForColumn:@"Content"],@"Content",
                                   [rs stringForColumn:@"PYM"],@"PYM",nil];
        [mutableArry addObject:recordDic];
        }
        [dataBase close];
    }
    
    return mutableArry;
    
}

+ (NSDictionary *)findSomeMedicineByPYM:(NSString *)_pym {
    debugMethod();
    FMDatabase *dataBase = [dataBaseManager createDataBase];
    NSDictionary *dic = nil;
    if ([dataBase open]) {
        FMResultSet *rs = [dataBase executeQuery:@"SELECT * FROM Medicine WHERE PYM = ?",_pym];
        dic = [NSDictionary dictionaryWithObjectsAndKeys:
               [rs stringForColumn:@"Name"],@"Name",
               [rs stringForColumn:@"Specifi"],@"Specifi",
               [rs stringForColumn:@"Unit"],@"Unit",
               [rs stringForColumn:@"Content"],@"Content",
               [rs stringForColumn:@"PYM"],@"PYM",nil];
        [dataBase close];
    }
    
    return dic;
}
+ (NSMutableArray *)findSomeMedicineBySpecifi:(NSString *)_specifi {
    debugMethod();
    FMDatabase *dataBase = [dataBaseManager createDataBase];
    NSMutableArray *mutableArry = [NSMutableArray array];
    if ([dataBase open]) {
        FMResultSet *resultSet = [dataBase executeQuery:@"SELECT * FROM Medicine WHERE Specifi = ?",_specifi];
        NSString *nameStr = [resultSet stringForColumn:@"Name"];
        NSString *specifiStr = [resultSet stringForColumn:@"Specifi"];
        NSString *contentStr = [resultSet stringForColumn:@"Content"];
        NSString *pym = [resultSet stringForColumn:@"PYM"];
        NSString *unit = [resultSet stringForColumn:@"Unit"];
        NSDictionary *recordDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                   nameStr,@"Name",
                                   specifiStr,@"Specifi",
                                   unit,@"Unit",
                                   contentStr,@"Content",
                                   pym,@"PYM",nil];
        [mutableArry addObject:recordDic];
        [dataBase close];
    }
    
    return mutableArry;
}
+ (BOOL)createNewMedicine:(NSString *)_name andSpecifi:(NSString *)_specifi andUnit:(NSString *)_unit andContent:(NSString *)_content PYM:(NSString *)_pym{
    debugMethod();
    FMDatabase *dataBase = [dataBaseManager createDataBase];
    BOOL isOK = NO;
    if ([dataBase open]) {
            isOK = [dataBase executeUpdate:@"INSERT INTO Medicine (Name,Specifi,Unit,Content,PYM) VALUES (?,?,?,?,?)",
                         _name,
                         _specifi,
                         _unit,
                         _content,
                         _pym];
    [dataBase close];
    }
    
    return isOK;
}


/**
更新操作需要根据主键id来完成 
 **/
- (BOOL) findIDByMedicinePYM:(NSString *)_pym {
    debugMethod();
    FMDatabase *dataBase = [dataBaseManager createDataBase];
    BOOL isOK = NO;
    if ([dataBase open]) {
    FMResultSet *resultSet = [dataBase executeQuery:@"SELECT * FROM Medicine"];
    while ([resultSet next]) {
        
        NSString *pym = [resultSet stringForColumn:@"PYM"];
        debugLog(@"pym:%@",pym);
        if ([_pym isEqualToString:pym]) {
            isOK = YES;
            self.stringID = [resultSet stringForColumn:@"id"];
            debugLog(@"根据拼音码查找的药品id是:%@",stringID);
        }
        
    }
        [dataBase close];
    }
    
    return isOK;
}

- (BOOL)findIfExitsSameName:(NSString *)_name {
    debugMethod();
    FMDatabase *dataBase = [dataBaseManager createDataBase];
    BOOL isOK = NO;
    if ([dataBase open]) {
        FMResultSet *rs  = [dataBase executeQuery:@"SELECT * FROM Medicine"];
        while ([rs next]) {
            if ([_name isEqualToString:[rs stringForColumn:@"Name"]]) {
                isOK = YES;
            }
        }
        [dataBase close];
    }
    return isOK;
}
- (BOOL) updateMedicine:(NSString *)_name andSpecifi:(NSString *)_specifi andUnit:(NSString *)_unit andContent:(NSString *)_content andPYM:(NSString *)_pym {
    debugMethod();
    BOOL isOK = NO;
    FMDatabase *dataBase = [dataBaseManager createDataBase];
        if ([dataBase open]) {
            NSInteger idNumber = [self.stringID integerValue];
        isOK = [dataBase executeUpdate:@"UPDATE Medicine SET Name = ?, Specifi = ?, Unit = ?,Content = ?, PYM = ?,WHERE id = ?",_name,_specifi,_unit,_content,idNumber,_pym];
        
        [dataBase close];
        }
    
    return isOK;
}
/**
删除某种药时，先根据规格和名称在数据库中检索出来具体是哪种药然后再进行删除
**/
//+ (BOOL)deleteSomeMedicine:(NSString *)_name andSpecifi:(NSString *)_specifi {
//    debugMethod();
//    FMDatabase *dataBase = [dataBaseManager createDataBase];
//    BOOL isOK = NO;
//    
//    if ([dataBase open]) {
//        isOK = [dataBase executeUpdate:@"DELETE FROM Medicine WHERE Name = ? AND SPECIFI = ?",_name,_specifi];
//    }
//    [dataBase close];
//    return isOK;
//}

/**以拼音码删除药品**/
+ (BOOL)deleteSomeMedicine:(NSString *)_pym {

    debugMethod();
    FMDatabase *dataBase = [dataBaseManager createDataBase];
    BOOL isOK = NO;
    if ([dataBase open]) {
        isOK = [dataBase executeUpdate:@"DELETE FROM Medicine WHERE PYM = ?",_pym];
    [dataBase close];
    }
    
    return isOK;
}
@end
