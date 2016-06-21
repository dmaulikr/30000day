//
//  XHMessageTableViewCell.m
//  MessageDisplayExample
//
//  Created by qtone-1 on 14-4-24.
//  Copyright (c) 2014年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507 本人QQ群（142557668）. All rights reserved.
//

#import "XHMessageTableViewCell.h"
#import "XHMessageStatusView.h"
#import "UIImageView+WebCache.h"
static const CGFloat kXHLabelPadding = 5.0f;
static const CGFloat kXHTimeStampLabelHeight = 20.0f;

static const CGFloat kXHAvatorPaddingX = 8.0;
static const CGFloat kXHAvatorPaddingY = 15;

static const CGFloat kXHBubbleMessageViewPadding = 8;


@interface XHMessageTableViewCell () {
    
}

@property (nonatomic, weak, readwrite) XHMessageBubbleView *messageBubbleView;

@property (nonatomic, weak, readwrite) UIButton *avatorButton;

@property (nonatomic, weak, readwrite) UILabel *userNameLabel;

@property (nonatomic, weak, readwrite) XHMessageStatusView *statusView;

@property (nonatomic, weak, readwrite) LKBadgeView *timestampLabel;

/**
 *  是否显示时间轴Label
 */
@property (nonatomic, assign) BOOL displayTimestamp;

/**
 *  1、是否显示Time Line的label
 *
 *  @param message 需要配置的目标消息Model
 */
- (void)configureTimestampAndnotificationTextLabel:(BOOL)displayTimestamp atMessage:(id <XHMessageModel>)message;

/**
 *  2、配置头像
 *
 *  @param message 需要配置的目标消息Model
 */
- (void)configAvatorWithMessage:(id <XHMessageModel>)message;

/**
 *  3、配置需要显示什么消息内容，比如语音、文字、视频、图片
 *
 *  @param message 需要配置的目标消息Model
 */
- (void)configureMessageBubbleViewWithMessage:(id <XHMessageModel>)message;

/**
 *  头像按钮，点击事件
 *
 *  @param sender 头像按钮对象
 */
- (void)avatorButtonClicked:(UIButton *)sender;

/**
 *  统一一个方法隐藏MenuController，多处需要调用
 */
- (void)setupNormalMenuController;

/**
 *  点击Cell的手势处理方法，用于隐藏MenuController的
 *
 *  @param tapGestureRecognizer 点击手势对象
 */
- (void)tapGestureRecognizerHandle:(UITapGestureRecognizer *)tapGestureRecognizer;

/**
 *  长按Cell的手势处理方法，用于显示MenuController的
 *
 *  @param longPressGestureRecognizer 长按手势对象
 */
- (void)longPressGestureRecognizerHandle:(UILongPressGestureRecognizer *)longPressGestureRecognizer;

/**
 *  单击手势处理方法，用于点击多媒体消息触发方法，比如点击语音需要播放的回调、点击图片需要查看大图的回调
 *
 *  @param tapGestureRecognizer 点击手势对象
 */
- (void)sigleTapGestureRecognizerHandle:(UITapGestureRecognizer *)tapGestureRecognizer;

/**
 *  双击手势处理方法，用于双击文本消息，进行放大文本的回调
 *
 *  @param tapGestureRecognizer 双击手势对象
 */
- (void)doubleTapGestureRecognizerHandle:(UITapGestureRecognizer *)tapGestureRecognizer;

@end

@implementation XHMessageTableViewCell

- (void)avatorButtonClicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(didSelectedAvatorOnMessage:atIndexPath:)]) {
        [self.delegate didSelectedAvatorOnMessage:self.messageBubbleView.message atIndexPath:self.indexPath];
    }
}

-(void)retryButtonClicked:(UIButton*)sender{
    if([_delegate respondsToSelector:@selector(didRetrySendMessage:atIndexPath:)]){
        [_delegate didRetrySendMessage:self.messageBubbleView.message atIndexPath:self.indexPath];
    }
}

