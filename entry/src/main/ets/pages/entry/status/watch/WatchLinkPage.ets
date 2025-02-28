@Entry
@Component
struct WatchLinkPage {
  @State shopBasket: PurchaseItem[] = [];

  build() {
    Column() {
      Button('Add to basket')
        .onClick(() => {
          this.shopBasket.push(new PurchaseItem(Math.round(100 * Math.random())))
        })
      // TODO 可以使用$$shopBasket引用状态变量 等同于this.shopBasket
      BasketViewer({ shopBasket: $shopBasket })
      // BasketViewer({ shopBasket: this.shopBasket })
    }
  }
}

class PurchaseItem {
  static NextId: number = 0;
  public id: number;
  public price: number;

  constructor(price: number) {
    this.id = PurchaseItem.NextId++;
    this.price = price;
  }
}

@Component
struct BasketViewer {
  @Link @Watch('onBasketUpdated') shopBasket: PurchaseItem[];
  @State totalPurchase: number = 0;

  getTotal(): number {
    // 累加数组的price属性  reduce函数
    let total = this.shopBasket.reduce((sum, i) => sum + i.price, 0);
    // 超过100欧元可享受折扣
    if (total >= 100) {
      total = 0.9 * total;
    }
    return total;
  }

  // @Watch 回调
  onBasketUpdated(propName: string): void {
    this.totalPurchase = this.getTotal();
  }

  build() {
    Column() {
      ForEach(this.shopBasket,
        (item: PurchaseItem) => {
        // 保留两位小数
          Text(`Price: ${item.price.toFixed(2)} €`)
        },
        (item: PurchaseItem) => item.id.toString()
      )
      Text(`Total: ${this.totalPurchase.toFixed(2)} €`)
    }
  }
}
