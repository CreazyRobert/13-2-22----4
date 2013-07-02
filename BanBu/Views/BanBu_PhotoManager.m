//
//  BanBu_PhotoManager.m
//  BanBu
//
//  Created by jie zheng on 12-7-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BanBu_PhotoManager.h"
#import <QuartzCore/QuartzCore.h>
#import "BanBu_MyProfileViewController.h"
#import "MWPhotoBrowser.h"

#define DefaultHeight 95
#define EditOneRowHeight DefaultHeight+30.0
#define EditTwoRowHeight DefaultHeight*2+20.0

#define TopMarge 10.0
#define sepMarge 4.0
#define imageWith 75.0

@interface BanBu_PhotoManager(Private)

- (void)layoutUI;
CGFloat distance(CGPoint a, CGPoint b);

@end

@implementation BanBu_PhotoManager


@synthesize edit = _edit;
@synthesize myPhotos = _myPhotos;
@synthesize addButton = _addButton;
@synthesize contentViewHeight = _contentViewHeight;
@synthesize showPhotos = _showPhotos;
//
//BOOL isNewPhoto = NO;
//扯。。。。

-(void)sendMessageTochat{

    UIActionSheet *conSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancelNotice", nil) destructiveButtonTitle:nil otherButtonTitles:@"保存到手机",nil];
//    UIActionSheet *conSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancelNotice", nil) destructiveButtonTitle:nil otherButtonTitles:@"保存到手机",NSLocalizedString(@"shareToTX", nil),NSLocalizedString(@"shareToSina", nil),nil];

    conSheet.tag = 101;
    [conSheet showInView:self];
    [conSheet release];
    
}


- (id)initWithPhotos:(NSArray *)photos owner:(id)owner;
{
    self = [super initWithFrame:CGRectMake(0, -300, 320,300)];
    if (self) {
        
        _owner = owner;
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"bgdark_profile" ofType:@"png"];
        UIImageView *bkView = [[UIImageView alloc] initWithFrame:self.bounds];
        bkView.image = [UIImage imageWithContentsOfFile:path];
        [self addSubview:bkView];
        [bkView release];
        
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _contentView = scrollView;
        [self addSubview:scrollView];
        [scrollView release];
        
        _myPhotos = [[NSMutableArray alloc] initWithArray:photos];
        _rows = _myPhotos.count/4;
        
        self.addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addButton setBackgroundImage:[UIImage imageNamed:@"button_addphoto.png"] forState:UIControlStateNormal];
        [_addButton addTarget:self action:@selector(editPhoto:) forControlEvents:UIControlEventTouchUpInside];
        _addButton.layer.cornerRadius = 4.0f;
        _addButton.layer.masksToBounds = YES;
        
        [self layoutUI];
        
    }
    return self;
}

-(void)setMyPhotos:(NSMutableArray *)myPhotos
{
    [_myPhotos removeAllObjects];
    [_myPhotos addObjectsFromArray:myPhotos];
    [self layoutUI];
}

- (void)setEdit:(BOOL)edit
{
    _edit = edit;
    if(_edit)
    {
        self.delPhotoArr = [[[NSMutableArray alloc] initWithCapacity:1] autorelease];
        self.addPhotoArr = [[[NSMutableArray alloc] initWithCapacity:1] autorelease];
        
    }
    [self layoutUI];
}

