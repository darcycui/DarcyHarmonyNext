import { abilityAccessCtrl, PermissionRequestResult, Permissions, bundleManager, common } from '@kit.AbilityKit';

const TAG: string = '[PermissionUtils] ';
const PERMISSIONS: Array<Permissions> =
  ['ohos.permission.CAMERA', "ohos.permission.READ_IMAGEVIDEO", "ohos.permission.WRITE_IMAGEVIDEO"];
const context = getContext(this) as common.UIAbilityContext;

export default async function grantPermission(): Promise<boolean> {
  try {
    let bundleInfo: bundleManager.BundleInfo =
      await bundleManager.getBundleInfoForSelf(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION);
    let appInfo: bundleManager.ApplicationInfo = bundleInfo.appInfo;
    let tokenId = appInfo.accessTokenId;
    let atManager = abilityAccessCtrl.createAtManager();
    let pems: Array<Permissions> = [];
    for (let i = 0; i < PERMISSIONS.length; i++) {
      let state = await atManager.checkAccessToken(tokenId, PERMISSIONS[i]);
      if (state !== abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED) {
        pems.push(PERMISSIONS[i]);
      }
    }
    if (pems.length > 0) {
      let ctx = context
      let result: PermissionRequestResult = await atManager.requestPermissionsFromUser(ctx, pems);
      let grantStatus: Array<number> = result.authResults;
      let length: number = grantStatus.length;
      for (let i = 0; i < length; i++) {
        if (grantStatus[i] !== 0) {
          return false;
        }
      }
    }
    return true;
  } catch (error) {
    return false;
  }
}