#pragma mark - Copying Method

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (BOOL)becomeFirstResponder {
    return [super becomeFirstResponder];
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    return (action == @selector(copied:) || action == @selector(transpond:) || action == @selector(favorites:) || action == @selector(more:));
}

#pragma mark - Menu Actions

- (void)copied:(id)sender {
    switch (self.messageBubbleView.message.messageMediaType) {
        case XHBubbleMessageMediaTypeText:
            [[UIPasteboard generalPasteboard] setString:self.messageBubbleView.displayTextView.text];
            break;
        case XHBubbleMessageMediaTypePhoto:
            [[UIPasteboard generalPasteboard] setImage:self.messageBubbleView.bubblePhotoImageView.messagePhoto];
            break;
        case XHBubbleMessageMediaTypeLocalPosition:
            [[UIPasteboard generalPasteboard] setString:self.messageBubbleView.geolocationsLabel.text];
            break;
        case XHBubbleMessageMediaTypeEmotion:
        case XHBubbleMessageMediaTypeVideo:
        case XHBubbleMessageMediaTypeVoice:
        case XHBubbleMessageMediaTypeNotification:
            break;
    }
    [self resignFirstResponder];
    DLog(@"Cell was copy");
}

- (void)transpond:(id)sender {
    DLog(@"Cell was transpond");
}

- (void)favorites:(id)sender {
    DLog(@"Cell was favorites");
}

- (void)more:(id)sender {
    DLog(@"Cell was more");
}

#pragma mark - Setters

- (void)configureCellWithMessage:(id <XHMessageModel>)message
               displaysTimestamp:(BOOL)displayTimestamp {
    // 1、判断timestampLabel和notificationTextLabel到底谁显示
    [self configureTimestampAndnotificationTextLabel:displayTimestamp atMessage:message];
    
    // 2、配置头像
    [self configAvatorWithMessage:message];
    
    // 3、配置用户名
    [self configUserNameWithMessage:message];
    
    // 4、配置需要显示什么消息内容，比如语音、文字、视频、图片
    [self configureMessageBubbleViewWithMessage:message];
    
    [self configStatusViewWithMessage:message];
}

- (void)configureTimestampAndnotificationTextLabel:(BOOL)displayTimestamp atMessage:(id <XHMessageModel>)message {
    
    if (message.messageMediaType == XHBubbleMessageMediaTypeNotification) {//XHBubbleMessageMediaTypeNotification类型的消息和timestampLabel控件重合的
        
        self.timestampLabel.hidden = YES;
        
        self.notificationTextView.hidden = NO;

        self.messageBubbleView.hidden = YES;
        
        self.avatorButton.hidden = YES;
        
        self.userNameLabel.hidden = YES;
        
        self.notificationTextView.displayNotificationTextLabel.text = message.text;
        
        if ([Common heightWithText:message.text width:SCREEN_WIDTH - 46 fontSize:13.0f] > 22) {
            
            self.notificationTextView.displayNotificationTextLabel.textAlignment = NSTextAlignmentLeft;
            
            self.notificationTextView.height = [XHMessageDisplayNotificationTextView textViewHeightWithWidth:SCREEN_WIDTH - 46 withFont:[UIFont systemFontOfSize:13.0f]];
            
            self.notificationTextView.center = CGPointMake(CGRectGetWidth([[UIScreen mainScreen] bounds]) / 2.0, self.notificationTextView.height / 2 + 5.0f);
            
        } else {
            
            self.notificationTextView.displayNotificationTextLabel.textAlignment = NSTextAlignmentCenter;
            
            self.notificationTextView.height = [Common heightWithText:message.text width:SCREEN_WIDTH - 46 fontSize:13.0f];
            
            self.notificationTextView.width = [Common widthWithText:message.text height:[Common heightWithText:message.text width:SCREEN_WIDTH - 46 fontSize:13.0f] fontSize:13.0f];
            
            self.notificationTextView.center = CGPointMake(CGRectGetWidth([[UIScreen mainScreen] bounds]) / 2.0, self.notificationTextView.height / 2 + 5.0f);
        }
        
    } else {

        self.notificationTextView.hidden = YES;
        
        self.messageBubbleView.hidden = NO;
        
        self.avatorButton.hidden = NO;
        
        self.userNameLabel.hidden = NO;
        
        self.displayTimestamp = displayTimestamp;
        
        self.timestampLabel.hidden = !self.displayTimestamp;
        
        if (displayTimestamp) {
            
            self.timestampLabel.text = [NSDateFormatter localizedStringFromDate:message.timestamp
                                                                      dateStyle:NSDateFormatterMediumStyle                                                          timeStyle:NSDateFormatterShortStyle];
        }
    }
}

