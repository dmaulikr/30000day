//
//  WeMessageViewController.m
//  30000day
//
//  Created by GuoJia on 16/1/12.
//  Copyright © 2016年 GuoJia. All rights reserved.
//

#import "WeMessageBaseViewController.h"
#import "WCInputView.h"
#import "LOMessageCell.h"
#import "LOChatViewMessageModel.h"
#import "STMessageManager.h"
#import "SJAvatarBrowser.h"

@interface WeMessageBaseViewController () <UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong)NSLayoutConstraint *inputViewBottomConstraint;//inputView底部的约束
@property (nonatomic, strong)NSLayoutConstraint *inputViewHeightConstraint;//inputView高度约束
@property (nonatomic, retain)WCInputView *inputView;

@property (nonatomic, retain)UITableView *tableView;

@property (nonatomic, assign)BOOL isAnimatingKeyBoard;

@property (nonatomic, retain)NSMutableArray *dataArray;

@property (nonatomic, retain) UIRefreshControl *refreshControl;

@property (nonatomic, strong) NSMutableArray *messages;

@property(nonatomic,assign)int isFirstAnimating;

@end

@implementation WeMessageBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isFirstAnimating = 0;
    [self setUPView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardChangeFrame:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHideFrame:) name:UIKeyboardWillHideNotification object:nil];
    
    self.title = self.infomationModel.nickName;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //配置服务器
    [[STMessageManager sharedManager] configManagerWitUserId:[self.infomationModel.userId stringValue] success:^(BOOL success) {
        
        if (success) {
            
            NSLog(@"配置成功");
            //下载数据
            [[STMessageManager sharedManager] queryMessagesWithLimit:10 callback:^(NSArray *objects, NSError *error) {
                // 刷新 Tabel 控件，为其添加数据源
                [self.messages addObjectsFromArray:objects];
                [self reloadTableViewWithMessagesArray:self.messages sorollToLastRow:YES];
                [self.refreshControl endRefreshing];
            }];
        }
        
    } callback:^(AVIMConversation *conversation, AVIMTypedMessage *typeMessage) {
        
        [self.messages addObject:typeMessage];
        
        [self reloadTableViewWithMessagesArray:self.messages sorollToLastRow:YES];
        
    }];
}

- (NSMutableArray *)messages {
    if (!_messages) {
        _messages = [NSMutableArray array];
    }
    return _messages;
}

//键盘出现 -- 搜狗和百度键盘有调用三次的bug
- (void)keyBoardChangeFrame:(NSNotification *)not{
    if (self.isAnimatingKeyBoard) {
        return;
    }
    self.inputViewBottomConstraint.constant = 280;
    [UIView animateWithDuration:0.05 delay:0.1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.isAnimatingKeyBoard = YES;
        [self.view layoutIfNeeded];//做动画的关键
    } completion:^(BOOL finished) {
        self.isAnimatingKeyBoard = NO;
        [self setTableViewCell];
    }];
}

- (void)keyBoardWillHideFrame:(NSNotification *)not {
    
    NSDictionary *userInfo = not.userInfo;
    //动画的持续时间
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    self.inputViewBottomConstraint.constant = 0;
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self setTableViewCell];
    }];
}

