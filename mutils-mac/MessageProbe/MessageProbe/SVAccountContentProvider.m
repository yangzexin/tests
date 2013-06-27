//
//  SVAccountContentProvider.m
//  MessageProbe
//
//  Created by yangzexin on 6/10/13.
//  Copyright (c) 2013 yangzexin. All rights reserved.
//

#import "SVAccountContentProvider.h"
#import "SVMessageAccount.h"
#import "TBXML.h"

@interface SVTxtFileAccountContentProvider ()

@property(nonatomic, retain)NSArray *accounts;
@property(nonatomic, assign)NSInteger offset;

@end

@implementation SVTxtFileAccountContentProvider

- (void)dealloc
{
    self.accounts = nil;
    [super dealloc];
}

- (id)initWithTxtFilePath:(NSString *)txtFilePath
{
    self = [super init];
    
    NSString *txt = [NSString stringWithContentsOfFile:txtFilePath encoding:NSUTF8StringEncoding error:nil];
    txt = [txt stringByReplacingOccurrencesOfString:@"\r" withString:@"\n"];
    NSArray *tmpAccounts = [txt componentsSeparatedByString:@"\n"];
    NSMutableArray *nonBlankAccounts = [NSMutableArray array];
    for(NSString *account in tmpAccounts){
        account = [account stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        account = [account stringByTrimmingCharactersInSet:[NSCharacterSet controlCharacterSet]];
        if(account.length != 0){
            [nonBlankAccounts addObject:account];
        }
    }
    self.accounts = nonBlankAccounts;
    self.offset = 0;
    
    return self;
}

- (SVMessageAccount *)nextAccount
{
    if(self.offset < self.accounts.count){
        NSString *account = [self.accounts objectAtIndex:self.offset++];
        SVMessageAccount *messageAccount = [[SVMessageAccount new] autorelease];
        messageAccount.account = [account stringByTrimmingCharactersInSet:[NSCharacterSet controlCharacterSet]];
        return messageAccount;
    }
    return nil;
}

- (NSInteger)numberOfAccounts
{
    return self.accounts.count;
}

- (void)cancel
{
}

@end

@interface SVOnlineAccountContentProvider ()

@property(nonatomic, copy)NSString *URLString;
@property(nonatomic, retain)NSMutableArray *accounts;
@property(nonatomic, assign)NSInteger offset;
@property(nonatomic, assign)BOOL canceled;

@end

@implementation SVOnlineAccountContentProvider

- (void)dealloc
{
    self.URLString = nil;
    self.accounts = nil;
    [super dealloc];
}

- (id)initWithURLString:(NSString *)URLString
{
    self = [super init];
    
    self.URLString = URLString;
    self.accounts = [NSMutableArray array];
    self.offset = 0;
    self.canceled = NO;
    
    return self;
}

- (SVMessageAccount *)nextAccount
{
    if(self.offset == self.accounts.count){
        self.offset = 0;
        [self.accounts removeAllObjects];
        MSLog(@"nextAccoung:%@", self.URLString);
        NSString *response = [NSString stringWithContentsOfURL:[NSURL URLWithString:self.URLString] encoding:NSUTF8StringEncoding error:nil];
        if(response.length != 0){
            TBXML *xml = [TBXML tbxmlWithXMLString:response];
            TBXMLElement *userElement = [TBXML childElementNamed:@"user" parentElement:xml.rootXMLElement];
            while(userElement){
                TBXMLElement *number = [TBXML childElementNamed:@"number" parentElement:userElement];
                TBXMLElement *uid = [TBXML childElementNamed:@"uid" parentElement:userElement];
                
                SVMessageAccount *account = [[SVMessageAccount new] autorelease];
                account.account = [TBXML textForElement:number];
                account.uid = [TBXML textForElement:uid];
                [self.accounts addObject:account];
                
                userElement = [TBXML nextSiblingNamed:@"user" searchFromElement:userElement];
            }
            MSLog(@"new accounts:%@", self.accounts);
            return [self nextAccount];
        }else{
            MSLog(@"连接服务器失败：%@", self.URLString);
            if(!self.canceled){
                [NSThread sleepForTimeInterval:1.0f];
                return [self nextAccount];
            }
        }
    }else if(self.offset < self.accounts.count){
        SVMessageAccount *account = [self.accounts objectAtIndex:self.offset++];
        return account;
    }
    return nil;
}

- (void)cancel
{
    self.canceled = YES;
}

- (NSInteger)numberOfAccounts
{
    return 0;
}

@end
