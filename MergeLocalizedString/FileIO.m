//
//  FileIO.m
//  MergeLocalizedString
//  
//  Created by  SmallTask on 13-8-23.
//  Copyright (c) 2013年 cmf. All rights reserved.
//

#import "FileIO.h"

@implementation FileIO


-(NSMutableDictionary *) readFile:(NSString *)filename;
{
    NSError *error = nil;
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:5000];
    NSString *txt = [NSString stringWithContentsOfFile:filename encoding:NSUTF8StringEncoding error:&error];
    if(error)
        NSLog(@"error:%@",[error localizedDescription]);
    else{
//        NSLog(@"%@",txt);
    }
    NSArray *txtArray = [txt componentsSeparatedByString:@"\n"];
    BOOL IsCommentBegin = NO;
    BOOL IsCommentEnd = NO;
    for(int i=0;i<txtArray.count;i++)
    {
        NSString *lineStr = [[txtArray objectAtIndex:i] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//        NSLog(@"%@",lineStr);
        if(lineStr.length>=2)
        {
            if(IsCommentEnd)
            {
                //恢复
                IsCommentBegin = NO;
                IsCommentEnd = NO;
            }
            
            NSString *f2 = [lineStr substringToIndex:2];
            NSRange rangeE = NSMakeRange(lineStr.length-2, 2);
            NSString *e2 = [lineStr substringWithRange:rangeE];
            
            if([f2 isEqualToString:@"/*"]){
                //注释开始，跳过该行
                IsCommentBegin = YES;
                if([e2 isEqualToString:@"*/"])
                {
                    IsCommentBegin = NO;
                    IsCommentEnd = NO;
                }
                continue;
            }
            
            if([f2 isEqualToString:@"//"])
            {
                //注释，跳过该行
                continue;
            }
            

            if([e2 isEqualToString:@"*/"])
            {
                //注释结束,跳过该行
                IsCommentEnd = YES;
                continue;
            }
            if(IsCommentBegin)
                continue;

//            NSLog(@"%@",lineStr);
            NSMutableArray *array = [self GetKeyValueFromLineStr:lineStr];
            [dict setValue:[array objectAtIndex:1] forKey:[array objectAtIndex:0]];

        }
        
    }
    return dict;
}

-(NSMutableArray*)GetKeyValueFromLineStr:(NSString*)lineStr;
{
    BOOL isKeyBegin = NO;
    BOOL isKeyEnd = NO;
    BOOL isValueBegin = NO;
    BOOL isValueEnd = NO;
    
    NSMutableArray *outArray = [NSMutableArray arrayWithCapacity:2];

    NSMutableString *keystr = [NSMutableString stringWithCapacity:50];
    NSMutableString *valuestr = [NSMutableString stringWithCapacity:50];
                               
    for(int i=0;i<lineStr.length;i++)
    {
        NSRange range = NSMakeRange(i,1);
        NSString *word = [lineStr substringWithRange:range];
        if(isKeyBegin==NO && [word isEqualToString:@"\""])
        {
            isKeyBegin = YES;
            continue;
        }else if(isKeyEnd==NO && [word isEqualToString:@"\\"])
        {
            //遇到转义符，后面紧接着的字符也要当成正文；
            [keystr appendString:word];
            i++;
            range = NSMakeRange(i,1);
            word = [lineStr substringWithRange:range];
            [keystr appendString:word];
        }else if(isKeyBegin && [word isEqualToString:@"\""] && isKeyEnd==NO)
        {
            isKeyEnd = YES;
            //keystr里的内容就是 key 的内容
//            NSLog(@"%@",keystr);
            [outArray addObject:keystr];
            continue;
        }else if(isKeyEnd==NO)
        {
            [keystr appendString:word];
        }else if(isKeyEnd && isValueBegin==NO && ([word isEqualToString:@"="]||[word isEqualToString:@" "]))
        {
            continue;
        }else if(isKeyEnd && isValueBegin==NO && [word isEqualToString:@"\""]){
            isValueBegin = YES;
            continue;
        }else if(isKeyEnd && isValueEnd==NO && [word isEqualToString:@"\\"]){
            //遇到转义符，后面紧接着的字符也要当成正文；
            [valuestr appendString:word];
            i++;
            range = NSMakeRange(i,1);
            word = [lineStr substringWithRange:range];
            [valuestr appendString:word];
        }else if(isKeyEnd && isValueBegin && isValueEnd==NO && [word isEqualToString:@"\""]){
            isValueEnd = YES;
            //valuestr里的内容就是 Value 里的内容
//            NSLog(@"-->%@",valuestr);
            [outArray addObject:valuestr];
            break;
        }else if(isValueBegin && isValueEnd==NO){
            [valuestr appendString:word];
        }
            
        
    }
    return outArray;
}

@end
