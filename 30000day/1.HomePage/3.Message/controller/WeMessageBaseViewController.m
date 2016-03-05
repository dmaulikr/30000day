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
#import "STInputView.h"

//http://static.zqgame.com/html/playvideo.html?name=http://lom.zqgame.com/v1/video/LOM_Promo~2.flv

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

@property (nonatomic,strong) UIImagePickerController *imagePicker;

@property (assign,nonatomic) int isSeytemKeyBord;//是否是系统的键盘

@end

@implementation WeMessageBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isFirstAnimating = 0;
    self.isSeytemKeyBord = YES;
    [self setUPView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardChangeFrame:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHideFrame:) name:UIKeyboardWillHideNotification object:nil];
    
    self.title = self.infomationModel.nickName;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //配置服务器
    [[STMessageManager sharedManager] configManagerWitUserId:[self.infomationModel.userId stringValue] success:^(BOOL success) {
        
        if (success) {
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
- (void)keyBoardChangeFrame:(NSNotification *)not {
    
    if (self.isSeytemKeyBord) {//是系统键盘
        
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
        
    } else {//是自定义键盘
        
        
        
        
        
    }
}

- (void)keyBoardWillHideFrame:(NSNotification *)not {
    
    if (self.isSeytemKeyBord) {
        
        NSDictionary *userInfo = not.userInfo;
        //动画的持续时间
        double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        self.inputViewBottomConstraint.constant = 0;
        [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            [self setTableViewCell];
        }];
        
    } else {
        
        
        
    }
    
}

- (void)setTableViewCell {
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
    
    
    STInputView *view = [STInputView inputView];
    
#pragma mark ----- 点击自定义键盘的按钮回调
    [view setButtonClickBlock:^(STInputViewType type) {
        
        if (type == STShowInputViewPhotosAlbum) {
            
            
            [self showPhotoLibrary];
            
        } else if (type == STInputViewTypeCamera) {
            
            
            [self showCameraAction];
            
        } else if (type == STInputViewTypeVideo) {
            
            [self showVideoAction];
        }
        
    }];
    
    view.width = SCREEN_WIDTH;
    view.height = 280;
    view.y = SCREEN_HEIGHT;
    view.backgroundColor = RGBACOLOR(200, 200, 200, 1);
    [self.view addSubview:view];
    
    
    __weak typeof(inputView) weakInputView = inputView;
    
#pragma mark ----- 切换键盘的按钮回调
    [inputView setAddButonBlock:^(WCShowKeybordType type) {
        
        if (type == WCShowInputView) {//弹出inputView
            
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                
                view.y = SCREEN_HEIGHT - 280;
                
            } completion:nil];
            
            self.inputViewBottomConstraint.constant = 280;
            self.isSeytemKeyBord = NO;
            [weakInputView.textView resignFirstResponder];
            
        } else {
            
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                
                view.y = SCREEN_HEIGHT;
                
            } completion:nil];
            
            
            self.isSeytemKeyBord = YES;
            
            [weakInputView.textView becomeFirstResponder];
            
        }
        
    }];
    
    [self.view addSubview:inputView];
    
    [inputView.videoButton addTarget:self action:@selector(showVideoAction) forControlEvents:UIControlEventTouchUpInside];
    
    //1.tableView水平方向约束
    NSDictionary *views = @{@"tableView":tableView,@"inputView":inputView};
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


//显示录制视频
- (void)showVideoAction {
    
    self.imagePicker.mediaTypes = @[(NSString *)kUTTypeMovie];
    
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    self.imagePicker.videoQuality = UIImagePickerControllerQualityTypeIFrame1280x720;
    
    self.imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;//设置摄像头模式（拍照，录制视频）
    
    [self presentViewController:self.imagePicker animated:YES completion:nil];
}

//显示照相
- (void)showCameraAction {
    
    self.imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
    
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    self.imagePicker.allowsEditing = YES;//允许编辑
    
    [self presentViewController:self.imagePicker animated:YES completion:nil];
    
}

//显示照片库
- (void)showPhotoLibrary {
    
    self.imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
    
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
     self.imagePicker.allowsEditing = YES;//允许编辑
    
    [self presentViewController:self.imagePicker animated:YES completion:nil];

}

#pragma mark - 私有方法
- (UIImagePickerController *)imagePicker {
    if (!_imagePicker) {
        _imagePicker = [[UIImagePickerController alloc] init];
    
        _imagePicker.delegate = self;//设置代理，检测操作
    }
    return _imagePicker;
}

#pragma mark ---- 图片选择器的代理
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {//如果是拍照
        //1.获取图片 设置图片
        UIImage *image = info[UIImagePickerControllerEditedImage];
        
        //2.发送图片
        [self sendImage:image];//发送图片
        
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);//保存到相簿
        
    } else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie]) {//如果是录制视频
        
        NSURL *url = [info objectForKey:UIImagePickerControllerMediaURL];//视频路径
        
        NSData *videoData = [NSData dataWithContentsOfURL:url];
        
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum([url path])) {
            
            //保存视频到相簿，注意也可以使用ALAssetsLibrary来保存
            UISaveVideoAtPathToSavedPhotosAlbum([url path], self, @selector(video:didFinishSavingWithError:contextInfo:), nil);//保存视频到相簿
        }
        
        [self sendVideo:videoData];//发送视频
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)sendImage:(UIImage *)image {
    
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

- (void)sendVideo:(NSData *)videoData {
    
    AVIMVideoMessage *videoMessage = [AVIMVideoMessage messageWithText:@"http://static.zqgame.com/html/playvideo.html?name=http://lom.zqgame.com/v1/video/LOM_Promo~2.flv" file:[AVFile fileWithData:videoData] attributes:nil];

    [[STMessageManager sharedManager] sendMessageMessage:videoMessage sendSuccess:^(BOOL success, AVIMTypedMessage *typeMessage) {
        
        [self.messages addObject:typeMessage];
        
        [self reloadTableViewWithMessagesArray:self.messages sorollToLastRow:YES];
        
    } callback:^(AVIMConversation *conversation, AVIMTypedMessage *typeMessage) {
        
        [self.messages addObject:typeMessage];
        
        [self reloadTableViewWithMessagesArray:self.messages sorollToLastRow:YES];
    }];
}

////视频保存后的回调
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    
    if (error) {
        NSLog(@"保存视频过程中发生错误，错误信息:%@",error.localizedDescription);
    } else {
        NSLog(@"视频保存成功.");
        //录制完之后自动播放
        NSURL *url = [NSURL fileURLWithPath:videoPath];
//        _player=[AVPlayer playerWithURL:url];
//        AVPlayerLayer *playerLayer=[AVPlayerLayer playerLayerWithPlayer:_player];
//        playerLayer.frame=self.photo.frame;
//        [self.photo.layer addSublayer:playerLayer];
//        [_player play];
        
    }
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
                
                label.width = SCREEN_WIDTH;
                
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
        
    } else if ([detailModel.symbolStr isEqualToString:MESSAGE_VIDEO]){
        
        return detailModel.videoViewCellHeight;
        
    } else {
        
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
