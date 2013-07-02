//
//  WaterFlowView.m
//  BanBu
//
//  Created by apple on 12-12-11.
//
//

#import "WaterFlowView.h"
#define TABLEVIEWTAG 1000
#define CELLSUBVIEWTAG 10000

@implementation WaterFlowView

@synthesize cloumn = _cloumn,cellTotal=_cellTotal,cellWidth=_cellWidth;
@synthesize  delegatee=_delegatee,datasouce=_datasouce;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //此处更改瀑布流的背景色
        self.backgroundColor=[UIColor clearColor];
        
        
         self.contentSize = CGSizeMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)+1);
        
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(void)dealloc{
    
    self.delegatee=nil;
    
    self.datasouce=nil;
    
    [_tableViews release];
    
    
    [super dealloc];
}

// 对 自定义的view 进行排版

-(void)relayoutDisplaySubviews
{
    // 有几列
    self.cloumn=[_datasouce numberOfColumsInWaterFlowView:self];

    // 一共有多少个cell
    self.cellTotal=[_datasouce numberOfAllWaterFlowView:self];
    
     if(self.cloumn==0||_cellTotal==0)
     {
         return;
     
     }
    self.cellWidth=CGRectGetWidth(self.frame)/self.cloumn;
    
    if(!_tableViews)
    {
        _tableViews=[[NSMutableArray alloc]initWithCapacity:_cloumn];
    
       // 创建 _cloumn 个tableview
        
        for(int i=0;i<_cloumn;i++)
        {
            UITableView *tableview=[[UITableView alloc]initWithFrame:CGRectMake(_cellWidth*i, 0, _cellWidth, CGRectGetHeight(self.frame)) style:UITableViewStylePlain];
            
             // 设置代理
            
            tableview.delegate=self;
            
            tableview.dataSource=self;
            
//            tableview.userInteractionEnabled=NO;
            
            tableview.showsVerticalScrollIndicator = NO;
            
            tableview.scrollEnabled = NO;
            
            tableview.tag=i+TABLEVIEWTAG;
            
            tableview.separatorStyle = UITableViewCellSeparatorStyleNone;

            tableview.backgroundColor = [UIColor clearColor];
            
            [self addSubview:tableview];
        
            [tableview release];
            
            [_tableViews addObject:tableview];
            
            
        }
    
    }
    
    
}


// void 重排 layoutSubviews

-(void)layoutSubviews
{
    [self relayoutDisplaySubviews];
    
     for(UITableView *tableview in _tableViews)
     {
        [tableview setFrame:CGRectMake(tableview.frame.origin.x, self.contentOffset.y, CGRectGetWidth(tableview.frame), CGRectGetHeight(tableview.frame))];
     
        

         [tableview setContentOffset:self.contentOffset animated:NO];
         
        
         
     }
    
    

     [super layoutSubviews];
}

// 设置datasouce 和delegate

-(void)setDatasouce:(id<WaterFlowViewDataSource>)datasouce
{
    _datasouce=datasouce;

}

-(void)setDelegatee:(id<WaterFlowViewDelegate>)delegatee
{
    _delegatee=delegatee;

}

// 重新刷新数据 刷新这而的view 从而刷新 子视图tableviews的数据

-(void)reloadData
{
  [self relayoutDisplaySubviews];    
    float contentSizeHeight=0.0f;
    
    for(UITableView *tableview in _tableViews)
    {
        [tableview reloadData];
        
        if (contentSizeHeight < tableview.contentSize.height) {
            
            contentSizeHeight = tableview.contentSize.height;
        
               
        }
    
             
        
    }
        
    
    contentSizeHeight = contentSizeHeight < CGRectGetHeight(self.frame)?CGRectGetHeight(self.frame)+1:contentSizeHeight;

    
    // self.cont
    
    
    self.contentSize = CGSizeMake(self.contentSize.width, contentSizeHeight+8);
 
       
        
        
            

}


// 每个column 有多少个row 即有多少个view
-(NSInteger)waterFlowView:(WaterFlowView *)waterFlowView numberOfRowsInColumn:(NSInteger)colunm
{
  if(waterFlowView.cellTotal -(colunm + 1) < 0)
  {
  
      return 0;
      
  }else
  {
  
   return (waterFlowView.cellTotal -(colunm + 1))/waterFlowView.cloumn+1;
  }

}

// tableview 的代理函数生成 tableview

// 有几个row
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [self waterFlowView:self numberOfRowsInColumn:tableView.tag - TABLEVIEWTAG];

}

// 每个row 
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    IndexPath *_indextPath =[IndexPath initWithRow:indexPath.row WithCloumn:tableView.tag - TABLEVIEWTAG];
    CGFloat cellHeight = [self.delegatee waterFlowView:self heightForRowAtIndexPath:_indextPath];
   
    return cellHeight;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    //三个 tableveiw 的cell 的不同 标志
    UITableViewCell *cell = nil;
    NSString *cellIndetify = [NSString stringWithFormat:@"cell%d",tableView.tag -TABLEVIEWTAG];
    cell = [tableView dequeueReusableCellWithIdentifier:cellIndetify];
    
    if(cell==nil)
    {
        cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndetify]autorelease];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
     
        IndexPath *_indextPath =[IndexPath initWithRow:indexPath.row WithCloumn:tableView.tag-TABLEVIEWTAG];
        UIView *cellSub =  [self.datasouce waterFlowView:self cellForRowAtIndexPath:_indextPath];
        [cell.contentView addSubview:cellSub];
//        [cellSub release];
        cellSub.tag = CELLSUBVIEWTAG;

        
    }
   
    IndexPath *_indextPath =[IndexPath initWithRow:indexPath.row WithCloumn:tableView.tag-TABLEVIEWTAG];
    
    
    CGFloat cellHeight = [self.delegatee waterFlowView:self heightForRowAtIndexPath:_indextPath];
    CGRect cellRect = CGRectMake(0, 0, _cellWidth, cellHeight);
    
    
    [[cell viewWithTag:CELLSUBVIEWTAG] setFrame:cellRect];
    
    [self.datasouce waterFlowView:self relayoutCellSubview:[cell viewWithTag:CELLSUBVIEWTAG] withIndexPath:_indextPath];
    
    return cell;

    


}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    IndexPath *index=[IndexPath initWithRow:indexPath.row WithCloumn:tableView.tag-TABLEVIEWTAG];

    [self.delegatee waterFlowView:self didSelectRowAtIndexPath:index];
    
    
}






@end
