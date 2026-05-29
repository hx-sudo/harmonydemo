import { Product, getProductList, CartItem } from '../model/Product'
import router from '@ohos.router'

// 初始化 AppStorage 购物车数据
const initCart: CartItem[] = [
  new CartItem(new Product(1, '飞天茅台 53度 500ml', 1499, '', '酱香突出，幽雅细腻，酒体醇厚'), 2),
  new CartItem(new Product(2, '茅台王子酒 53度 500ml', 258, '', '口感柔和，适合日常饮用'), 1),
]
AppStorage.setOrCreate<CartItem[]>('cartItems', initCart)

@Entry
@Component
struct Index {
  @State currentIndex: number = 0
  @State productList: Product[] = getProductList()
  @State searchText: string = ''
  @StorageLink('cartItems') cartItems: CartItem[] = initCart
  @State cartCount: number = 3
  @State totalPrice: number = 1499 * 2 + 258

  // 品牌色
  @State selectedCategory: string = '全部'
  private categories: string[] = ['全部', '飞天', '王子', '迎宾', '其他']
  private brandRed: string = '#8B0000'
  private brandGold: string = '#C49B3F'
  private textPrimary: string = '#1A1A1A'
  private textSecondary: string = '#666666'
  private textHint: string = '#999999'
  private bgColor: string = '#F8F6F3'
  private cardBg: string = '#FFFFFF'
  private dividerColor: string = '#EDE8E2'

  onPageShow(): void {
    this.updateCartInfo()
  }

  filterProducts(): void {
    let list = getProductList()
    if (this.selectedCategory !== '全部') {
      list = list.filter((item: Product) => item.category === this.selectedCategory)
    }
    if (this.searchText) {
      list = list.filter((item: Product) => item.name.includes(this.searchText))
    }
    this.productList = list
  }

  updateCartInfo(): void {
    let count = 0
    let total = 0
    for (const item of this.cartItems) {
      count += item.quantity
      total += item.product.price * item.quantity
    }
    this.cartCount = count
    this.totalPrice = total
  }

  @Builder
  HeaderBuilder(title: string) {
    Column() {
      Text('茅台商城')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .fontColor('#FFFFFF')
    }
    .width('100%')
    .height(56)
    .backgroundColor(this.brandRed)
    .justifyContent(FlexAlign.Center)
    .padding({ left: 16, right: 16 })
  }

