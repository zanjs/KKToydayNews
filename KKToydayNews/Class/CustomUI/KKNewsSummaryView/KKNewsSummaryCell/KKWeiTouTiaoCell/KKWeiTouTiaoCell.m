//
//  KKWeiTouTiaoCell.m
//  KKToydayNews
//
//  Created by finger on 2017/9/18.
//  Copyright © 2017年 finger. All rights reserved.
//

#import "KKWeiTouTiaoCell.h"
#import "KKWeiTouTiaoHeadView.h"
#import "KKWeiTouTiaoBarView.h"

#define maxImageCount 9 //最大的图片个数
#define perRowImages 3 //每行
#define HeadViewHeight 40
#define vInterval 10 //各个控件的垂直距离
#define BarViewHeight 35
#define space 5.0
#define imageWidthHeight ((([UIScreen mainScreen].bounds.size.width - 2 * kkPaddingNormal) - 2 * space) / perRowImages)
#define descLabelHeight 13

static UIFont *contentTextFont = nil ;

@interface KKWeiTouTiaoCell ()<KKCommonDelegate,KKWeiTouTiaoHeadViewDelegate>
@property(nonatomic,readwrite)UIView *bgView ;
@property(nonatomic)KKWeiTouTiaoHeadView *header ;
@property(nonatomic)KKWeiTouTiaoBarView *barView ;
@property(nonatomic)UILabel *contentTextView;
@property(nonatomic)UILabel *posAndReadCountLabel;
@property(nonatomic)UIButton *moreImageView;
@property(nonatomic)UIImageView *positionView ;

@property(nonatomic)NSMutableArray *imageViewArray ;
@property(nonatomic,weak)KKSummaryContent *item ;

@end

@implementation KKWeiTouTiaoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        self.selectionStyle = UITableViewCellSelectionStyleNone ;
        self.contentView.backgroundColor = KKColor(244, 245, 246, 1.0);
        [self awakeFromNib];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.header];
    [self.bgView addSubview:self.contentTextView];
    [self.bgView addSubview:self.positionView];
    [self.bgView addSubview:self.posAndReadCountLabel];
    [self.bgView addSubview:self.moreImageView];
    [self.bgView addSubview:self.barView];
    
    for(NSInteger i = 0 ; i < maxImageCount ; i++){
        UIImageView *view = [YYAnimatedImageView new];
        view.contentMode = UIViewContentModeScaleAspectFill;
        view.userInteractionEnabled = YES ;
        @weakify(view);
        @weakify(self);
        [view addTapGestureWithBlock:^(UIView *gestureView) {
            @strongify(view);
            @strongify(self);
            if(self.delegate && [self.delegate respondsToSelector:@selector(clickImageWithItem:rect:fromView:image:indexPath:)]){
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.indexPath.row inSection:i];
                [self.delegate clickImageWithItem:self.item rect:view.frame fromView:self.bgView image:view.image indexPath:indexPath];
            }
        }];
        [self.bgView addSubview:view];
        [self.imageViewArray addObject:view];
    }
    
    [self.bgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.contentView);
        make.width.mas_equalTo(self.contentView);
        make.height.mas_equalTo(self.contentView).mas_offset(-space);
    }];
    
    [self.header mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bgView).mas_offset(vInterval);
        make.left.mas_equalTo(self.bgView);
        make.width.mas_equalTo(self.bgView);
        make.height.mas_equalTo(HeadViewHeight);
    }];
    
    [self.contentTextView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.header.mas_bottom).mas_offset(vInterval);
        make.left.mas_equalTo(self.bgView).mas_offset(kkPaddingNormal);
        make.width.mas_equalTo(self.bgView).mas_offset(-2 * kkPaddingNormal);
        make.height.mas_equalTo(1);
    }];
    
    UIImageView *lastView = nil ;
    for(NSInteger i = 0 ; i < maxImageCount ; i++ ){
        NSInteger row = i / perRowImages ;
        UIImageView *imageView = [self.imageViewArray safeObjectAtIndex:i];
        [imageView mas_updateConstraints:^(MASConstraintMaker *make) {
            if(row == 0){
               make.top.mas_equalTo(self.contentTextView.mas_bottom).mas_offset(vInterval);
            }else{
               UIImageView *view = [self.imageViewArray safeObjectAtIndex:(row -1) * 3]; make.top.mas_equalTo(view.mas_bottom).mas_offset(space);
            }
            if(i % 3 == 0){
                make.left.mas_equalTo(self.contentTextView);
            }else{
                make.left.mas_equalTo(lastView.mas_right).mas_offset(space);
            }
            make.width.mas_equalTo(imageWidthHeight);
            make.height.mas_equalTo(imageWidthHeight);
        }];
        lastView = imageView ;
    }
    
    lastView = [self.imageViewArray safeObjectAtIndex:perRowImages-1];
    [self.moreImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(lastView);
    }];
    
    [self.positionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.barView.mas_top).mas_offset(-vInterval);
        make.left.mas_equalTo(self.contentTextView);
        make.width.mas_equalTo(descLabelHeight);
        make.height.mas_equalTo(descLabelHeight);
    }];
    
    [self.posAndReadCountLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.positionView);
        make.left.mas_equalTo(self.positionView.mas_right).mas_offset(3).priority(998);
        make.right.mas_equalTo(self.bgView).mas_offset(-kkPaddingNormal);
    }];
    
    [self.barView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.bgView);
        make.left.mas_equalTo(self.bgView);
        make.width.mas_equalTo(self.bgView);
        make.height.mas_equalTo(BarViewHeight);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark -- 界面刷新

