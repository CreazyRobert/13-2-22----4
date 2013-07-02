//
//  BanBu_GridCell.m
//  BanBu
//
//  Created by laiguo zheng on 12-7-10.
//  Copyright (c) 2012年 17xy. All rights reserved.
//

#import "BanBu_GridCell.h"

#define TopMarge 4.0
#define SepMarge 4.0
#define TileWidth 75.0


@implementation BanBu_GridCell

@synthesize tile0 = _tile0;
@synthesize tile1 = _tile1;
@synthesize tile2 = _tile2;
@synthesize tile3 = _tile3;

@synthesize delegate = _delegate;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        for(int i=0; i<4; i++)
        {
            BanBu_Tile *tile = [[BanBu_Tile alloc] initWithFrame:CGRectMake(SepMarge+(SepMarge+TileWidth)*i, TopMarge, TileWidth, TileWidth)];
            tile.tag = i;
            tile.hidden = YES;
            [self.contentView addSubview:tile];
            switch (i) {
                case 0:
                    self.tile0 = tile;
                    break;
                case 1:
                    self.tile1 = tile;
                    break;
                case 2:
                    self.tile2 = tile;
                    break;
                case 3:
                    self.tile3 = tile;
                    break;
                    
                default:
                    break;
            }
            [tile release];
        }
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [self addGestureRecognizer:tap];
        [tap release];
        
    }
    return self;
}

- (void)setImage:(NSString *)imageUrlStr distance:(NSString *)dis sex:(BOOL)sex flag:(BOOL)flag forTile:(NSInteger)index name:(NSString *)name
{
    BanBu_Tile *tile = nil;
 
    switch (index) {
        case 0:
            tile = _tile0;
            break;
        case 1:
            tile = _tile1;
            break;
        case 2:
            tile = _tile2;
            break;
        case 3:
            tile = _tile3;
            break;
            
        default:
            break;
    }
//    _tile0.hidden = YES;
//    _tile1.hidden = YES;
//    _tile2.hidden = YES;
//    _tile3.hidden = YES;
    
    tile.hidden = NO;
    [tile.imageShow setImageWithURL:[NSURL URLWithString:imageUrlStr] placeholderImage:[UIImage imageNamed:@"icon_default.png"] andType:1];
    [tile setSex:sex];
    [tile.headLabel setText:name];
    [tile.titleLabel setText:dis];
 }

- (void)tap:(UITapGestureRecognizer *)tap
{
    CGPoint point = [tap locationInView:self];
    NSInteger row = [(UITableView *)self.superview indexPathForCell:self].row;
    NSInteger index = 0;
    if(CGRectContainsPoint(_tile0.frame, point))
        index = 0;
    else if(CGRectContainsPoint(_tile1.frame, point))
        index = 1;
    else if(CGRectContainsPoint(_tile2.frame, point))
        index = 2;
    else if(CGRectContainsPoint(_tile3.frame, point))
        index = 3;
    
    
    BanBu_Tile *tile = nil;
    switch (index) {
        case 0:
            tile = _tile0;
            break;
        case 1:
            tile = _tile1;
            break;
        case 2:
            tile = _tile2;
            break;
        case 3:
            tile = _tile3;
            break;
            
        default:
            break;
    }
    
    if(!tile.hidden){
        if([_delegate respondsToSelector:@selector(gridCell:didSelectedTile:realRow:)])
            [_delegate gridCell:self didSelectedTile:index realRow:row*4+index];
        
    }
 
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}


- (void)cancelImageLoad{
    [_tile0.imageShow cancelCurrentImageLoad];
    [_tile1.imageShow cancelCurrentImageLoad];
    [_tile2.imageShow cancelCurrentImageLoad];
    [_tile3.imageShow cancelCurrentImageLoad];
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
	[super willMoveToSuperview:newSuperview];
	if(!newSuperview) {
		
        [self cancelImageLoad];
	}
}

- (void)dealloc
{
    [_tile0 release];
    [_tile1 release];
    [_tile2 release];
    [_tile3 release];
    [super dealloc];
}

@end