- (void)setTableViewCell{
    if (_dataArray.count >= 1) {
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:_dataArray.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

- (void)setUPView {
    
    UITableView *tableView = [[UITableView alloc] init];
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //代码要实现自动布局,要设置下面的属性为NO，自动拉伸设置NO
    tableView.translatesAutoresizingMaskIntoConstraints = NO;
    tableView.delegate = self;
    tableView.dataSource = self;
    self.tableView = tableView;
    [self.view addSubview:self.tableView];
    
    //添加点击事件
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openClick)];
    [self.tableView addGestureRecognizer:tap];
    
    WCInputView *inputView = [WCInputView inputView];
    inputView.translatesAutoresizingMaskIntoConstraints = NO;
    inputView.textView.delegate = self;
    self.inputView = inputView;
    
    //添加按钮的事件
    [inputView.sendBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:inputView];
    
    //1.tableView水平方向约束
    NSDictionary *views =@{@"tableView":tableView,@"inputView":inputView};
    NSArray *tableHConstrains =  [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[tableView]-0-|" options:0 metrics:nil views:views];
    [self.view addConstraints:tableHConstrains];
    
    //2.inputView水平方向的约束
    NSArray *inputViewConstrains =   [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[inputView]-0-|" options:0 metrics:nil views:views];
    [self.view addConstraints:inputViewConstrains];
    
    NSArray *vContrains =  [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[tableView]-0-[inputView(47)]-0-|" options:0 metrics:nil views:views];
    [self.view addConstraints:vContrains];
    
    //3.inputView高度的约束
    self.inputViewHeightConstraint = vContrains[2];
    
    //4.高度的约束
    self.inputViewBottomConstraint = [vContrains lastObject];
    
    //5.为消息列表添加下拉刷新控件，每一次下拉都会增加 10 条聊天记录
    [self.tableView addSubview:self.refreshControl];
    [self.refreshControl beginRefreshing];
}

- (void)openClick {
    [self.view endEditing:YES];
}

- (void)addBtnClick {
    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
    //设置代理
    pickerController.delegate = self;
    //设置允许编辑
    pickerController.allowsEditing = YES;
    //从相册里面去取
    pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    //显示图片选择器
    [self presentViewController:pickerController animated:YES completion:nil];
}

#pragma mark ---- 图片选择器的代理
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    //1.获取图片 设置图片
    UIImage *image = info[UIImagePickerControllerEditedImage];
    
    //2.发送图片
    [self updateImage:image];

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)updateImage:(UIImage *)image {
    
    [self.dataHandler sendUpdateUserHeadPortrait:[Common readAppDataForKey:KEY_SIGNIN_USER_UID] headImage:image success:^(NSString *imageUrl) {
       
        AVIMImageMessage *imageMessage = [AVIMImageMessage messageWithText:imageUrl file:[AVFile fileWithData:UIImageJPEGRepresentation(image, 0.5)] attributes:nil];
        
        imageMessage.text = imageUrl;
        
        [[STMessageManager sharedManager] sendMessageMessage:imageMessage sendSuccess:^(BOOL success, AVIMTypedMessage *typeMessage) {
            
            [self.messages addObject:typeMessage];
            
            [self reloadTableViewWithMessagesArray:self.messages sorollToLastRow:YES];
            
        } callback:^(AVIMConversation *conversation, AVIMTypedMessage *typeMessage) {
            
            [self.messages addObject:typeMessage];
            
            [self reloadTableViewWithMessagesArray:self.messages sorollToLastRow:YES];
        }];
        
    } failure:^(NSError *error) {
        
        [self showToast:[error userInfo][NSLocalizedDescriptionKey]];
        
    }];
    
}


#pragma set Refresh Control
- (UIRefreshControl *)refreshControl {
    if (_refreshControl == nil) {
        _refreshControl = [[UIRefreshControl alloc] init];
        [_refreshControl addTarget:self action:@selector(loadHistoryMessages:) forControlEvents:UIControlEventValueChanged];
        [_refreshControl setTintColor:[UIColor lightGrayColor]];
    }
    return _refreshControl;
}

//下拉 Table View 的时候，从服务端获取更多的消息记录。
- (void)loadHistoryMessages:(UIRefreshControl *)refreshControl {

    if (self.messages.count == 0) {
        [refreshControl endRefreshing];
        return;
    } else {
        
        AVIMTypedMessage *firstMessage = self.messages[0];
        //请求之前的message
        [[STMessageManager sharedManager] queryMessagesBeforeId:nil timestamp:firstMessage.sendTimestamp limit:10 callback:^(NSArray *objects, NSError *error) {
            
            [refreshControl endRefreshing];
            
            if (error == nil) {
                
                NSInteger count = objects.count;
                
                UILabel *label = [[UILabel alloc] init];
                
                label.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"timeline_new_status_background"]];
                
                label.width = [UIScreen mainScreen].bounds.size.width;
                
                label.height = 35;
                
                label.textAlignment = NSTextAlignmentCenter;
                
                if (count == 0) {
                   
                    
                } else {
                    //1.顶部动画
                    label.text = [NSString stringWithFormat:@"加载%d条消息",(int)count];
                    label.textColor = [UIColor whiteColor];
                    label.font = [UIFont systemFontOfSize:16];
                    //3.添加
                    label.y = 64 - label.height;
                    [self.navigationController.view insertSubview:label belowSubview:self.navigationController.navigationBar];
                    //4.动画
                    [UIView animateWithDuration:0.5 animations:^{
                        label.transform = CGAffineTransformMakeTranslation(0, label.height);
                    } completion:^(BOOL finished) {//上面的动作完成是执行下面的代码块
                        CGFloat delay = 0.3;//动画的延迟执行
                        [UIView animateWithDuration:1 delay:delay options:UIViewAnimationOptionCurveEaseInOut animations:^{
                            label.transform = CGAffineTransformIdentity;
                        } completion:^(BOOL finished) {
                            [label removeFromSuperview];//在结束的时候干的事
                        }];
                    }];
                    
                    // 将更早的消息记录插入到 Tabel View 的顶部
                    NSIndexSet *indexes = [NSIndexSet indexSetWithIndexesInRange:
                                           NSMakeRange(0,[objects count])];
                    [self.messages insertObjects:objects atIndexes:indexes];
                    [self reloadTableViewWithMessagesArray:self.messages sorollToLastRow:NO];
                }
            }
        }];
    }
}