- (void)layoutUI
{
    
    for(UIView *view in _contentView.subviews)
        [view removeFromSuperview];
    _rows = _myPhotos.count/4;
    
    if(!_edit)
    {
        _contentViewHeight = DefaultHeight;
        _contentView.frame = CGRectMake(0, self.bounds.size.height-DefaultHeight, 320, DefaultHeight);
        _contentView.contentSize = CGSizeMake(320+(sepMarge+imageWith)*(_rows?_myPhotos.count-4:0), _contentView.frame.size.height);
        if(_myPhotos.count)
        {
            for(int i=0; i<_myPhotos.count; i++)
            {
                UIButton *photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
                photoButton.tag = i;
                
                photoButton.frame = CGRectMake(sepMarge+(sepMarge+imageWith)*i, TopMarge, imageWith, imageWith);
                NSDictionary *photo = [_myPhotos objectAtIndex:i];
                NSString *photoUrl = [photo valueForKey:@"facefile"];
                if(photoUrl)
                {
                    [photoButton setImageWithURL:[NSURL URLWithString:photoUrl] placeholderImage:[UIImage imageNamed:@"icon_default.png"] andType:0];
                }
                else
                {
                    [photoButton setImage:[photo valueForKey:@"image"] forState:UIControlStateNormal];
                }
                [photoButton addTarget:self action:@selector(showPhoto:) forControlEvents:UIControlEventTouchUpInside];
                photoButton.layer.cornerRadius = 4.0f;
                photoButton.layer.masksToBounds = YES;
                [_contentView addSubview:photoButton];
            }
        }
        [self setTipsShow:NO];
        [self removeGestureRecognizer:[self.gestureRecognizers lastObject]];
    }
    else
    {
        //        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        //        [self addGestureRecognizer:pan];
        //        [pan release];     //排序开关
        
        _contentViewHeight = _rows?EditTwoRowHeight:EditOneRowHeight;
        _contentView.frame = CGRectMake(0, self.bounds.size.height-_contentViewHeight, 320, _contentViewHeight);
        _contentView.contentSize = _contentView.bounds.size;
        
        for(int i=0; i<_myPhotos.count; i++)
        {
            UIButton *photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [photoButton setTitle:@"old" forState:UIControlStateNormal];
            photoButton.frame = CGRectMake(sepMarge+(sepMarge+imageWith)*(i%4),TopMarge+(TopMarge+imageWith)*(i/4), imageWith, imageWith);
            NSDictionary *photo = [_myPhotos objectAtIndex:i];
            NSString *photoUrl = [photo valueForKey:@"facefile"];
            NSLog(@"%@",[photo valueForKey:@"faceid"]);//2222222222
            if(photoUrl)
            {
                [photoButton setImageWithURL:[NSURL URLWithString:photoUrl] placeholderImage:[UIImage imageNamed:@"icon_default.png"] andType:0];
            }
            else
            {
                [photoButton setImage:[photo valueForKey:@"image"] forState:UIControlStateNormal];
            }
            
            [photoButton addTarget:self action:@selector(editPhoto:) forControlEvents:UIControlEventTouchUpInside];
            photoButton.tag = i;
            photoButton.layer.cornerRadius = 4.0f;
            photoButton.layer.masksToBounds = YES;
            [_contentView addSubview:photoButton];
        }
        _addButton.tag = _myPhotos.count;
        float x = (_myPhotos.count < 8)?sepMarge+(sepMarge+imageWith)*(_addButton.tag%4):320;
        _addButton.frame = CGRectMake(x,TopMarge+(TopMarge+imageWith)*(_addButton.tag/4), imageWith, imageWith);
        _addButton.tag = _myPhotos.count;
        [_contentView addSubview:_addButton];
        
        [self setTipsShow:YES];
        
        
    }
}

- (void)pan:(UIPanGestureRecognizer *)pan
{
    if(pan.state == UIGestureRecognizerStateBegan)
    {
        CGPoint beginPoint = [pan locationInView:_contentView];
        for(UIButton *button in _contentView.subviews)
        {
            if(button == _addButton)
                continue;
            if(CGRectContainsPoint(button.frame, beginPoint))
            {
                _lockedButton = button;
                [_contentView bringSubviewToFront:_lockedButton];
                break;
            }
        }
    }
    else if(pan.state == UIGestureRecognizerStateEnded)
    {
        NSMutableArray *buttons = [NSMutableArray array];
        
        NSInteger moveTag = _lockedButton.tag;
        float dis = distance(_lockedButton.center, CGPointMake(sepMarge+(sepMarge+imageWith)*(_lockedButton.tag%4)+imageWith/2,TopMarge+(TopMarge+imageWith)*(_lockedButton.tag/4)+imageWith/2));
        for(UIButton *button in _contentView.subviews)
        {
            if([button isKindOfClass:[UIButton class]])
            {
                [buttons addObject:button];
                if(button == _lockedButton)
                    continue;
                float length = distance(button.center, _lockedButton.center);
                if(dis > length)
                {
                    dis = length;
                    moveTag = button.tag;
                }
            }
        }
        if(moveTag == _addButton.tag)
            moveTag = _addButton.tag-1;
        
        if(_lockedButton.tag>moveTag)
        {
            for(UIButton *button in buttons)
            {
                if(button == _lockedButton)
                    continue;
                if(button == _addButton)
                    continue;
                
                if((button.tag > moveTag-1) && button.tag<_lockedButton.tag)
                    button.tag++;
            }
        }
        if(_lockedButton.tag<moveTag)
        {
            for(UIButton *button in buttons)
            {
                if(button == _lockedButton)
                    continue;
                if(button == _addButton)
                    continue;
                
                if((button.tag < moveTag+1) && button.tag>_lockedButton.tag)
                    button.tag--;
            }
        }
        
        _lockedButton.tag = moveTag;
        
        [UIView animateWithDuration:0.5
                         animations:^{
                             for(UIButton *button in buttons)
                             {
                                 if(button.tag == 8)
                                     continue;
                                 button.frame = CGRectMake(sepMarge+(sepMarge+imageWith)*(button.tag%4),TopMarge+(TopMarge+imageWith)*(button.tag/4), imageWith, imageWith);
                             }
                             
                         } completion:^(BOOL finished) {
                             
                             _lockedButton = nil;
                             
                         }];
        
    }
    else
    {
        if(!_lockedButton)
            return;
        CGPoint movePoint = [pan locationInView:_contentView];
        [_lockedButton setCenter:movePoint];
        
    }
}

