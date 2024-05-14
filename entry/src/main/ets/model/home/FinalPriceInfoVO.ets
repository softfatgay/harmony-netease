export class FinalPriceInfoVO {
  banner: BannerVO
  priceInfo: PriceInfo
  type: number
}

export class BannerVO {
  logo: string
  title: string
  content: string
  price: string
}

export class PriceInfo {
  finalPrice: FinalPrice
  counterPrice: string
  basicPrice: string
}

export class FinalPrice {
  prefix: string
  price: string
  suffix: string
}