- (void)configAvatorWithMessage:(id <XHMessageModel>)message {
    
    if (message.avator) {
        
        [self.avatorButton setImage:message.avator forState:UIControlStateNormal];
        
    } else if(message.avatorUrl) {
        
        [self.avatorButton setImage:[UIImage imageNamed:@"placeholder"] forState:UIControlStateNormal];
        
        [self.avatorButton.imageView sd_setImageWithPreviousCachedImageWithURL:[NSURL URLWithString:message.avatorUrl] placeholderImage:[UIImage imageNamed:@"placeholder"] options:SDWebImageContinueInBackground progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
            //下载进度
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
           
            [self.avatorButton setImage:image forState:UIControlStateNormal];
        }];
        
    } else {
        
        [self.avatorButton setImage:[XHMessageAvatorFactory avatarImageNamed:[UIImage imageNamed:@"placeholder"] messageAvatorType:XHMessageAvatorTypeSquare] forState:UIControlStateNormal];
    }
}

- (void)configUserNameWithMessage:(id <XHMessageModel>)message {
    
    self.userNameLabel.text = [message sender];
}

- (void)configureMessageBubbleViewWithMessage:(id <XHMessageModel>)message {
    
    XHBubbleMessageMediaType currentMediaType = message.messageMediaType;
    
    for (UIGestureRecognizer *gesTureRecognizer in self.messageBubbleView.bubbleImageView.gestureRecognizers) {
        
        [self.messageBubbleView.bubbleImageView removeGestureRecognizer:gesTureRecognizer];
        
    }
    
    for (UIGestureRecognizer *gesTureRecognizer in self.messageBubbleView.bubblePhotoImageView.gestureRecognizers) {
        
        [self.messageBubbleView.bubblePhotoImageView removeGestureRecognizer:gesTureRecognizer];
    }
    
    switch (currentMediaType) {
            
        case XHBubbleMessageMediaTypePhoto:
            
        case XHBubbleMessageMediaTypeVideo:
            
        case XHBubbleMessageMediaTypeLocalPosition: {
            
            UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sigleTapGestureRecognizerHandle:)];
            
            [self.messageBubbleView.bubblePhotoImageView addGestureRecognizer:tapGestureRecognizer];
            
            break;
        }
            
        case XHBubbleMessageMediaTypeText:
            
        case XHBubbleMessageMediaTypeVoice:
            
        case XHBubbleMessageMediaTypeEmotion: {
            
            UITapGestureRecognizer *tapGestureRecognizer;
            
            if (currentMediaType == XHBubbleMessageMediaTypeText) {
                
                tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapGestureRecognizerHandle:)];
                
            } else {
                
                tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sigleTapGestureRecognizerHandle:)];
            }
            
            tapGestureRecognizer.numberOfTapsRequired = (currentMediaType == XHBubbleMessageMediaTypeText ? 2 : 1);
            
            [self.messageBubbleView.bubbleImageView addGestureRecognizer:tapGestureRecognizer];
            
            break;
        }
        default:
            break;
    }
    
    [self.messageBubbleView configureCellWithMessage:message];
}

- (void)configStatusViewWithMessage:(id <XHMessageModel>)message {
    //NSString* str=[NSString stringWithFormat:@"%d",[message status]];
    [_statusView setStatus:[message status]];
}

