//
//  NSArray+QXUtils.m
//  Pods
//
//  Created by Qianxia on 2016/12/22.
//  Copyright © 2016年 黄旺鑫. All rights reserved.
//

#import "NSArray+QXUtils.h"
#import "NSDictionary+QXUtils.h"

@implementation NSArray (QXUtils)

/**
 *  倒序后的数组
 *
 *  @return 倒序后的数组
 */
- (NSArray *)reversed {
    return [[self reverseObjectEnumerator] allObjects];
}

/**
 *  生成JSON格式的字符串
 *  A JSON formatted string from the receiver.
 */
- (NSString *)JSONString {
    
    if (self.count > 0) {
        NSError *error;
        NSData *data = [NSJSONSerialization dataWithJSONObject:self options:0 error:&error];
#ifdef DEBUG
        NSAssert(!error, @"Error serializing dictionary %@. Error: %@", self, error);
#endif
        return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    
    return nil;
}

/**
 *  删除重复的对象后的数组(每个对象都是唯一的)
 *  A copy of the receiver, but with duplicate values removed.
 */
- (NSArray *)distinctArray {
    // 此方法排序错乱
    //    NSArray *unique = [self valueForKeyPath:@"@distinctUnionOfObjects.self"];
    
    // 移除重复对象后的数组
    NSArray *unique = [NSOrderedSet orderedSetWithArray:self].array.copy;
    
#ifdef DEBUG
    NSParameterAssert([unique isKindOfClass:[NSArray class]] && unique.count <= self.count);
#endif
    return unique;
}

/**
 *  移除所有NSNull对象
 *  Remove all null objects
 *
 *  @return Returns an array of none null.
 */
- (NSArray *)removeNulls {
    
    // 拷贝为可变数组
    NSMutableArray *replaced = [NSMutableArray arrayWithArray:self];
    
    // 移除当前数组中的null对象
    [replaced removeObjectsAtIndexes:[self indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        return [obj isKindOfClass:[NSNull class]];
    }]];
    
    // 遍历数组，移除当前数组中的元素是数组或字典中包含的null对象
    [replaced enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        if ([obj isKindOfClass:[NSNull class]]) {
            /**
             *  @brief  此处直接移除null，而不是替换为字符串
             *  替换成字符串可能导致程序闪退，原因：原本是要NSArray或者NSDictionary对象，我们替换成NSString对象，导致读取出错而闪退
             */
            [replaced removeObjectAtIndex:idx];
            
        } else if ([obj isKindOfClass:[NSArray class]]) {
            
            id newObj = [obj removeNulls];
            [replaced replaceObjectAtIndex:idx withObject:newObj];
            
        } else if ([obj isKindOfClass:[NSDictionary class]]) {
            
            id newObj = [obj removeNulls];
            [replaced replaceObjectAtIndex:idx withObject:newObj];
        }
        
    }];
    
    return replaced;
}

/**
 是否包含NSNull
 
 @return 判断参数是否包含NSNull
 */
- (BOOL)containsNSNull {
    
    for (id value in self) {
        if ([value isKindOfClass:[NSNull class]]) {
            return YES;
        } else if ([value isKindOfClass:[NSDictionary class]]) {
            
            return [value containsNSNull];
        } else if ([value isKindOfClass:[NSArray class]]) {
            
            return [value containsNSNull];
        }
    }
    return NO;
}

/**
 *   枚举遍历数组
 *   Loops through an array and executes the given block with each object.
 *
 *  @param block A single-argument, void-returning code block.
 */
- (void)wx_each:(void (^)(id obj))block {
    
    NSParameterAssert(block != nil);
    
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL * stop) {
        block(obj);
    }];
}

/**
 *  枚举数组，并发串行执行代码块
 *  Enumerates through an array concurrently and executes the given block once for each object.
 *
 Enumeration will occur on appropriate background queues. This will have a noticeable speed increase, especially on dual-core devices, but you *must* be aware of the thread safety of the objects you message from within the block. Be aware that the order of objects is not necessarily the order each block will be called in.
 *
 *  @param block A single-argument, void-returning code block.
 */
