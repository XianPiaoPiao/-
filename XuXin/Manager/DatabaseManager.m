//
//  DatabaseManager.m
//  LimitFree
//
//

#import "DatabaseManager.h"
#import "FMDB.h"
#import <objc/runtime.h>
@implementation DatabaseManager{
    //数据库管理对象
    
    FMDatabase * _fmDatabase;
    
}
+(instancetype)defalutManager{
    static DatabaseManager * manager = nil;
    
    static dispatch_once_t onceToken =0;
    //保证只能调用一次
    dispatch_once(&onceToken, ^{
        if (!manager) {
            manager = [[DatabaseManager alloc] initPrivate];
        }
    });
//    if (manager == nil) {
//        manager = [[DatabaseManager alloc] initPrivate];
//    }
    return manager;
}
-(instancetype)init{
    //抛出异常
    @throw [NSException exceptionWithName:@"不允许调用init方法" reason:@"DatabaseManger是一个单列" userInfo:nil];
}
//提供一个另外的创建方法
-(instancetype)initPrivate{
    if (self = [super init]) {
        //干些事情
        [self createDB];
    }
    return self;
}
//创建数据库
-(void)createDB{
    //参数1：寻找目录的名字
    //参数2：在哪个目录下查找，用户目录
    //是否展开波浪号
    NSArray * searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * documentPath = [searchPaths lastObject];
    //拼接数据库，保存路径
    NSString * dbPath = [documentPath stringByAppendingPathComponent:@"Haidui.db"];
    //创建数据库管理对象
    _fmDatabase = [[FMDatabase alloc] initWithPath:dbPath];
     BOOL ret = [_fmDatabase open];
    if (ret) {
        NSLog(@"打开成功");
    } else {
        NSLog(@"打开失败");
        @throw [NSException exceptionWithName:@"数据库打开失败" reason:@"未知" userInfo:nil];
    }
    //创建sql语句
    
}
-(BOOL)creatTableFromClass:(Class)tableClass{
    NSString * tableName = NSStringFromClass(tableClass);
    NSArray * propertyArray = [self getAllPropertiesFromClass:tableClass];
    //sqilite无类型数据库
    NSString * filedStr = [propertyArray componentsJoinedByString:@","];
    NSString * sql = [NSString stringWithFormat:@"CREATE TABLE t_%@(id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,%@)",tableName,filedStr];
    BOOL ret = [_fmDatabase executeUpdate:sql];
    if (ret) {
        NSLog(@"表创建成功");
    } else NSLog(@"表创建成功");
    return ret;
    
}
-(BOOL)insertTableWithObject:(id) obj{
    [self creatTableFromClass:[obj class]];
    
    const char * classname =class_getName([obj class]);
    NSString * attrstring = [self getinsertString:[obj class]];
    NSString * value = [self getValueClass:obj];
    NSString * sql = [NSString stringWithFormat:@"insert into t_%s(%@) values(%@);",classname,attrstring,value];
   BOOL ret = [_fmDatabase executeUpdate:sql];
 //   BOOL ret = [_fmDatabase executeUpdate:sql values:<#(NSArray *)#> error:nil];
    if (ret) {
        NSLog(@"插入成功");
    } else NSLog(@"插入失败");
    return ret;
}
-(NSString *)getinsertString:(Class )class{
    NSArray * array = [self getAllPropertiesFromClass:class];
    NSMutableString * mstr = [NSMutableString new];
    for (int i =0;i < array.count; i++) {
        if (i!=array.count -1) {
            [mstr appendFormat:@"%@,",array[i]];
             } else {
                 [mstr appendFormat:@"%@",array[i]];
             }
    }
    return mstr;
}
-(NSString *)getValueClass:(id)objc{
    NSMutableArray * array = [self getAllPropertiesFromClass:[objc class]];
    NSMutableArray * valueArray = [NSMutableArray array];
    NSMutableString * mstr = [NSMutableString new];
    int i =0;
    for (NSString * attname in array) {
      id value =  [objc valueForKey:attname];
        if (!value) {
            [valueArray addObject:[NSNull null]];
        } else{
            [valueArray addObject:value];
        }
        
        
        if (i ==array.count -1) {
            
            [mstr appendFormat:@"'%@'",value];
            
        } else {
            
            [mstr appendFormat:@"'%@',",value];
        }
        i++;
    }
    return mstr;
}
-(BOOL)deleteObject:(id)obj{
    
    NSString * tableName = NSStringFromClass([obj class]);
    NSString * ID = [obj valueForKey:@"ID"];
    NSString * deleteSql = [NSString stringWithFormat:@"delete from t_%@ where id=%@",tableName,ID];
    return [_fmDatabase executeUpdate:deleteSql];
}

-(NSArray *)selectAllobjectFromClass:(Class)tableClass{
    NSString * tableName = NSStringFromClass(tableClass);
    NSString * selectAllSql = [NSString stringWithFormat:@"select * from t_%@",tableName];
   FMResultSet * resultSet = [_fmDatabase executeQuery:selectAllSql];
    NSArray * propertyArray = [self getAllPropertiesFromClass:tableClass];
    //创建数组存储所有的数据
    NSMutableArray * objectArray = [NSMutableArray array];
    while ([resultSet next]) {
        id object = [[tableClass alloc] init];
        //遍历所有属性
        for (NSString * prop in propertyArray) {
            //从结果集中取出数据,并为对象赋值
           id columnValue = [resultSet objectForColumnName:prop];
           //通过kvc方式为对象的属性赋值
            [object setValue:columnValue forKey:prop];
           
        }
        //取出ID值
        NSInteger ID = [resultSet intForColumn:@"ID"];
        [object setValue:[NSNumber numberWithInteger:ID] forKey:@"ID"];
         [objectArray addObject:object];
    }
    return [objectArray copy];
}
-(BOOL)isExistWithObject:(id)objc{
    NSString * tableName = NSStringFromClass([objc class]);
    NSNumber * ID = [objc valueForKey:@"ID"];
    NSString * selectSql = [NSString stringWithFormat:@"select count(*) from t_%@ where id=%@",tableName,ID];
    //执行sql语句
   FMResultSet * resultSet = [_fmDatabase executeQuery:selectSql];
    while ([resultSet next]) {
        //判断取出的数据大小
        int columNum = [resultSet intForColumnIndex:0];
        if (columNum == 0) {
            return NO;
        } else {
            return YES;
        }
    }
    return NO;
}
//通过 运行时获取class中所有的属性
-(NSMutableArray *)getAllPropertiesFromClass:(Class)tableClass{
    unsigned int count = 0;
    NSMutableArray * propArray = [NSMutableArray array];
     objc_property_t * propertyTypeArray = class_copyPropertyList(tableClass, &count);
    for (int i =0; i<count; i++) {
        //从数组中取出数据
        objc_property_t propertyType = propertyTypeArray[i];
        //获取属性名字
        const char * propertyName = property_getName(propertyType);
        NSString * propStr = [NSString stringWithCString:propertyName encoding:NSUTF8StringEncoding];
        [propArray addObject:propStr];
    }
    return [propArray copy];
}
@end