  @Builder
  ProductListBuilder() {
    Column() {
      // 顶部标题栏
      this.HeaderBuilder('茅台商城')

      // 搜索栏
      Row() {
        Image($r('app.media.startIcon'))
          .width(16)
          .height(16)
          .margin({ right: 8 })
          .opacity(0.4)

        TextInput({ placeholder: '搜索商品...', text: this.searchText })
          .layoutWeight(1)
          .height(36)
          .backgroundColor('#F0EDE8')
          .borderRadius(18)
          .fontSize(14)
          .placeholderColor(this.textHint)
          .onChange((value: string) => {
            this.searchText = value
            this.filterProducts()
          })
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 12, bottom: 12 })

      // 分类标签
      Row() {
        ForEach(this.categories, (cat: string) => {
          Text(cat === '全部' ? '全部' : cat + '系列')
            .fontSize(13)
            .fontColor(this.selectedCategory === cat ? this.brandRed : this.textSecondary)
            .fontWeight(this.selectedCategory === cat ? FontWeight.Bold : FontWeight.Normal)
            .padding({ left: 12, right: 12, top: 6, bottom: 6 })
            .backgroundColor(this.selectedCategory === cat ? '#FDF6F0' : 'transparent')
            .borderRadius(14)
            .margin({ left: 8 })
            .onClick(() => {
              this.selectedCategory = cat
              this.filterProducts()
            })
        }, (cat: string) => cat)
      }
      .width('100%')
      .padding({ left: 16, right: 16, bottom: 8 })

      // 商品列表
      List({ space: 1 }) {
        ForEach(this.productList, (item: Product) => {
          ListItem() {
            Row() {
              // 商品图片占位
              Column() {
                Text('茅台')
                  .fontSize(14)
                  .fontColor(this.brandRed)
                  .fontWeight(FontWeight.Bold)
              }
              .width(90)
              .height(90)
              .backgroundColor('#FDF6F0')
              .borderRadius(8)
              .justifyContent(FlexAlign.Center)

              // 商品信息
              Column() {
                Text(item.name)
                  .fontSize(15)
                  .fontWeight(FontWeight.Medium)
                  .fontColor(this.textPrimary)
                  .maxLines(1)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })

                Text(item.description)
                  .fontSize(12)
                  .fontColor(this.textHint)
                  .maxLines(1)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
                  .margin({ top: 4 })

                Row() {
                  Text(`¥${item.price}`)
                    .fontSize(17)
                    .fontColor(this.brandRed)
                    .fontWeight(FontWeight.Bold)

                  Text('/瓶')
                    .fontSize(11)
                    .fontColor(this.textHint)
                    .margin({ left: 2 })

                  Blank()

                  Text('查看详情')
                    .fontSize(12)
                    .fontColor(this.brandRed)
                    .padding({ left: 12, right: 12, top: 5, bottom: 5 })
                    .border({ width: 1, color: this.brandRed })
                    .borderRadius(4)
                    .onClick(() => {
                      router.pushUrl({
                        url: 'pages/Detail',
                        params: { productId: item.id }
                      })
                    })
                }
                .width('100%')
                .margin({ top: 8 })
                .alignItems(VerticalAlign.Center)
              }
              .layoutWeight(1)
              .margin({ left: 12 })
              .alignItems(HorizontalAlign.Start)
            }
            .width('100%')
            .padding({ left: 16, right: 16, top: 14, bottom: 14 })
            .backgroundColor(this.cardBg)
          }
        }, (item: Product) => item.id.toString())
      }
      .layoutWeight(1)
      .width('100%')
    }
    .width('100%')
    .height('100%')
    .backgroundColor(this.bgColor)
  }

  @Builder
  CartBuilder() {
    Column() {
      // 顶部标题栏
      this.HeaderBuilder('购物车')

      if (this.cartItems.length > 0) {
        // 购物车列表
        List({ space: 1 }) {
          ForEach(this.cartItems, (item: CartItem, index: number) => {
            ListItem() {
              Row() {
                // 商品信息
                Column() {
                  Text(item.product.name)
                    .fontSize(14)
                    .fontWeight(FontWeight.Medium)
                    .fontColor(this.textPrimary)
                    .maxLines(1)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })

                  Text(`¥${item.product.price}/瓶`)
                    .fontSize(13)
                    .fontColor(this.brandRed)
                    .margin({ top: 6 })
                }
                .layoutWeight(1)
                .alignItems(HorizontalAlign.Start)

                // 数量操作
                Row() {
                  Text('-')
                    .width(28)
                    .height(28)
                    .fontSize(16)
                    .textAlign(TextAlign.Center)
                    .backgroundColor('#F0EDE8')
                    .borderRadius(4)
                    .fontColor(this.textSecondary)
                    .onClick(() => {
                      if (this.cartItems[index].quantity > 1) {
                        this.cartItems[index].quantity--
                      } else {
                        this.cartItems.splice(index, 1)
                      }
                      this.updateCartInfo()
                    })

                  Text(item.quantity.toString())
                    .fontSize(14)
                    .width(36)
                    .textAlign(TextAlign.Center)
                    .fontColor(this.textPrimary)

                  Text('+')
                    .width(28)
                    .height(28)
                    .fontSize(16)
                    .textAlign(TextAlign.Center)
                    .backgroundColor('#F0EDE8')
                    .borderRadius(4)
                    .fontColor(this.textSecondary)
                    .onClick(() => {
                      this.cartItems[index].quantity++
                      this.updateCartInfo()
                    })
                }
              }
              .width('100%')
              .padding({ left: 16, right: 16, top: 14, bottom: 14 })
              .backgroundColor(this.cardBg)
            }
          })
        }
        .layoutWeight(1)
        .width('100%')

        // 底部结算栏
        Column() {
          Row() {
            Column() {
              Text('合计')
                .fontSize(12)
                .fontColor(this.textHint)

              Text(`¥${this.totalPrice}`)
                .fontSize(20)
                .fontColor(this.brandRed)
                .fontWeight(FontWeight.Bold)
            }
            .alignItems(HorizontalAlign.Start)

            Blank()

            Text('去结算')
              .fontSize(15)
              .fontColor('#FFFFFF')
              .fontWeight(FontWeight.Medium)
              .padding({ left: 28, right: 28, top: 10, bottom: 10 })
              .backgroundColor(this.brandRed)
              .borderRadius(6)
              .onClick(() => {
                AlertDialog.show({
                  title: '确认下单',
                  message: `合计金额 ¥${this.totalPrice}，确认提交订单？`,
                  primaryButton: {
                    value: '确认',
                    action: () => {
                      this.cartItems = []
                      this.updateCartInfo()
                    }
                  },
                  secondaryButton: {
                    value: '取消',
                    action: () => {}
                  }
                })
              })
          }
          .width('100%')
          .padding({ left: 16, right: 16, top: 12, bottom: 12 })
        }
        .width('100%')
        .backgroundColor(this.cardBg)
        .border({ width: { top: 0.5 }, color: this.dividerColor })
      } else {
        // 空购物车
        Column() {
          Text('暂无商品')
            .fontSize(16)
            .fontColor(this.textHint)
            .margin({ top: 8 })

          Text('快去选购吧')
            .fontSize(13)
            .fontColor(this.textHint)
            .margin({ top: 4 })
        }
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
        .backgroundColor(this.bgColor)
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor(this.bgColor)
  }

  build() {
    Tabs({ barPosition: BarPosition.End, index: this.currentIndex }) {
      TabContent() {
        this.ProductListBuilder()
      }
      .tabBar(this.tabBarBuilder('商品', 0))

      TabContent() {
        this.CartBuilder()
      }
      .tabBar(this.tabBarBuilder('购物车', 1))
    }
    .onChange((index: number) => {
      this.currentIndex = index
    })
    .width('100%')
    .height('100%')
    .backgroundColor(this.bgColor)
  }

  @Builder
  tabBarBuilder(title: string, index: number) {
    Column() {
      Text(title)
        .fontSize(13)
        .fontColor(this.currentIndex === index ? this.brandRed : this.textHint)
        .fontWeight(this.currentIndex === index ? FontWeight.Bold : FontWeight.Normal)

      if (index === 1 && this.cartCount > 0) {
        Text(this.cartCount.toString())
          .fontSize(9)
          .fontColor('#FFFFFF')
          .backgroundColor(this.brandRed)
          .borderRadius(8)
          .padding({ left: 5, right: 5, top: 1, bottom: 1 })
          .position({ x: 36, y: -2 })
      }
    }
    .width('100%')
    .height(48)
    .justifyContent(FlexAlign.Center)
  }
}
