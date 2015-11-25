

#import <Foundation/Foundation.h>

@class SectionHeaderView;
@class Play;


@interface SectionInfo : NSObject 

@property (assign) BOOL open;
@property (strong) Play* play;
@property (strong) SectionHeaderView* headerView;
@property (nonatomic,strong,readonly) NSMutableArray *rowHeights;

- (NSUInteger)countOfRowHeights;
- (id)objectInRowHeightsAtIndex:(NSUInteger)idx;
- (void)insertObject:(id)anObject inRowHeightsAtIndex:(NSUInteger)idx;
- (void)insertRowHeights:(NSArray *)rowHeightArray atIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInRowHeightsAtIndex:(NSUInteger)idx withObject:(id)anObject;
- (void)replaceRowHeightsAtIndexes:(NSIndexSet *)indexes withRowHeights:(NSArray *)rowHeightArray;
- (void)removeObjectFromRowHeightsAtIndex:(NSUInteger)idx;
- (void)removeRowHeightsAtIndexes:(NSIndexSet *)indexes;
@end