#pragma mark - Gestures

- (void)setupNormalMenuController {
    UIMenuController *menu = [UIMenuController sharedMenuController];
    if (menu.isMenuVisible) {
        [menu setMenuVisible:NO animated:YES];
    }
}

- (void)tapGestureRecognizerHandle:(UITapGestureRecognizer *)tapGestureRecognizer {
    [self updateMenuControllerVisiable];
}

- (void)updateMenuControllerVisiable {
    [self setupNormalMenuController];
}

- (void)longPressGestureRecognizerHandle:(UILongPressGestureRecognizer *)longPressGestureRecognizer {
    if (longPressGestureRecognizer.state != UIGestureRecognizerStateBegan || ![self becomeFirstResponder])
        return;
    
    UIMenuItem *copy = [[UIMenuItem alloc] initWithTitle:NSLocalizedStringFromTable(@"copy", @"MessageDisplayKitString", @"复制文本消息") action:@selector(copied:)];
//    UIMenuItem *transpond = [[UIMenuItem alloc] initWithTitle:NSLocalizedStringFromTable(@"transpond", @"MessageDisplayKitString", @"转发") action:@selector(transpond:)];
//    UIMenuItem *favorites = [[UIMenuItem alloc] initWithTitle:NSLocalizedStringFromTable(@"favorites", @"MessageDisplayKitString", @"收藏") action:@selector(favorites:)];
//    UIMenuItem *more = [[UIMenuItem alloc] initWithTitle:NSLocalizedStringFromTable(@"more", @"MessageDisplayKitString", @"更多") action:@selector(more:)];
    
    UIMenuController *menu = [UIMenuController sharedMenuController];
    
    switch (self.messageBubbleView.message.messageMediaType) {
            
        case XHBubbleMessageMediaTypeText:
            
            [menu setMenuItems:[NSArray arrayWithObjects:copy,nil]];
            
            break;
            
        case XHBubbleMessageMediaTypePhoto:
            
        case XHBubbleMessageMediaTypeLocalPosition:
            
        case XHBubbleMessageMediaTypeEmotion:
            
        case XHBubbleMessageMediaTypeVideo:
            
        case XHBubbleMessageMediaTypeVoice:
            
        case XHBubbleMessageMediaTypeNotification:
            
//            [menu setMenuItems:[NSArray arrayWithObjects:transpond, favorites, more, nil]];
            break;
    }
    
    CGRect targetRect = [self convertRect:[self.messageBubbleView bubbleFrame]
                                 fromView:self.messageBubbleView];
    
    [menu setTargetRect:CGRectInset(targetRect, 0.0f, 4.0f) inView:self];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleMenuWillShowNotification:)
                                                 name:UIMenuControllerWillShowMenuNotification
                                               object:nil];
    [menu setMenuVisible:YES animated:YES];
}

- (void)sigleTapGestureRecognizerHandle:(UITapGestureRecognizer *)tapGestureRecognizer {
    
    if (tapGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        
        [self setupNormalMenuController];
        
        if ([self.delegate respondsToSelector:@selector(multiMediaMessageDidSelectedOnMessage:atIndexPath:onMessageTableViewCell:)]) {
            
            [self.delegate multiMediaMessageDidSelectedOnMessage:self.messageBubbleView.message atIndexPath:self.indexPath onMessageTableViewCell:self];
            
        }
    }
}

- (void)doubleTapGestureRecognizerHandle:(UITapGestureRecognizer *)tapGestureRecognizer {
    
    if (tapGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        
        if ([self.delegate respondsToSelector:@selector(didDoubleSelectedOnTextMessage:atIndexPath:)]) {
            
            [self.delegate didDoubleSelectedOnTextMessage:self.messageBubbleView.message atIndexPath:self.indexPath];
            
        }
    }
}

#pragma mark - Notifications

- (void)handleMenuWillHideNotification:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIMenuControllerWillHideMenuNotification
                                                  object:nil];
}