- (void)setTipsShow:(BOOL)show
{
    if(show)
    {
        UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-35,220, 30)];
        tipsLabel.tag = 111;
        tipsLabel.backgroundColor = [UIColor clearColor];
        tipsLabel.textAlignment = UITextAlignmentRight;
        tipsLabel.textColor = [UIColor whiteColor];
        tipsLabel.font = [UIFont systemFontOfSize:13];
//        tipsLabel.text = @"拖拽照片可以排序，点击可更换";
        
        UIImageView *tipView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 2, 24, 24)];
        tipView.image = [UIImage imageNamed:@"icon_tips.png"];
        [tipsLabel addSubview:tipView];
        [tipView release];
        [self addSubview:tipsLabel];
        [tipsLabel release];
        
        tipsLabel.alpha = 0.0;
        [UIView animateWithDuration:.8f
                         animations:^{
                             tipsLabel.alpha = 1.0;
                         } completion:nil];
    }
    else {
        UILabel *label = (UILabel *)[self viewWithTag:111];
        if(label)
            [label removeFromSuperview];
    }
}

- (void)editPhoto:(UIButton *)button
{
    _lockedButton = button;
    BOOL isAddButton = (button == _addButton)?YES:NO;
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:isAddButton?NSLocalizedString(@"addPhoto", nil):NSLocalizedString(@"changePhoto", nil)
                                                             delegate:self
                                                    cancelButtonTitle:NSLocalizedString(@"cancelNotice", nil)
                                               destructiveButtonTitle:isAddButton?nil:NSLocalizedString(@"deletePhoto", nil)
                                                    otherButtonTitles:NSLocalizedString(@"funLabel1", nil),NSLocalizedString(@"funLabel", nil),nil, nil];
    [actionSheet showFromTabBar:[[[_owner navigationController] tabBarController] tabBar]];
    [actionSheet release];
}