- (void)refreshWithItem:(KKSummaryContent *)item{
    self.item = item ;
    
    [KKWeiTouTiaoCell initAttriTextData:item];
    
    self.header.headUrl = item.user.avatar_url;
    self.header.name = item.user.screen_name;
    self.header.desc = item.user.verified_content;
    self.header.isFollow = [item.user.is_following boolValue];
    
    CGFloat textHeight = item.attriTextData.attriTextHeight;
    self.contentTextView.attributedText = item.attriTextData.attriText ;
    self.contentTextView.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.contentTextView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(textHeight);
    }];
    
    NSInteger imageCount = item.thumb_image_list.count;
    if(!imageCount){
        for(UIImageView *view in self.imageViewArray){
            view.hidden = YES ;
            view.image = nil ;
        }
        self.moreImageView.hidden = YES ;
    }else{
        if(imageCount == 1){
            for(UIImageView *view in self.imageViewArray){
                view.hidden = YES ;
                view.image = nil ;
            }
            KKImageItem *imageItem = item.ugc_cut_image_list.firstObject;
            CGFloat width = [UIScreen mainScreen].bounds.size.width / 2.0 ;
            CGFloat height = width / ([imageItem.width floatValue] / [imageItem.height floatValue]) ;
            
            UIImageView *view = self.imageViewArray.firstObject ;
            view.hidden = NO ;
            [view mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(width);
                make.height.mas_equalTo(height);
            }];

            NSString *url = imageItem.url ;
            if(!url.length){
                url = @"";
            }
            SDImageCache *imageCache = [SDImageCache sharedImageCache];
            @weakify(imageCache);
            [imageCache diskImageExistsWithKey:url completion:^(BOOL isInCache) {
                @strongify(imageCache);
                if(isInCache){
                    [view setImage:[imageCache imageFromCacheForKey:url]];
                }else{
                    [view yy_setImageWithURL:[NSURL URLWithString:url] placeholder:[UIImage imageWithColor:[UIColor grayColor]]];
                }
            }];
            
            self.moreImageView.hidden = YES ;
            
        }else if(imageCount == maxImageCount){
            for(NSInteger i = 0 ; i < imageCount; i++){
                NSString *url = [item.thumb_image_list safeObjectAtIndex:i].url;
                if(!url.length || [url isKindOfClass:[NSNull class]]){
                    url = @"";
                }
                UIImageView *view = [self.imageViewArray safeObjectAtIndex:i];
                view.hidden = NO ;
                [view mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(imageWidthHeight);
                    make.height.mas_equalTo(imageWidthHeight);
                }];
                
                SDImageCache *imageCache = [SDImageCache sharedImageCache];
                @weakify(imageCache);
                [imageCache diskImageExistsWithKey:url completion:^(BOOL isInCache) {
                    @strongify(imageCache);
                    if(isInCache){
                        [view setImage:[imageCache imageFromCacheForKey:url]];
                    }else{
                        [view yy_setImageWithURL:[NSURL URLWithString:url] placeholder:[UIImage imageWithColor:[UIColor grayColor]]];
                    }
                }];
            }
            
            self.moreImageView.hidden = YES ;
            
        }else{
            NSInteger count = MIN(3,imageCount);
            for(NSInteger i = 0 ; i < maxImageCount ; i++){
                if(i < count){
                    NSString *url = [item.thumb_image_list safeObjectAtIndex:i].url;
                    if(!url.length || [url isKindOfClass:[NSNull class]]){
                        url = @"";
                    }
                    UIImageView *view = [self.imageViewArray safeObjectAtIndex:i];
                    view.hidden = NO ;
                    [view mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.width.mas_equalTo(imageWidthHeight);
                        make.height.mas_equalTo(imageWidthHeight);
                    }];
                    
                    SDImageCache *imageCache = [SDImageCache sharedImageCache];
                    @weakify(imageCache);
                    [imageCache diskImageExistsWithKey:url completion:^(BOOL isInCache) {
                        @strongify(imageCache);
                        if(isInCache){
                            [view setImage:[imageCache imageFromCacheForKey:url]];
                        }else{
                            [view yy_setImageWithURL:[NSURL URLWithString:url] placeholder:[UIImage imageWithColor:[UIColor grayColor]]];
                        }
                    }];
                }else{
                    UIImageView *view = [self.imageViewArray safeObjectAtIndex:i];
                    view.hidden = YES ;
                    view.image = nil ;
                }
            }
            
            NSInteger diff = imageCount - 3 ;
            if(diff > 0){
                self.moreImageView.hidden = NO ;
                [self.moreImageView setTitle:[NSString stringWithFormat:@"+%ld",diff] forState:UIControlStateNormal];
                [self.bgView bringSubviewToFront:self.moreImageView];
            }else{
                self.moreImageView.hidden = YES ;
            }
        }
    }
    
    NSString *position = [item.position objectForKey:@"position"];
    NSString *readCount = [[NSNumber numberWithLong:item.read_count.longLongValue]convert];
    if(!position.length){
        [self.positionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(0);
        }];
        [self.posAndReadCountLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.positionView.mas_right).mas_offset(0);
        }];
        [self.posAndReadCountLabel setText:[NSString stringWithFormat:@"%@人阅读",readCount]];
    }else{
        [self.positionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(13);
        }];
        [self.posAndReadCountLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.positionView.mas_right).mas_offset(space);
        }];
        [self.posAndReadCountLabel setText:[NSString stringWithFormat:@"%@   %@人阅读",position,readCount]];
    }
    
    NSString *shareCount = item.forward_info[@"forward_count"];
    self.barView.upVoteCount = [[NSNumber numberWithLong:item.digg_count.longLongValue]convert];
    self.barView.commentCount = [[NSNumber numberWithLong:item.comment_count.longLongValue]convert];
    self.barView.shareCount = [[NSNumber numberWithLong:shareCount.longLongValue]convert]; ;
}

