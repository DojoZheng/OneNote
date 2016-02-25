//
//  NoteListViewController.m
//  OneNote
//
//  Created by 张恒铭 on 1/31/16.
//  Copyright © 2016 Dongjia Zheng. All rights reserved.
//

#import "NoteListViewController.h"
#import "NoteListCell.h"    
#import "NoteDetailViewController.h"
#import "VNNote.h"
#import "NoteManager.h"

@interface NoteListViewController()
@property(nonatomic,strong) NSMutableArray* dataSource;
@end
@implementation NoteListViewController
+(instancetype)sharedNoteListViewController
{
    static dispatch_once_t pred = 0;
    static NoteListViewController *instance = nil;
    dispatch_once(&pred, ^{
        instance = [[NoteListViewController alloc] initPrivate];
    });
    return instance;
}
-(instancetype)initPrivate
{
    self = [super init];
    return self;
}
-(instancetype)init
{
    @throw [NSException exceptionWithName:@"Singeleton Object" reason:@"User sharedNoteListViewer methor to get instance" userInfo:nil] ;
}
-(void)reloadData
{
    _dataSource = [[NoteManager sharedManager] readAllNotes];
    [self.NoteListTableView reloadData];
}
#pragma mark - Datasource delegate
- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [[NoteManager sharedManager] readAllNotes];
    }
    return _dataSource;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VNNote *note = [self.dataSource objectAtIndex:indexPath.row];
    return [NoteListCell heightWithNote:note];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NoteListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListCell"];
    if (!cell) {
        cell = [[NoteListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ListCell"];
    }
    VNNote *note = [self.dataSource objectAtIndex:indexPath.row];
    cell.index = indexPath.row;
    [cell updateWithNote:note];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    VNNote *note = [self.dataSource objectAtIndex:indexPath.row];
    NoteDetailViewController *controller = [[NoteDetailViewController alloc] initWithNote:note];
    controller.hidesBottomBarWhenPushed = YES;
    //[self.navigationController pushViewController:controller animated:YES];
    [self.delegate jumpToDetailPage:controller];
}

#pragma mark - EditMode

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        VNNote *note = [self.dataSource objectAtIndex:indexPath.row];
        [[NoteManager sharedManager] deleteNote:note];
        
        [self.dataSource removeObjectAtIndex:indexPath.row];
        [self.NoteListTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.delegate deleteRows:[NSArray arrayWithObject:indexPath]];
    }
}


@end
