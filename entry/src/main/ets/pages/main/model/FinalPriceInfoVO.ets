export class FinalPriceInfoVO {
  banner: BannerVO
  priceInfo: PriceInfo
  type: number
}

export class BannerVO {
  logo: String
  title: String
  content: String
  price: String
}

export class PriceInfo {
  finalPrice: FinalPrice
  counterPrice: String
  basicPrice: string
}

export class FinalPrice {
  prefix: String
  price: String
  suffix: String
}
