#import <Foundation/Foundation.h>

@interface MemoryPatchManager : NSObject
+ (BOOL)writeMemoryAtOffset:(uint64_t)offset withBytes:(NSArray<NSNumber *> *)bytes forLibrary:(NSString *)libraryName;
@end
