//
//  CJDealTool.m
//  美团HD
//
//  Created by mac527 on 15/10/31.
//  Copyright (c) 2015年 mac527. All rights reserved.
//

#import "CJDealTool.h"
#import "FMDB.h"
#import "CJDeal.h"
@implementation CJDealTool

static FMDatabase *_db;

+ (void)initialize
{
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"deal.sqlite"];
    _db = [[FMDatabase alloc] initWithPath:filePath];
    if (![_db open]) return;
    
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_collect_deal(id integer PRIMARY KEY,deal blob NOT NULL,deal_id text NOT NULL);"];
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_recent_deal(id integer PRIMARY KEY,deal blob NOT NULL,deal_id text NOT NULL);"];
    NSLog(@"%@",filePath);
}

+ (NSArray *)collectDeals:(int)page
{
    int size = 20;
    int pos = (page - 1) * size;
    FMResultSet *set = [_db executeQueryWithFormat:@"SELECT * FROM t_collect_deal ORDER BY id DESC LIMT %d,%d;",pos,size];
    NSMutableArray *deals = [NSMutableArray array];
    while (set.next) {
        CJDeal *deal = [NSKeyedUnarchiver unarchiveObjectWithData:[set objectForColumnName:@"deal"]];
        [deals addObject:deal];
    }
    return deals;
}
+ (int)collectDealsCount
{
    FMResultSet *set = [_db executeQueryWithFormat:@"SELECT count(*) AS deal_count FROM t_collect_deal;"];
    [set next];
    return [set intForColumn:@"deal_count"];
}
/**
 *  收藏一个团购
 */
+ (void)addCollectDeal:(CJDeal *)deal
{
    [_db executeUpdateWithFormat:@"INSERT INTO t_collect_deal(deal,deal_id) VALUES(%@, %@);",deal,deal.deal_id];
}
/**
 *  取消收藏一个团购
 */
+ (void)removeCollectDeal:(CJDeal *)deal
{
    [_db executeUpdateWithFormat:@"DELETE FROM t_collect_deal WHERE deal_id = %@;",deal.deal_id];
}

/**
 *  团购是否收藏
 */
+ (BOOL)isCollected:(CJDeal *)deal
{
//    FMResultSet *set = [_db executeQueryWithFormat:@"SELECT count(*) AS deal_count FROM t_collect_deal WHERE deal_id = %@;",deal.deal_id];
//    [set next];
//    //#warning 索引从1开始
//    return [set intForColumn:@"deal_count"] == 1;
    FMResultSet *set = [_db executeQueryWithFormat:@"SELECT count(*) AS deal_count FROM t_collect_deal WHERE deal_id = %@;", deal.deal_id];
    [set next];
    //#warning 索引从1开始
    return [set intForColumn:@"deal_count"] == 1;
}
@end