- (void)handleMenuWillShowNotification:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIMenuControllerWillShowMenuNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleMenuWillHideNotification:)
                                                 name:UIMenuControllerWillHideMenuNotification
                                               object:nil];
}

#pragma mark - Getters

- (XHBubbleMessageType)bubbleMessageType {
    
    return self.messageBubbleView.message.bubbleMessageType;
}

+ (CGFloat)calculateCellHeightWithMessage:(id <XHMessageModel>)message
                        displaysTimestamp:(BOOL)displayTimestamp {
    
    if (message.messageMediaType == XHBubbleMessageMediaTypeNotification) {
        
        return kXHLabelPadding * 2 + kXHTimeStampLabelHeight + [XHMessageDisplayNotificationTextView textViewHeightWithWidth:[UIScreen mainScreen].bounds.size.width - 46 withFont:[UIFont systemFontOfSize:13.0f]];

    } else {
        
        CGFloat timestampHeight = displayTimestamp ? (kXHTimeStampLabelHeight + kXHLabelPadding * 2) : kXHLabelPadding;
        
        CGFloat avatarHeight = kXHAvatarImageSize;
        
        CGFloat userNameHeight = 20;
        
        CGFloat subviewHeights = timestampHeight + kXHBubbleMessageViewPadding * 2 + userNameHeight;
        
        CGFloat bubbleHeight = [XHMessageBubbleView calculateCellHeightWithMessage:message];
        
        return subviewHeights + MAX(avatarHeight, bubbleHeight);
    }
}

#pragma mark - Life cycle

- (void)setup {
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.accessoryType = UITableViewCellAccessoryNone;
    self.accessoryView = nil;
    
    UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureRecognizerHandle:)];
    [recognizer setMinimumPressDuration:0.4f];
    [self addGestureRecognizer:recognizer];
    
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizerHandle:)];
    [self addGestureRecognizer:tapGestureRecognizer];
}

