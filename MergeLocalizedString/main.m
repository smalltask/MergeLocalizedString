//
//  main.m
//  MergeLocalizedString
//
//  Created by  SmallTask on 13-8-23.
//  Copyright (c) 2013年 cmf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FileIO.h"

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        
        // insert code here...
        NSLog(@"Hello, World!");
        
        NSString *oldfile = nil;
        NSString *newfile = nil;
        
        if(argc>1)
        {
            oldfile = [NSString stringWithFormat:@"%s",argv[1]];
            newfile = [NSString stringWithFormat:@"%s",argv[2]];
        }else{
            oldfile = @"./Localizable.old.strings";
            newfile = @"./Localizable.new.strings";
        }
        
        NSLog(@"oldFile:%@",oldfile);
        
        FileIO *fileIO = [[[FileIO alloc] init] autorelease];
        NSMutableDictionary *oldFileDic = [fileIO readFile:oldfile];
        NSMutableDictionary *newFileDic = [fileIO readFile:newfile];
        
        NSMutableArray *outArray = [NSMutableArray arrayWithCapacity:5000];
        
        for(NSString *key in newFileDic.allKeys)
        {
            NSString *oldValue = [oldFileDic valueForKey:key];
            if(oldValue)
            {
                [newFileDic setValue:oldValue forKey:key];
                NSString *lineStr = [NSString stringWithFormat:@"\"%@\" = \"%@\";",key,oldValue];
                [outArray addObject:lineStr];
            }else{
                NSString *newValue = [newFileDic valueForKey:key];
                NSString *lineStr = [NSString stringWithFormat:@"\"%@\" = \"%@\";",key,newValue];
                [outArray addObject:lineStr];
            }
        }
        //对outArray排序
        NSArray *okArray = [outArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSString *str1 = (NSString*)obj1;
            NSString *str2 = (NSString*)obj2;
            return [str1 compare: str2];    
        }];
        
        //打印结果
        NSMutableString *outStr = [NSMutableString stringWithCapacity:5000];
        [outStr appendString:@"\n/*\n\n\
 ProjectName: mls  (MergeLocalizedString) \n\n\
 Usage：\n\
 ./MergeLocalizedString oldLocalizedFileName newLocalizedFileName outLocalizedFileName \n\n\
 tips:use full file name (you can find full file name from file's intrduction)\n\n\
 How to create Localized.string:\n\
 find ./ -name *.m -print0 | xargs -0 genstrings -o res/en.lproj  \n\n\
 smalltask@gmail.com\n\
 2013.8.23\n\n\
 */\n\n\n\n"];
        
        for(int i=0;i<okArray.count;i++)
        {
            [outStr appendString:@"/*  */\n"];
            [outStr appendString:[okArray objectAtIndex:i]];
            [outStr appendString:@"\n\n"];
        }
        NSError *error=nil;
        [outStr writeToFile:@"out.strings" atomically:NO encoding:NSUTF8StringEncoding error:&error];
        if(error)
            NSLog(@"%@",[error localizedDescription]);
        else
            NSLog(@"%@",outStr);

        return 0;
        
    }
    return 0;
}