+ (CGFloat)fetchHeightWithItem:(KKSummaryContent *)item{
    
    [KKWeiTouTiaoCell initAttriTextData:item];
    
    NSInteger imageCont = item.thumb_image_list.count;
    if(imageCont == 0){
        return HeadViewHeight + item.attriTextData.attriTextHeight + descLabelHeight + BarViewHeight + 4 * vInterval + space;
    }else if(imageCont == 1){
        KKImageItem *imageItem = item.ugc_cut_image_list.firstObject;
        CGFloat width = [UIScreen mainScreen].bounds.size.width / 2.0 ;
        CGFloat height = width / ([imageItem.width floatValue] / [imageItem.height floatValue]) ;
        return HeadViewHeight + item.attriTextData.attriTextHeight + descLabelHeight + BarViewHeight + space + height + 5 * vInterval;
    }else if(imageCont == maxImageCount){
        return HeadViewHeight + item.attriTextData.attriTextHeight + descLabelHeight + BarViewHeight + 3 * space + 3 * imageWidthHeight + 5 * vInterval;
    }
    return HeadViewHeight + item.attriTextData.attriTextHeight + descLabelHeight + BarViewHeight + space + imageWidthHeight + 5 * vInterval;
}

#pragma mark -- 初始化标题文本

+ (void)initAttriTextData:(KKSummaryContent *)item{
    if(item.attriTextData == nil ){
        if(!contentTextFont){
            contentTextFont = [UIFont systemFontOfSize:(iPhone5)?16:17];
        }
        item.attriTextData = [KKAttriTextData new];
        item.attriTextData.lineSpace = 3 ;
        item.attriTextData.textColor = [UIColor kkColorBlack];
        item.attriTextData.lineBreak = NSLineBreakByCharWrapping;
        item.attriTextData.originalText = item.content;
        item.attriTextData.maxAttriTextWidth = [UIScreen mainScreen].bounds.size.width - 2 * kkPaddingNormal ;
        item.attriTextData.textFont = contentTextFont ;
        if(item.attriTextData.attriTextHeight >= 6 * contentTextFont.lineHeight + 6 * item.attriTextData.lineSpace){
            item.attriTextData.attriTextHeight = 6 * contentTextFont.lineHeight + 6 * item.attriTextData.lineSpace;
        }
    }
}

