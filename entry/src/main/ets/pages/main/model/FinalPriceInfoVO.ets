export class FinalPriceInfoVO {
  banner: BannerVO
  priceInfo: PriceInfo
  type: number
}

export class BannerVO {
  logo: String
  title: string
  content: string
  price: String
}

export class PriceInfo {
  finalPrice: FinalPrice
  counterPrice: String
  basicPrice: string
}

export class FinalPrice {
  prefix: string
  price: string
  suffix: String
}