- (void)wx_apply:(void (^)(id obj))block {
    
    NSParameterAssert(block != nil);
    
    /*
     *  NSEnumerationConcurrent 枚举过程中，各个Block是同时开始执行的。这样枚举的完成顺序是不确定的。
     NSEnumerationReverse  以反序方式枚举。
     */
    [self enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id obj, NSUInteger idx, BOOL * stop) {
        block(obj);
    }];
}

/**
 *  遍历筛选符合代码块的条件的对象
 *  Loops through an array to find the object matching the block.
 *
 *  wx_match: is functionally identical to wx_select:, but will stop and return on the first match.
 *
 *  @param block A single-argument, `BOOL`-returning code block.
 *
 *  @return Returns the object, if found, or `nil`.
 *  @see wx_select:
 */
- (id)wx_match:(BOOL (^)(id obj))block {
    
    NSParameterAssert(block != nil);
    
    // 遍历符合代码块条件的对象所在下标志
    NSUInteger index = [self indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        return block(obj);
    }];
    
    if (index == NSNotFound) {
        return nil;
    }
    
    return self[index];
}

/**
 *  筛选出符合代码块条件的对象组
 *  Loops through an array to find the objects matching the block.
 *
 *  @param block A single-argument, BOOL-returning code block.
 *
 *  @return Returns an array of the objects found.
 *  @see wx_match:
 */
- (NSArray *)wx_select:(BOOL (^)(id obj))block {
    NSParameterAssert(block != nil);
    
    // 筛选出符合代码块条件的对象组
    return [self objectsAtIndexes:[self indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        return block(obj);
    }]];
}

/**
 *  筛选出不符合代码块条件的对象组
 *  Loops through an array to find the objects not matching the block.
 *
 *  This selector performs *literally* the exact same function as wx_select: but in reverse.
 *
 *  This is useful, as one may expect, for removing objects from an array.
 NSArray *new = [computers wx_reject:^BOOL(id obj) {
 return ([obj isUgly]);
 }];
 *
 *  @param block A single-argument, BOOL-returning code block.
 *
 *  @return Returns an array of all objects not found.
 */
- (NSArray *)wx_reject:(BOOL (^)(id obj))block {
    NSParameterAssert(block != nil);
    
    // 筛选出不符合代码块条件的对象组
    return [self wx_select:^BOOL(id obj) {
        return !block(obj);
    }];
}



/**
 *  遍历，并用代码块处理每个对象，生成处理过的数组
 *  Call the block once for each object and create an array of the return values.
 *
 *  This is sometimes referred to as a transform, mutating one of each object:
 NSArray *new = [stringArray wx_map:^id(id obj) {
 return [obj stringByAppendingString:@".png"]);
 }];
 *
 *  @param block A single-argument, object-returning code block.
 *
 *  @return Returns an array of the objects returned by the block.
 */
- (NSArray *)wx_map:(id (^)(id obj))block {
    
    NSParameterAssert(block != nil);
    
    // 初始化数组
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:self.count];
    
    // 枚举用代码块处理每个对象
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        id value = block(obj) ?: nil;
        [result addObject:value];
    }];
    
    return result;
}

/**
 *  遍历每个对象，累计处理产生一个结果
 *  Arbitrarily accumulate objects using a block.
 *
 *  The concept of this selector is difficult to illustrate in words. The sum can be any NSObject, including (but not limited to) a string, number, or value.
 *
 *
 *  For example, you can concentate the strings in an array:
 NSString *concentrated = [stringArray wx_reduce:@"" withBlock:^id(id sum, id obj) {
 return [sum stringByAppendingString:obj];
 }];
 
 *  You can also do something like summing the lengths of strings in an array:
 NSUInteger value = [[[stringArray wx_reduce:nil withBlock:^id(id sum, id obj) {
 return @([sum integerValue] + obj.length);
 }]] unsignedIntegerValue];
 *
 *
 *  @param initial The value of the reduction at its start.
 *  @param block   A block that takes the current sum and the next object to return the new sum.
 *
 *  @return An accumulated value.
 */
- (id)wx_reduce:(id)initial withBlock:(id (^)(id sum, id obj))block {
    
    NSParameterAssert(block != nil);
    
    __block id result = initial;
    
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        result = block(result, obj);
    }];
    
    return result;
}