#pragma mark -- 更多图片按钮点击

- (void)showMoreImage{
    if(self.delegate && [self.delegate respondsToSelector:@selector(showWTTDetailView:)]){
        [self.delegate showWTTDetailView:self.item];
    }
}

#pragma mark -- KKUserBarViewDelegate

- (void)clickButtonWithType:(KKBarButtonType)type{
    
}

#pragma mark -- KKUserHeadViewDelegate

- (void)followBtnClicked{
    
}

- (void)shieldBtnClicked{
    
}

- (void)userHeadClicked{
    if(self.delegate && [self.delegate respondsToSelector:@selector(jumpToUserPage:)]){
        [self.delegate jumpToUserPage:self.item.user.user_id];
    }
}

#pragma mark -- 重置cell中图片的隐藏，index == -1 ，设置全部，否则设置对应索引的图片

- (void)resetImageViewHidden:(BOOL)hidden index:(NSInteger)index{
    NSInteger imageCount = self.item.thumb_image_list.count;
    if(index == -1){
        if(imageCount == 1){
            UIImageView *view = self.imageViewArray.firstObject ;
            view.hidden = hidden ;
        }else if(imageCount == maxImageCount){
            for(NSInteger i = 0 ; i < imageCount; i++){
                UIImageView *view = [self.imageViewArray safeObjectAtIndex:i];
                view.hidden = hidden ;
            }
        }else{
            NSInteger count = MIN(3,imageCount);
            for(NSInteger i = 0 ; i < count ; i++){
                UIImageView *view = [self.imageViewArray safeObjectAtIndex:i];
                view.hidden = hidden ;
                
            }
        }
    }else{
        if(imageCount == 1){
            UIImageView *view = self.imageViewArray.firstObject ;
            view.hidden = hidden ;
        }else if(imageCount == maxImageCount){
            UIImageView *view = [self.imageViewArray safeObjectAtIndex:index] ;
            view.hidden = hidden ;
        }else{
            NSInteger count = MIN(3,imageCount);
            if(index < count){
                UIImageView *view = [self.imageViewArray safeObjectAtIndex:index];
                view.hidden = hidden ;
            }
        }
    }
}

