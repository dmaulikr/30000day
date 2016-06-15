//
//  STGroupViewController.m
//  30000day
//
//  Created by GuoJia on 16/6/14.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "STGroupViewController.h"
#import "CDChatManager.h"
#import "STFriendsViewController.h"

@interface STGroupViewController ()

@end

@implementation STGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"群组";
    [self loadGroupConversation];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"新建" style:UIBarButtonItemStylePlain target:self action:@selector(creatNewGroup)];
    
    self.navigationItem.rightBarButtonItem = item;
}

//新建一个群聊
- (void)creatNewGroup {
    
    STFriendsViewController *controller = [[STFriendsViewController alloc] init];
    
    STNavigationController *navigationController = [[STNavigationController alloc] initWithRootViewController:controller];
    
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)loadGroupConversation {//这地方如果没有网络的会崩溃
    
    [[CDChatManager sharedManager] findGroupedConversationsWithBlock:^(NSArray *objects, NSError *error) {
        
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
