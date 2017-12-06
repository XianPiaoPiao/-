//
//  DatabaseManager.h
//  LimitFree
//
//数据库管理类：单例
#import <Foundation/Foundation.h>

@interface DatabaseManager : NSObject
+(instancetype)defalutManager;
//创建数据库表
-(BOOL)creatTableFromClass:(Class)tableClass;
//添加数据
-(BOOL)insertTableWithObject:(id) obj;
//删除数据
-(BOOL)deleteObject:(id) obj;
//查询所有数据
-(NSArray *)selectAllobjectFromClass:(Class)tableClass;
//判断某个数据在数据库表中是否存在
-(BOOL)isExistWithObject:(id) objc;
@end