/**
 *  遍历每个对象，累加处理产生一个结果
 *  Sometimes we just want to loop an objects list and reduce one property, where  each result is a primitive type.
 *
 *  For example, say we want to calculate the total age of a list of people.
 *
 *  Code without using block will be something like:
 
 NSArray *peoples = @[p1, p2, p3];
 NSInteger totalAge = 0;
 for (People *people in peoples) {
 totalAge += [people age];
 }
 *
 *
 *   We can use a block to make it simpler:
 
 NSArray *peoples = @[p1, p2, p3];
 NSInteger totalAge = [peoples reduceInteger:0 withBlock:^(NSInteger result, id obj, NSInteger index) {
 return result + [obj age];
 }];
 *
 *  @param initial The value of the reduction at its start.
 *  @param block   block A block that takes the current sum and the next object to return the new sum.
 *
 *  @return An accumulated value.
 */
- (NSInteger)wx_reduceInteger:(NSInteger)initial withBlock:(NSInteger(^)(NSInteger result, id obj))block {
    
    NSParameterAssert(block != nil);
    
    __block NSInteger result = initial;
    
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        result = block(result, obj);
    }];
    
    return result;
}

/**
 *  遍历每个对象，累加处理产生一个CGFloat值
 *  Sometimes we just want to loop an objects list and reduce one property, where each result is a primitive type.
 *
 *  For instance, say we want to caculate the total balance from a list of people.
 *
 *  Code without using a block will be something like:
 
 NSArray *peoples = @[p1, p2, p3];
 CGFloat totalBalance = 0;
 for (People *people in peoples) {
 totalBalance += [people balance];
 }
 *
 *  We can use a block to make it simpler:
 
 NSArray *peoples = @[p1, p2, p3];
 CGFloat totalBalance = [peoples reduceFloat:.0f WithBlock:^CGFloat(CGFloat result, id obj, NSInteger index) {
 return result + [obj balance];
 }];
 
 *
 *  @param initial The value of the reduction at its start.
 *  @param block   block A block that takes the current sum and the next object to return the new sum.
 *
 *  @return An accumulated value.
 */
- (CGFloat)wx_reduceFloat:(CGFloat)initial withBlock:(CGFloat(^)(CGFloat result, id obj))block {
    
    NSParameterAssert(block != nil);
    
    __block CGFloat result = initial;
    
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        result = block(result, obj);
    }];
    
    return result;
}


/**
 *  判断是否存在符合代码块条件的对象
 *  Loops through an array to find whether any object matches the block.
 *
 *  This method is similar to the Scala list `exists`. It is functionally identical to wx_match: but returns a `BOOL` instead. It is not recommended to use wx_any: as a check condition before executing wx_match:, since it would require two loops through the array.
 *
 *  For example, you can find if a string in an array starts with a certain letter:
 
 NSString *letter = @"A";
 BOOL containsLetter = [stringArray wx_any:^(id obj) {
 return [obj hasPrefix:@"A"];
 }];
 *
 *  @param block A single-argument, BOOL-returning code block.
 *
 *  @return YES for the first time the block returns YES for an object, NO otherwise.
 */
- (BOOL)wx_any:(BOOL (^)(id obj))block {
    
    return [self wx_match:block] != nil;
}


/**
 *  判断不存在符合代码块条件的对象
 *  Loops through an array to find whether no objects match the block.
 *
 *  This selector performs *literally* the exact same function as wx_all: but in reverse.
 *
 *  @param block A single-argument, BOOL-returning code block.
 *
 *  @return YES if the block returns NO for all objects in the array, NO otherwise.
 */
- (BOOL)wx_none:(BOOL (^)(id obj))block {
    
    return [self wx_match:block] == nil;
}

/**
 *  判断每个对象是否符合代码块条件
 *  Loops through an array to find whether all objects match the block.
 *
 *  @param block A single-argument, BOOL-returning code block.
 *
 *  @return YES if the block returns YES for all objects in the array, NO otherwise.
 */
- (BOOL)wx_all:(BOOL (^)(id obj))block {
    
    NSParameterAssert(block != nil);
    
    __block BOOL result = YES;
    
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (!block(obj)) {
            result = NO;
            *stop = YES;
        }
    }];
    
    return result;
}


