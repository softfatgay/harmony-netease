export class PriceDetailBanner {
  promPrice: PromPrice
  discountPrice:PromPrice
  totalPrice:PromPrice
  totalPriceV2:PromPrice
  originTotalPriceV2:PromPrice
}

export class DiscountPrice{

}

export class PromPrice {
  title: string
  titleRemark: string
  price: string
  priceRemark: any
  priceList: Array<PriceList>
}

export class PriceList {
  title: string
  price: string
}