- (instancetype)initWithMessage:(id <XHMessageModel>)message
              displaysTimestamp:(BOOL)displayTimestamp
                reuseIdentifier:(NSString *)cellIdentifier {
    
    self = [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    
    if (self) {
        // 如果初始化成功，那就根据Message类型进行初始化控件，比如配置头像，配置发送和接收的样式
        
        // 1、是否显示Time Line的label
        if (!_timestampLabel) {
            
            LKBadgeView *timestampLabel = [[LKBadgeView alloc] initWithFrame:CGRectMake(0, kXHLabelPadding, [UIScreen mainScreen].bounds.size.width, kXHTimeStampLabelHeight)];
            
            timestampLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
            
            timestampLabel.badgeColor = RGBACOLOR(200, 200, 200, 1);
            
            timestampLabel.textColor = [UIColor whiteColor];
            
            timestampLabel.font = [UIFont systemFontOfSize:13.0f];
            
            timestampLabel.center = CGPointMake(CGRectGetWidth([[UIScreen mainScreen] bounds]) / 2.0, timestampLabel.center.y);
            
            [self.contentView addSubview:timestampLabel];
            
            [self.contentView bringSubviewToFront:timestampLabel];
            
            _timestampLabel = timestampLabel;
        }
        
        if (!_notificationTextView) {//显示通知类型消息控件
            
            XHMessageDisplayNotificationTextView *notificationTextView = [[XHMessageDisplayNotificationTextView alloc] initWithFrame:CGRectMake(23, kXHLabelPadding, [UIScreen mainScreen].bounds.size.width - 46, kXHTimeStampLabelHeight)];
      
            notificationTextView.backgroundColor = RGBACOLOR(200, 200, 200, 1);
            
            notificationTextView.displayNotificationTextLabel.lineBreakMode = NSLineBreakByCharWrapping;
            
            notificationTextView.displayNotificationTextLabel.numberOfLines = 0;
            
            notificationTextView.layer.cornerRadius = 5;
            
            notificationTextView.layer.masksToBounds = YES;
            
            [self.contentView addSubview:notificationTextView];
            
            [self.contentView sendSubviewToBack:notificationTextView];
            
            _notificationTextView = notificationTextView;
        }
        
        // 2、配置头像
        if (!self.avatorButton) {
            
            CGRect avatorButtonFrame;
            
            switch (message.bubbleMessageType) {
                    
                case XHBubbleMessageTypeReceiving:
                    
                    avatorButtonFrame = CGRectMake(kXHAvatorPaddingX, kXHAvatorPaddingY + (self.displayTimestamp ? kXHTimeStampLabelHeight : 0), kXHAvatarImageSize, kXHAvatarImageSize);
                    
                    break;
                    
                case XHBubbleMessageTypeSending:
                    
                    avatorButtonFrame = CGRectMake(CGRectGetWidth(self.bounds) - kXHAvatarImageSize - kXHAvatorPaddingX, kXHAvatorPaddingY + (self.displayTimestamp ? kXHTimeStampLabelHeight : 0), kXHAvatarImageSize, kXHAvatarImageSize);
                    
                    break;
                    
                default:
                    
                    break;
            }
            
            UIButton *avatorButton = [[UIButton alloc] initWithFrame:avatorButtonFrame];
            
            [avatorButton setImage:[XHMessageAvatorFactory avatarImageNamed:[UIImage imageNamed:@"avator"] messageAvatorType:XHMessageAvatorTypeCircle] forState:UIControlStateNormal];
            
            [avatorButton addTarget:self action:@selector(avatorButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            avatorButton.layer.cornerRadius = 3;
            
            avatorButton.layer.masksToBounds = YES;
            
            avatorButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
            
            avatorButton.imageView.backgroundColor = [UIColor blackColor];
            
            [self.contentView addSubview:avatorButton];
            
            self.avatorButton = avatorButton;
        }
        
        // 3、配置用户名
        if (!self.userNameLabel) {
            
            UILabel *userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.avatorButton.bounds) + 15, 20)];
            userNameLabel.textAlignment = NSTextAlignmentCenter;
            
            userNameLabel.backgroundColor = [UIColor clearColor];
            
            userNameLabel.font = [UIFont systemFontOfSize:12];
            
            userNameLabel.textColor = LOWBLUECOLOR;
            
            [self.contentView addSubview:userNameLabel];
            
            self.userNameLabel = userNameLabel;
        }
        
        // 4、配置需要显示什么消息内容，比如语音、文字、视频、图片
        if (!_messageBubbleView) {
            
            CGFloat bubbleX = 0.0f;
            
            CGFloat offsetX = 0.0f;
            
            if (message.bubbleMessageType == XHBubbleMessageTypeReceiving)
                
                bubbleX = kXHAvatarImageSize + kXHAvatorPaddingX + kXHAvatorPaddingX;
            
            else
                
                offsetX = kXHAvatarImageSize + kXHAvatorPaddingX + kXHAvatorPaddingX;
            
            CGRect frame = CGRectMake(bubbleX,
                                      kXHBubbleMessageViewPadding + (self.displayTimestamp ? (kXHTimeStampLabelHeight + kXHLabelPadding) : kXHLabelPadding),
                                      self.contentView.frame.size.width - bubbleX - offsetX,
                                      self.contentView.frame.size.height - (kXHBubbleMessageViewPadding + (self.displayTimestamp ? (kXHTimeStampLabelHeight + kXHLabelPadding) : kXHLabelPadding)));
            
            // bubble container
            XHMessageBubbleView *messageBubbleView = [[XHMessageBubbleView alloc] initWithFrame:frame message:message];
            
            messageBubbleView.autoresizingMask = (UIViewAutoresizingFlexibleWidth
                                                  | UIViewAutoresizingFlexibleHeight
                                                  | UIViewAutoresizingFlexibleBottomMargin);
            
            [self.contentView addSubview:messageBubbleView];
            
            [self.contentView sendSubviewToBack:messageBubbleView];
            
            self.messageBubbleView = messageBubbleView;
        }
        
//        if(!self.statusView) {
//            
//            CGRect statusViewFrame = CGRectMake(0, 0, kXHStatusViewWidth, kXHStatusViewHeight);
//            
//            XHMessageStatusView *statusView = [[XHMessageStatusView alloc] initWithFrame:statusViewFrame];
//
//            //attributedLabel.backgroundColor=[UIColor redColor];
//            
//            [self.contentView addSubview:statusView];
//            
//            [self.contentView bringSubviewToFront:statusView];
//            
//            [statusView.retryButton addTarget:self action:@selector(retryButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//            
//            self.statusView = statusView;
//        }
    }
    
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
    [self setup];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGFloat layoutOriginY = kXHAvatorPaddingY + (self.displayTimestamp ? kXHTimeStampLabelHeight : 0);
    
    CGRect avatorButtonFrame = self.avatorButton.frame;
    
    avatorButtonFrame.origin.y = layoutOriginY;
    
    avatorButtonFrame.origin.x = ([self bubbleMessageType] == XHBubbleMessageTypeReceiving) ? kXHAvatorPaddingX : ((CGRectGetWidth(self.bounds) - kXHAvatorPaddingX - kXHAvatarImageSize));
    
    layoutOriginY = kXHBubbleMessageViewPadding + (self.displayTimestamp ? kXHTimeStampLabelHeight : 0);
    
    CGRect bubbleMessageViewFrame = self.messageBubbleView.frame;
    
    bubbleMessageViewFrame.origin.y = layoutOriginY;
    
    CGFloat bubbleX = 0.0f;
    
    if ([self bubbleMessageType] == XHBubbleMessageTypeReceiving)
        
        bubbleX = kXHAvatarImageSize + kXHAvatorPaddingX + kXHAvatorPaddingX;
    
    bubbleMessageViewFrame.origin.x = bubbleX;
    
    self.avatorButton.frame = avatorButtonFrame;
    
    self.userNameLabel.center = CGPointMake(CGRectGetMidX(avatorButtonFrame), CGRectGetMaxY(avatorButtonFrame) + CGRectGetMidY(self.userNameLabel.bounds));
    
    self.messageBubbleView.frame = bubbleMessageViewFrame;
    
    if (self.bubbleMessageType == XHBubbleMessageTypeSending) {
        
        self.statusView.hidden = NO;
        
        CGFloat statusX = CGRectGetMinX(self.messageBubbleView.bubbleFrame) - kXHStatusViewWidth - 3;
        
        CGFloat halfH = self.messageBubbleView.bubbleFrame.size.height/2;
        
        CGRect statusFrame = self.statusView.frame;
        
        statusFrame.origin.y = layoutOriginY + halfH;
        
        if([self.messageBubbleView.message messageMediaType] == XHBubbleMessageMediaTypeVoice && self.messageBubbleView.message.voiceDuration != 0) {
            
            statusX = statusX - 15;
        }
        
        statusFrame.origin.x = statusX;
        
        self.statusView.frame = statusFrame;
        
    } else {
        
        self.statusView.hidden = YES;
    }
}

- (void)dealloc {
    
    _avatorButton = nil;
    
    _timestampLabel = nil;
    
    _messageBubbleView = nil;
    
    _indexPath = nil;
    
    _notificationTextView = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - TableViewCell

- (void)prepareForReuse {
    // 这里做清除工作
    [super prepareForReuse];
    self.messageBubbleView.animationVoiceImageView.image = nil;
    self.messageBubbleView.displayTextView.text = nil;
    self.messageBubbleView.displayTextView.attributedText = nil;
    self.messageBubbleView.bubblePhotoImageView.messagePhoto = nil;
    self.messageBubbleView.emotionImageView.animatedImage = nil;
    self.timestampLabel.text = nil;
    self.notificationTextView.displayNotificationTextLabel.text = nil;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
