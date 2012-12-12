#import "AFIncrementalStore.h"
#import "AFRestClient.h"

@interface AFHeroTestAPIClient : AFRESTClient <AFIncrementalStoreHTTPClient>

+ (AFHeroTestAPIClient *)sharedClient;

@end
