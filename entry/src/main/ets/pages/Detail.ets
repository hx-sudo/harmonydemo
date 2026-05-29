import { Product, getProductList } from '../model/Product'
import router from '@ohos.router'

@Entry
@Component
struct Detail {
  @State product: Product | undefined = undefined
  @State quantity: number = 1

  private brandRed: string = '#8B0000'
  private textPrimary: string = '#1A1A1A'
  private textSecondary: string = '#666666'
  private textHint: string = '#999999'
  private bgColor: string = '#F8F6F3'
  private cardBg: string = '#FFFFFF'
  private dividerColor: string = '#EDE8E2'

  aboutToAppear() {
    const params = router.getParams() as Record<string, number>
    const productId = params.productId
    this.product = getProductList().find((item: Product) => item.id === productId)
  }

  build() {
    Column() {
      // 顶部导航栏
      Row() {
        Text('<')
          .fontSize(20)
          .fontColor('#FFFFFF')
          .width(40)
          .height(40)
          .textAlign(TextAlign.Center)
          .onClick(() => {
            router.back()
          })

        Text('商品详情')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor('#FFFFFF')

        Blank()
          .width(40)
      }
      .width('100%')
      .height(56)
      .backgroundColor(this.brandRed)
      .padding({ left: 8, right: 16 })

      if (this.product) {
        // 商品图片区域
        Column() {
          Text('贵州茅台')
            .fontSize(24)
            .fontColor(this.brandRed)
            .fontWeight(FontWeight.Bold)

          Text('KWEICHOW MOUTAI')
            .fontSize(12)
            .fontColor(this.textHint)
            .margin({ top: 4 })
            .letterSpacing(2)
        }
        .width('100%')
        .height(220)
        .backgroundColor('#FDF6F0')
        .justifyContent(FlexAlign.Center)

        // 商品信息卡片
        Column() {
          // 名称和价格
          Row() {
            Column() {
              Text(this.product.name)
                .fontSize(18)
                .fontWeight(FontWeight.Bold)
                .fontColor(this.textPrimary)

              Text(this.product.description)
                .fontSize(13)
                .fontColor(this.textSecondary)
                .margin({ top: 8 })
                .lineHeight(20)
            }
            .layoutWeight(1)
            .alignItems(HorizontalAlign.Start)
          }
          .width('100%')

          Divider()
            .color(this.dividerColor)
            .margin({ top: 16, bottom: 16 })

          // 价格
          Row() {
            Text('价格')
              .fontSize(14)
              .fontColor(this.textSecondary)

            Blank()

            Text(`¥${this.product.price}`)
              .fontSize(22)
              .fontColor(this.brandRed)
              .fontWeight(FontWeight.Bold)

            Text('/瓶')
              .fontSize(12)
              .fontColor(this.textHint)
              .margin({ left: 4 })
          }
          .width('100%')

          Divider()
            .color(this.dividerColor)
            .margin({ top: 16, bottom: 16 })

          // 数量选择
          Row() {
            Text('数量')
              .fontSize(14)
              .fontColor(this.textSecondary)

            Blank()

            Row() {
              Text('-')
                .width(32)
                .height(32)
                .fontSize(18)
                .textAlign(TextAlign.Center)
                .backgroundColor('#F0EDE8')
                .borderRadius(4)
                .fontColor(this.textSecondary)
                .onClick(() => {
                  if (this.quantity > 1) {
                    this.quantity--
                  }
                })

              Text(this.quantity.toString())
                .fontSize(16)
                .width(44)
                .textAlign(TextAlign.Center)
                .fontColor(this.textPrimary)

              Text('+')
                .width(32)
                .height(32)
                .fontSize(18)
                .textAlign(TextAlign.Center)
                .backgroundColor('#F0EDE8')
                .borderRadius(4)
                .fontColor(this.textSecondary)
                .onClick(() => {
                  this.quantity++
                })
            }
          }
          .width('100%')
        }
        .width('100%')
        .padding(20)
        .backgroundColor(this.cardBg)
        .margin({ top: 12 })

        Blank()
          .layoutWeight(1)

        // 底部操作栏
        Column() {
          Row() {
            Column() {
              Text('小计')
                .fontSize(12)
                .fontColor(this.textHint)

              Text(`¥${this.product.price * this.quantity}`)
                .fontSize(20)
                .fontColor(this.brandRed)
                .fontWeight(FontWeight.Bold)
            }
            .alignItems(HorizontalAlign.Start)

            Blank()

            Text('加入购物车')
              .fontSize(15)
              .fontColor('#FFFFFF')
              .fontWeight(FontWeight.Medium)
              .padding({ left: 24, right: 24, top: 12, bottom: 12 })
              .backgroundColor(this.brandRed)
              .borderRadius(6)
              .onClick(() => {
                AlertDialog.show({
                  title: '提示',
                  message: `已将 ${this.quantity} 件 ${this.product!.name} 加入购物车`,
                  primaryButton: {
                    value: '确定',
                    action: () => {
                      router.back()
                    }
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
        Column() {
          Text('商品不存在')
            .fontSize(16)
            .fontColor(this.textHint)
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
}