#pragma mark -- 获取对应索引的的CGRect

- (CGRect)fetchImageFrameWithIndex:(NSInteger)index{
    NSInteger imageCount = self.item.thumb_image_list.count;
    UIImageView *view = [self.imageViewArray safeObjectAtIndex:index];
    if(imageCount == 1){
        return view.frame ;
    }else if(imageCount == maxImageCount){
        return view.frame ;
    }else{
        if(index < 3){
            return view.frame ;
        }else{
            UIImageView *view = [self.imageViewArray safeObjectAtIndex:0];
            return view.frame;
        }
    }
    return view.frame ;
}

#pragma mark -- 获取对应索引的的UIImage

- (UIImage *)fetchImageWithIndex:(NSInteger)index{
    UIImageView *view = [self.imageViewArray safeObjectAtIndex:index];
    return view.image ;
}

#pragma mark -- @property

- (UIView *)bgView{
    if(!_bgView){
        _bgView = ({
            UIView *view = [UIView new];
            view.backgroundColor = [UIColor whiteColor];
            view ;
        });
    }
    return _bgView;
}

- (KKWeiTouTiaoHeadView *)header{
    if(!_header){
        _header = ({
            KKWeiTouTiaoHeadView *view = [KKWeiTouTiaoHeadView new];
            view.delegate = self ;
            view ;
        });
    }
    return _header;
}

- (KKWeiTouTiaoBarView *)barView{
    if(!_barView){
        _barView = ({
            KKWeiTouTiaoBarView *view = [KKWeiTouTiaoBarView new];
            view.delegate = self ;
            view.borderType = KKBorderTypeTop;
            view.borderColor = [[UIColor grayColor]colorWithAlphaComponent:0.3];
            view.borderThickness = 0.5 ;
            view;
        });
    }
    return _barView;
}

- (UILabel *)contentTextView{
    if(!_contentTextView){
        _contentTextView = ({
            UILabel *view = [UILabel new];
            view.textColor = [UIColor blackColor];
            view.textAlignment = NSTextAlignmentLeft;
            view.lineBreakMode = NSLineBreakByTruncatingTail;
            view.numberOfLines = 0 ;
            view.font = contentTextFont;
            view ;
        });
    }
    return _contentTextView;
}

- (UIImageView *)positionView{
    if(!_positionView){
        _positionView = ({
            UIImageView *view = [UIImageView new];
            view.image = [UIImage imageNamed:@"pgc_discover_28x28_"];
            view ;
        });
    }
    return _positionView ;
}

- (UILabel *)posAndReadCountLabel{
    if(!_posAndReadCountLabel){
        _posAndReadCountLabel = ({
            UILabel *view = [UILabel new];
            [view setTextColor:[UIColor grayColor]];
            [view setTextAlignment:NSTextAlignmentLeft];
            [view setFont:[UIFont systemFontOfSize:11]];
            view ;
        });
    }
    return _posAndReadCountLabel;
}

- (UIButton *)moreImageView{
    if(!_moreImageView){
        _moreImageView = ({
            UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
            view.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.3];
            [view setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [view.titleLabel setFont:[UIFont systemFontOfSize:15]];
            [view addTarget:self action:@selector(showMoreImage) forControlEvents:UIControlEventTouchUpInside];
            view ;
        });
    }
    return _moreImageView;
}

- (NSMutableArray *)imageViewArray{
    if(!_imageViewArray){
        _imageViewArray = [NSMutableArray new];
    }
    return _imageViewArray;
}

@end
