//
//  RiliLIst.m
//  Zipingguo
//
//  Created by miao on 15/10/20.
//  Copyright (c) 2015年 fuyonghua. All rights reserved.
//

#import "RiliLIst.h"
#import "RIlilistCell.h"
#import "XinjianshijianVC.h"
#import "CalendarHomeViewController.h"
#import "RIliShall.h"
#import "RenWuServiceShell.h"
@implementation RiliLIst

+ (instancetype)riliTableView
{
    return [[NSBundle mainBundle]loadNibNamed:@"RiliLIst" owner:nil options:nil].lastObject;
}
-(void)awakeFromNib{
    self.riliTableView.delegate=self;
    self.riliTableView.dataSource=self;
    //    self.riliTableView.backgroundColor=[UIColor clearColor];
    //线
//    [self.riliTableView  setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    //    self.RI.text=[NSString stringWithFormat:@"%ld",(long)dateComponent.day];
    [self.riliTableView scrollRectToVisible:CGRectMake(0, 0, 0, 0) animated:NO];
    if ([_riliTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_riliTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([_riliTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_riliTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    _riliTableView.separatorColor = Fenge_Color;
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectZero];
    _riliTableView.tableFooterView = footerView;
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // self.tableview.footer.hidden = (_shuju.count < 10);
    return _shuju.count;
    
}
-(void)setShuju:(NSMutableArray *)shuju
{
    _shuju=shuju;
    [_riliTableView reloadData];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString*cellIdentifier=@"RIlilistCell";
    RIlilistCell*cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"RIlilistCell" owner:nil options:nil]lastObject];
        
    }
    RIlilistCellVM*vm=[[RIlilistCellVM alloc]init];
    //    vm.shijian=@"今天19:00";
    vm=_shuju[indexPath.row];
    
    //    vm.Name=@"任务名称";
    [cell bind:vm];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
//跳转
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    
    return index;
    
}
#pragma mark — 设置右边的按钮
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return  UITableViewCellEditingStyleDelete;
}
- (NSArray*)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewRowAction *editRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"编辑" handler:^(UITableViewRowAction *action,NSIndexPath *indexPath) {
        RIlilistCellVM*vm=self.shuju[indexPath.row];
        [self.delegate rilibianji:vm];
    }];
    
    editRowAction.backgroundColor = RGBACOLOR(128, 103, 191, 1);
    UITableViewRowAction *delRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction *action,NSIndexPath *indexPath) {
        RIlilistCellVM*vm=self.shuju[indexPath.row];
        if (vm.isrenwu==1) {
            /*
             [RenWuServiceShell shanChuRenWuWithID:vm.ID usingCallback:^(DCServiceContext *context, ResultMode *sm) {
             if (context.isSucceeded==YES) {
             if (sm.status==0) {
             [self.shuju removeObjectAtIndex:indexPath.row];
             [self.riliTableView deleteRowsAtIndexPaths:@[indexPath]withRowAnimation:UITableViewRowAnimationAutomatic];
             //删除任务通知
             [[NSNotificationCenter defaultCenter]postNotificationName:@"delanniu" object:nil];
             
             }
             }
             }];
             */
        }else{
            [RIliShall ShanchubeiwangluWithID:vm.ID usingCallback:^(DCServiceContext *Context, RIliShanchuSM *sm) {
                if (Context.isSucceeded==YES) {
                    if (sm.status==0) {
                        [self.shuju removeObjectAtIndex:indexPath.row];
                        [self.riliTableView reloadData];
                        //删除任务通知
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"delanniu" object:nil];
                        
                        
                        
                    }
                    
                }
                
            }];
            
        }
    }];
    delRowAction.backgroundColor = RGBACOLOR(254, 107, 107, 1);
    
    RIlilistCellVM*vm=self.shuju[indexPath.row];
    if (vm.isrenwu == 0) {
        return @[delRowAction,editRowAction];
    }
    else
        return @[editRowAction];
    
    
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}
- (IBAction)jintianAction:(id)sender {
    [[NSNotificationCenter  defaultCenter]postNotificationName:@"huidaojintian" object:nil];
    [self.delegate huidaojintian];
}
@end