/**
 *  判断两个数组是否对应符合代码块条件
 *  Tests whether every element of this array relates to the corresponding element of another array according to match by block.
 *
 *  For example, finding if a list of numbers corresponds to their sequenced string values;
 NSArray *numbers = @[ @(1), @(2), @(3) ];
 NSArray *letters = @[ @"1", @"2", @"3" ];
 BOOL doesCorrespond = [numbers wx_corresponds:letters withBlock:^(id number, id letter) {
 return [[number stringValue] isEqualToString:letter];
 }];
 *
 *  @param list  An array of objects to compare with.
 *  @param block A two-argument, BOOL-returning code block.
 *
 *  @return Returns a BOOL, true if every element of array relates to corresponding element in another array.
 */
- (BOOL)wx_corresponds:(NSArray *)list withBlock:(BOOL (^)(id obj1, id obj2))block {
    
    NSParameterAssert(block != nil);
    
    __block BOOL result = NO;
    
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        if (idx < list.count) {
            id obj2 = list[idx];
            result = block(obj, obj2);
        } else {
            result = NO;
        }
        
        *stop = !result;
    }];
    
    return result;
}

/**
 *  拼接两个数组，生成一个都是唯一的对象的数组
 *  Generate a new array, each object is unique
 *
 *  @param anArray An array containing the objects to add to the new Array. If the same object appears more than once in array, it is added only once to the returned Array.
 *
 *  For example：
 *  NSArray *subject = @[@"6", @"1", @"2", @"2", @"2", @"2", @"3", @"2", @"22", @"1", @"5"];
 NSArray *otherAry = @[@"1", @"2", @"7", @"9", @"10", @"11", @"19", @"22"];
 NSArray *unionAry = [subject wx_unionWithArray:otherAry];
 
 *  the unionAry is ["6","1","2","3","22","5","7","9","10","11","19"]
 *
 *  @return A new array containing a uniqued collection of the objects.
 */
- (NSArray *)wx_unionWithArray:(NSArray *)anArray {
    
    NSMutableOrderedSet *set1 = [NSMutableOrderedSet orderedSetWithArray:self];
    NSMutableOrderedSet *set2 = [NSMutableOrderedSet orderedSetWithArray:anArray];
    
    [set1 unionOrderedSet:set2];
    
    return set1.array.copy;
}

/**
 *  比较两个数组，筛选出两个数组都出现的的对象（多个重复也只返回一次）
 *  Comparison of two arrays, Find Objects that appear in each of two arrays
 *
 *  @param anArray An array with which to perform the intersection.
 *
 *  For example：
 *  NSArray *subject = @[@"6", @"6", @"1", @"2", @"2", @"2", @"2", @"3", @"2", @"22", @"1", @"5"];
 NSArray *otherAry = @[@"1", @"2", @"7", @"9", @"10", @"11", @"19", @"22"];
 NSArray *intersectionAry = [subject wx_intersectionWithArray:otherAry];
 
 *  the intersectionAry is ["1","2","22"]
 *
 *  @return A new array is appear in each of two arrays that object is a uniqu.
 */
- (NSArray *)wx_intersectionWithArray:(NSArray *)anArray {
    
    NSMutableOrderedSet *set1 = [NSMutableOrderedSet orderedSetWithArray:self];
    NSMutableOrderedSet *set2 = [NSMutableOrderedSet orderedSetWithArray:anArray];
    
    [set1 intersectOrderedSet:set2];
    return set1.array.copy;
}

/**
 *  找出在anArray没有的对象数组
 *  Comparison of two arrays, Find Objects that no appear in anArray.
 *
 *  @param anArray An array with which comparison.
 *
 *  For example：
 *  NSArray *subject = @[@"6", @"6", @"1", @"2", @"2", @"2", @"2", @"3", @"2", @"22", @"1", @"5"];
 NSArray *otherAry = @[@"1", @"2", @"7", @"9", @"10", @"11", @"19", @"22"];
 NSArray *differenceAry = [subject wx_differenceToArray:otherAry];
 
 *  the differenceAry is ["6","3","5"]
 *
 *  @return A new array is duplicate objects that object is a uniqu.
 */
- (NSArray *)wx_differenceToArray:(NSArray *)anArray {
    NSMutableOrderedSet *set1 = [NSMutableOrderedSet orderedSetWithArray:self];
    NSMutableOrderedSet *set2 = [NSMutableOrderedSet orderedSetWithArray:anArray];
    
    [set1 minusOrderedSet:set2];
    return set1.array.copy;
}

@end