#pragma -
#pragma UIAction delegate method

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(actionSheet.tag == 101){
        if(buttonIndex == actionSheet.cancelButtonIndex){
            return;
        }
        if(buttonIndex == actionSheet.firstOtherButtonIndex){
            NSLog(@"%@",shareImage);
            UIImageWriteToSavedPhotosAlbum(shareImage, nil, nil, nil);
        }
    }
    else{
        if(buttonIndex == actionSheet.cancelButtonIndex)
            return;
        if(buttonIndex == actionSheet.destructiveButtonIndex)
        {
            if(_myPhotos.count == 1)
            {
                UIAlertView *alert = [[UIAlertView alloc]
                                      initWithTitle:NSLocalizedString(@"mustOneImage", nil)
                                      message:nil
                                      delegate:nil
                                      cancelButtonTitle:NSLocalizedString(@"confirmNotice", nil)
                                      otherButtonTitles:nil, nil];
                [alert show];
                [alert release];
                return;
            }
            
            
            for(UIButton *button in _contentView.subviews)
            {
                if(button.tag > _lockedButton.tag)
                    button.tag--;
            }
            
            NSDictionary *photo = [_myPhotos objectAtIndex:_lockedButton.tag];
            //        //NSLog(@"%@",photo);
            NSString *faceid = [photo valueForKey:@"faceid"];
            NSLog(@"%@",_lockedButton.titleLabel.text);
            if(![_delPhotoArr containsObject:faceid]&&[_lockedButton.titleLabel.text isEqualToString:@"old"])
                [_delPhotoArr addObject:faceid];
            else if([_lockedButton.titleLabel.text isEqualToString:@"new"])
            {
                NSLog(@"%d",_lockedButton.tag);
                [_addPhotoArr removeObject:[[_myPhotos objectAtIndex:_lockedButton.tag] valueForKey:@"image"]];
            }
//            else if ([_lockedButton.titleLabel.text isEqualToString:@"replace"])
//            {
//                [_delPhotoArr addObject:faceid];
//                [_addPhotoArr :[_myPhotos objectAtIndex:buttonIndex]];
//            }
            [_myPhotos removeObjectAtIndex:_lockedButton.tag];
            
            [UIView animateWithDuration:0.5
                             animations:^{
                                 self.userInteractionEnabled = NO;
                                 for(UIButton *button in _contentView.subviews)
                                 {
                                     if(button == _lockedButton)
                                         continue;
                                     if(button.tag < _lockedButton.tag)
                                         continue;
                                     button.frame = CGRectMake(sepMarge+(sepMarge+imageWith)*(button.tag%4),TopMarge+(TopMarge+imageWith)*(button.tag/4), imageWith, imageWith);
                                 }
                                 
                                 if(_myPhotos.count == 3)
                                 {
                                     _rows = _myPhotos.count/4;
                                     _contentViewHeight = _rows?EditTwoRowHeight:EditOneRowHeight;
                                     _contentView.frame = CGRectMake(0, self.bounds.size.height-_contentViewHeight, 320, _contentViewHeight);
                                     _contentView.contentSize = _contentView.bounds.size;
                                     UITableView *fatherView = (UITableView *)self.superview;
                                     [fatherView setContentOffset:CGPointMake(0,-_contentViewHeight)];
                                     
                                 }
                                 
                                 CGPoint center = _lockedButton.center;
                                 _lockedButton.frame = CGRectMake(center.x-1, center.y-1, 2, 2);
                                 
                             } completion:^(BOOL finished) {
                                 
                                 if(_myPhotos.count == 3)
                                 {
                                     UITableView *fatherView = (UITableView *)self.superview;
                                     [fatherView setContentInset:UIEdgeInsetsMake(_contentViewHeight, 0, 0, 0)];
                                 }
                                 
                                 [_lockedButton removeFromSuperview];
                                 _lockedButton = nil;
                                 self.userInteractionEnabled = YES;
                             }];
            
        }
        else
        {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            NSLog(@"%d",_lockedButton.tag);
            if(_lockedButton != _addButton)
            {
            NSDictionary *photo = [_myPhotos objectAtIndex:_lockedButton.tag];
            
            //        //NSLog(@"%@",photo);
            NSString *faceid = [photo valueForKey:@"faceid"];
            [_delPhotoArr addObject:faceid];
            }
            picker.delegate = self;
            if(buttonIndex == actionSheet.firstOtherButtonIndex)
            {
                if ([UIImagePickerController isSourceTypeAvailable:
                     UIImagePickerControllerSourceTypePhotoLibrary]) {
                    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                }
            }
            else
            {
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            }
            [picker setAllowsEditing:YES];
            [_owner presentModalViewController:picker animated:YES];
            [picker release];
        }
    }
    
}

