import { JSON } from "@kit.ArkTS";

@Builder
export function NavigationBuilder() {
  ObserverV2Page()
}

@Entry
@ComponentV2
struct ObserverV2Page {
  @Local params: Map<string, string> = new Map();
  pathStack:NavPathStack = new NavPathStack();

  build() {
    NavDestination() {
      Column() {
        Text(JSON.stringify(this.params))
          .onClick(() => {
            this.params = new Map();
          }).width('100%')
          .textAlign(TextAlign.Start)
      }
      .height('100%')
      .width('100%')
    }.title('ObserverV2')
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack
      this.params = context.pathInfo.param as Map<string, string>
    })
  }
}