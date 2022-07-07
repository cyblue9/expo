// Copyright 2019 650 Industries. All rights reserved.

#import <EXUpdates/EXUpdatesAppController.h>
#import <EXUpdates/EXUpdatesE2ETestModule.h>
#import <EXUpdates/EXUpdatesFileDownloader.h>

NS_ASSUME_NONNULL_BEGIN

@implementation EXUpdatesE2ETestModule

EX_EXPORT_MODULE(ExpoUpdatesE2ETest);

EX_EXPORT_METHOD_AS(readInternalAssetsFolderAsync,
                    readInternalAssetsFolderAsync:(EXPromiseResolveBlock)resolve
                                           reject:(EXPromiseRejectBlock)reject)
{
  NSURL *assetsFolder = EXUpdatesAppController.sharedInstance.updatesDirectory;
  dispatch_async(EXUpdatesFileDownloader.assetFilesQueue, ^{
    NSError *error;
    NSArray<NSString *> *contents = [NSFileManager.defaultManager contentsOfDirectoryAtPath:assetsFolder.path error:&error];
    if (error) {
      reject(@"ERR_UPDATES_E2E_READ", error.localizedDescription, error);
      return;
    }
    resolve(@(contents.count));
  });
}

EX_EXPORT_METHOD_AS(clearInternalAssetsFolderAsync,
                    clearInternalAssetsFolderAsync:(EXPromiseResolveBlock)resolve
                                            reject:(EXPromiseRejectBlock)reject)
{
  NSURL *assetsFolder = EXUpdatesAppController.sharedInstance.updatesDirectory;
  dispatch_async(EXUpdatesFileDownloader.assetFilesQueue, ^{
    NSError *error;
    BOOL success = [NSFileManager.defaultManager removeItemAtPath:assetsFolder.path error:&error];
    if (!success) {
      reject(@"ERR_UPDATES_E2E_CLEAR", error.localizedDescription, error);
      return;
    }
    resolve(nil);
  });
}

@end

NS_ASSUME_NONNULL_END