#pragma mark  -
- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo {
    
    
    if(_lockedButton != _addButton)
    {
        [_lockedButton setImage:image forState:UIControlStateNormal];
        NSDictionary *photo = [_myPhotos objectAtIndex:_lockedButton.tag];
        NSString *faceid = [photo valueForKey:@"userid"];
//        [_lockedButton setTitle:@"replace" forState:UIControlStateNormal];
        if(![_delPhotoArr containsObject:faceid])
            [_delPhotoArr addObject:faceid];
        NSDictionary *newPhoto = [NSDictionary dictionaryWithObjectsAndKeys:image,@"image", nil];
        [_myPhotos replaceObjectAtIndex:_lockedButton.tag withObject:newPhoto];
        [_addPhotoArr addObject:image];
    }
    else
    {
        UIButton *photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [photoButton setTitle:@"new" forState:UIControlStateNormal];
        [photoButton setImage:image forState:UIControlStateNormal];
        [photoButton addTarget:self action:@selector(editPhoto:) forControlEvents:UIControlEventTouchUpInside];
        photoButton.tag = _addButton.tag;
        photoButton.frame = CGRectMake(sepMarge+(sepMarge+imageWith)*(_addButton.tag%4),TopMarge+(TopMarge+imageWith)*(_addButton.tag/4), imageWith, imageWith);
        photoButton.layer.cornerRadius = 4.0f;
        photoButton.layer.masksToBounds = YES;
        [_contentView addSubview:photoButton];
        
        _addButton.tag ++;
        
        NSDictionary *newPhoto = [NSDictionary dictionaryWithObjectsAndKeys:image,@"image", nil];
        [_myPhotos addObject:newPhoto];
        [_addPhotoArr addObject:image];
        
        
        
        [UIView animateWithDuration:.5f
                         animations:^{
                             
                             if(_addButton.tag < 8)
                                 _addButton.frame = CGRectMake(sepMarge+(sepMarge+imageWith)*(_addButton.tag%4),TopMarge+(TopMarge+imageWith)*(_addButton.tag/4), imageWith, imageWith);
                             else
                                 _addButton.frame = CGRectMake(320,TopMarge+(TopMarge+imageWith), imageWith, imageWith);
                             
                             if(_myPhotos.count == 4)
                             {
                                 _rows = _myPhotos.count/4;
                                 _contentViewHeight = _rows?EditTwoRowHeight:EditOneRowHeight;
                                 _contentView.frame = CGRectMake(0, self.bounds.size.height-_contentViewHeight, 320, _contentViewHeight);
                                 _contentView.contentSize = _contentView.bounds.size;
                                 UITableView *fatherView = (UITableView *)self.superview;
                                 [fatherView setContentOffset:CGPointMake(0,-_contentViewHeight)];
                                 
                             }
                         }
                         completion:^(BOOL finished) {
                             if(_myPhotos.count == 4)
                             {
                                 UITableView *fatherView = (UITableView *)self.superview;
                                 [fatherView setContentInset:UIEdgeInsetsMake(_contentViewHeight, 0, 0, 0)];
                             }
                         }];
    }
    _lockedButton = nil;
    
    [picker dismissModalViewControllerAnimated:NO];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissModalViewControllerAnimated:YES];
    
}

- (void)showPhoto:(UIButton *)button
{
    NSMutableArray *showPhotos = [NSMutableArray array];
//    NSLog(@"%@",_myPhotos);
    for(NSDictionary *photo in _myPhotos)
    {
        [UIImage imageNamed:nil];
        MWPhoto *mwPhoto = [MWPhoto photoWithURL:[NSURL URLWithString:[photo valueForKey:@"facefull"]]];
        [showPhotos addObject:mwPhoto];
    }
//    NSLog(@"%@",[showPhotos objectAtIndex:button.tag] );
    shareImage = [[SDWebImageManager sharedManager] imageWithURL:[NSURL URLWithString:[[_myPhotos objectAtIndex:button.tag] valueForKey:@"facefull"]]];
    self.showPhotos = showPhotos;
    
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
//    browser.displayActionButton = YES;
    [browser setInitialPageIndex:button.tag];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:browser];
    [_owner presentModalViewController:nc animated:YES];
    [nc release];
    
   	[browser release];
    
}

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _showPhotos.count;
}

- (MWPhoto *)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _showPhotos.count)
        return [_showPhotos objectAtIndex:index];
    return nil;
}

- (void)clearEditData
{
    self.delPhotoArr = nil;
    self.addPhotoArr = nil;
}

- (void)dealloc
{
    [_delPhotoArr release];
    [_addPhotoArr release];
    [_myPhotos release];
    [_addButton release];
    [_showPhotos release];
    [super dealloc];
}

CGFloat distance(CGPoint a, CGPoint b) {
	return sqrtf(powf(a.x-b.x, 2) + powf(a.y-b.y, 2));
}

@end
