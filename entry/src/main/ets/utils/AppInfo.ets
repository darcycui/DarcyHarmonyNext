import BuildProfile from 'BuildProfile';

export class AppInfo {
  buildMode: string = BuildProfile.BUILD_MODE_NAME;

  static isDebug(): boolean {
    return BuildProfile.DEBUG;
  }

  static versionName(): string {
    return BuildProfile.VERSION_NAME;
  }

  static versionCode(): number {
    return BuildProfile.VERSION_CODE;
  }

  static bundleName(): string {
    return BuildProfile.BUNDLE_NAME;
  }
}