export class Product {
  id: number
  name: string
  price: number
  image: string
  description: string
  category: string

  constructor(id: number, name: string, price: number, image: string, description: string, category: string = '其他') {
    this.id = id
    this.name = name
    this.price = price
    this.image = image
    this.description = description
    this.category = category
  }
}

export class CartItem {
  product: Product
  quantity: number

  constructor(product: Product, quantity: number = 1) {
    this.product = product
    this.quantity = quantity
  }
}

export function getProductList(): Product[] {
  return [
    new Product(1, '飞天茅台 53度 500ml', 1499, 'https://img1.baidu.com/it/u=1751630498,3644097910&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=800',
      '酱香突出，幽雅细腻，酒体醇厚，回味悠长，空杯留香持久。', '飞天'),
    new Product(2, '茅台王子酒 53度 500ml', 258, 'https://img2.baidu.com/it/u=3278391726,2865811498&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=800',
      '茅台王子酒，酱香型白酒，口感柔和，适合日常饮用。', '王子'),
    new Product(3, '茅台迎宾酒 53度 500ml', 198, 'https://img1.baidu.com/it/u=3617854676,2291097666&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=800',
      '茅台迎宾酒，入门级酱香酒，性价比高。', '迎宾'),
    new Product(4, '赖茅传承 53度 500ml', 399, 'https://img0.baidu.com/it/u=2815319619,4078325130&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=800',
      '赖茅传承，经典酱香，传承百年工艺。', '其他'),
    new Product(5, '汉酱酒 51度 500ml', 368, 'https://img1.baidu.com/it/u=1751630498,3644097910&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=800',
      '汉酱酒，柔和酱香，入口绵柔。', '其他'),
    new Product(6, '贵州大曲 53度 500ml', 168, 'https://img2.baidu.com/it/u=3278391726,2865811498&fm=253&fmt=auto&app=138&f=JPEG?w=500&h=800',
      '贵州大曲，经典老味道，亲民价格。', '其他'),
  ]
}
