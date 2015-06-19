//
//  AppDelegate.m
//  SODataTypes(lesson 6)
//
//  Created by Sergey on 01.06.15.
//  Copyright (c) 2015 Sergey. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    int xRows = 10;
    int yColumns = 10;
    
    NSArray *field = [self createPlayFieldXrows:xRows yColumn:yColumns];
    [self printFieldArray:field];
    
    int originX = arc4random() % xRows + 1;
    int originY = arc4random() % yColumns + 1;
    int width = originX == xRows ? 1 : (arc4random() % (xRows - originX) + 1);
    int height = originY == yColumns ? 1 : (arc4random() % (yColumns - originY) + 1);
    
    field = [self createHitFieldFromRect:CGRectMake(originX, originY, width, height) forMainField:field];
    [self printFieldArray:field];
    
    NSLog(@"%@", [self hitPoint:CGPointMake(arc4random()%10 + 1, arc4random()%10 + 1) inArray:field]);
    
    return YES;
}

- (void)printFieldArray:(NSArray *)field {
    NSString *final = @"\n";
    for (int i = 0; i < [field count]; i++) {
        NSArray *temp = [field objectAtIndex:i];
        if (i >= 9) {
            final = [final stringByAppendingString:[NSString stringWithFormat:@"%i ", i+1]];
        } else {
            final = [final stringByAppendingString:[NSString stringWithFormat:@"%i  ", i+1]];
        }
        for (int j = 0; j < [temp count]; j++) {
            NSValue *value = [temp objectAtIndex:j];
            if (i >= 9) {
                final = [final stringByAppendingString:[NSString stringWithFormat:@"%@ ", NSStringFromCGPoint([value CGPointValue])]];
            } else {
                final = [final stringByAppendingString:[NSString stringWithFormat:@" %@ ", NSStringFromCGPoint([value CGPointValue])]];
            }
        }
        final = [final stringByAppendingString:@"\n"];
    }
    
    NSString *xAxis = @"\n";
    
    for (int i = 0; i < [field count]; i++) {
        int temp = i;
        if (i == 0) {
            xAxis = [xAxis stringByAppendingString:[NSString stringWithFormat:@"       %i", ++temp]];
        } else {
            xAxis = [xAxis stringByAppendingString:[NSString stringWithFormat:@"       %i", ++temp]];
        }
    }
    
    xAxis = [xAxis stringByAppendingString:final];
    
    NSLog(@"%@", xAxis);
}

- (NSString *)hitPoint:(CGPoint)point inArray:(NSArray *)array {
    if (array == nil) {
        return @"Failed. No Field was created";
    }
    if (point.x <= 0 || point.y <= 0) {
        return @"Failed. Point can't be negative";
    }
    NSArray *temp = [array objectAtIndex:point.x - 1];
    NSValue *value = [temp objectAtIndex:point.y - 1];
    if ([value isEqualToValue:[NSValue valueWithCGPoint:CGPointMake(-1, -1)]]) {
        return [NSString stringWithFormat:@"Success! Hit point = %@", NSStringFromCGPoint(point)];
    }
    return [NSString stringWithFormat:@"Failed! Miss point = %@", NSStringFromCGPoint(point)];
}

- (NSArray *)createPlayFieldXrows:(int)x yColumn:(int)y {
    if (x <= 0 || y <= 0) {
        NSLog(@"Can't be 0");
        return nil;
    }
    NSMutableArray *field = [[NSMutableArray alloc] init];
    for (int i = 1; i <= x; i++) {
        NSMutableArray *temp = [[NSMutableArray alloc] init];
        for (int j = 1; j <= y; j++) {
            NSValue *value = [NSValue valueWithCGPoint:CGPointMake(i, j)];
            [temp addObject:value];
        }
        [field addObject:temp];
    }
    return (NSArray *)field;
}

- (NSArray *)createHitFieldFromRect:(CGRect)rect forMainField:(NSArray *)array {
    NSLog(@"Field for hit: %@", NSStringFromCGRect(rect));
    if (rect.origin.x <= 0 || rect.origin.y <= 0) {
        NSLog(@"Can't be 0");
        return nil;
    }
    if (rect.origin.x + rect.size.width > [array count]+1 || rect.origin.y + rect.size.height > [array [0] count]+1) {
        NSLog(@"Width %f or height %f from point x %f or point y %f bigger than length of array %li", rect.size.width, rect.size.height, rect.origin.x, rect.origin.y, [array count]);
        return  nil;
    }
    if (rect.size.width == 0 || rect.size.height == 0) {
        NSLog(@"Rect width or height can't be %f", MIN(rect.size.width, rect.size.height));
        return nil;
    }
    NSMutableArray *field = [[NSMutableArray alloc] initWithArray:array];
    for (int i = rect.origin.y-1; i < rect.origin.y + rect.size.height-1; i++) {
        NSMutableArray *temp = [field objectAtIndex:i];
        for (int j = rect.origin.x-1; j < rect.origin.x + rect.size.width-1; j++) {
            NSValue *value = [NSValue valueWithCGPoint:CGPointMake(-1, -1)];
            [temp replaceObjectAtIndex:j withObject:value];
        }
        [field replaceObjectAtIndex:i withObject:temp];
    }
    return (NSArray *)field;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