//异步处理数据刷新界面
- (void)reloadTableViewWithMessagesArray:(NSMutableArray *)messagesArray sorollToLastRow:(BOOL)isScroll{
    
    [LOChatViewMessageModel configMessageArrayWithMessageArray:messagesArray FromClientId:[STUserAccountHandler.userProfile.userId stringValue] toClientId:[NSString stringWithFormat:@"%@",self.infomationModel.userId] block:^(BOOL sucess, NSMutableArray *newArray) {
        
        self.dataArray = [NSMutableArray arrayWithArray:newArray];
        
        if (self.dataArray.count) {
            
            if (self.dataArray.count!=0) {
                
                [self.tableView reloadData];
                
                if (isScroll) {
                    
                    if (!self.isFirstAnimating) {
                        
                        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:self.dataArray.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
                        
                    } else {
                        
                        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:self.dataArray.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                    }
                    
                    self.isFirstAnimating++;
                }
            }
        }
    }];
}

#pragma mark --- UITableViewDataSource/UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LOMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LOMessageCell"];
    
    if (!cell) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"LOMessageCell" owner:self options:nil] lastObject];
    }
    
    GJChatViewMessageDetailModel *detailModel = self.dataArray[indexPath.row];
    
    cell.messageDetailModel = detailModel;
    
    [cell.friendsHeaderView sd_setImageWithURL:[NSURL URLWithString:self.infomationModel.headImg] placeholderImage:[UIImage imageNamed:@"placeholder"]];//给好友头像赋值
    
    [cell.myHeaderView  sd_setImageWithURL:[NSURL URLWithString:STUserAccountHandler.userProfile.headImg] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    //回调函数
    [cell setClickBlock:^(UIImageView *imageView) {
        if (imageView.image) {
            [SJAvatarBrowser showImage:imageView];
        }
    }];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    GJChatViewMessageDetailModel *detailModel = self.dataArray[indexPath.row];
    if ([detailModel.symbolStr isEqualToString:MESSAGE_IMAGE]) {
        return detailModel.imageViewCellHeight;
    }else{
        return detailModel.messageCellHeight;
    }
    return 44.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 10;
    }else{
        return 0.1;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
        view.backgroundColor = [UIColor clearColor];
        return view;
    }
    return nil;
}

#pragma mark --- UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    CGSize size = textView.contentSize;
    if (size.height == 37.0f) {
        self.inputViewHeightConstraint.constant = 47;
    }else if (size.height == 57.0f){
        self.inputViewHeightConstraint.constant  = 47+ 20;
    }else if (size.height == 77.0f){
        self.inputViewHeightConstraint.constant  = 47.0f+20*2;
    }else if (size.height == 98.0f){
        self.inputViewHeightConstraint.constant  = 47 + 20*3;
    }else if (size.height == 118.0f){
        self.inputViewHeightConstraint.constant  = 47 + 20*4;
    }else if (size.height == 138.0f){
        self.inputViewHeightConstraint.constant = 47 + 20*5;
    }
    //这地方不能加上 layoutIfneed不然会出现了莫名的错误
}

//设置UITextView光标自适应高度
- (void)textViewDidChangeSelection:(UITextView *)textView {
    CGRect r = [textView caretRectForPosition:textView.selectedTextRange.end];
    CGFloat caretY = MAX(r.origin.y - textView.frame.size.height+r.size.height,0);
    if (textView.contentOffset.y < caretY && r.origin.y != INFINITY) {
        textView.contentOffset = CGPointMake(0, caretY);
    }
    [self.tableView reloadData];
    [self setTableViewCell];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqual:@"\r\r"]) {
        return NO;
    }
    if ([text isEqual:@"\n"]) {//判断输入字符是否是回车,即按下
        if ([textView.text isEqual:@""]) {
            return NO;
        } else {
            NSString *str = [textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            //发送消息
            AVIMTextMessage *textMessage = [AVIMTextMessage messageWithText:str attributes:nil];
            //发送消息
            [[STMessageManager sharedManager] sendMessageMessage:textMessage sendSuccess:^(BOOL sucess, AVIMTypedMessage *typeMessage) {
                [self.messages addObject:typeMessage];
                [self reloadTableViewWithMessagesArray:self.messages sorollToLastRow:YES];
            } callback:^(AVIMConversation *conversation, AVIMTypedMessage *message) {
                [self.messages addObject:message];
                [self reloadTableViewWithMessagesArray:self.messages sorollToLastRow:YES];
            }];
            textView.text = @"";
            self.inputViewHeightConstraint.constant = 47;
            //这地方的很关键,每次改变了约束都要调用这个方法,重新排布
            [self.view layoutIfNeeded];
            return NO;
        }
    }
    return YES;
}

@end
