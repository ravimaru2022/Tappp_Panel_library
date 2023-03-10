
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface
NSMutableDictionary (Sentry)

/**
 * Merges the otherDictionary into the given dictionary by overriding existing keys with the values
 * of the other dictionary.
 */
- (void)mergeEntriesFromDictionary:(NSDictionary *)otherDictionary;

@end

NS_ASSUME_NONNULL_END
