import { BannerModel } from './BannerModel'
import { ItemTagListItem } from './ItemTagListItem'
import { PriceModel } from './PriceModel'
import { ShoppingReward } from './ShoppingReward'
import { ItemSkuSpecValueListItem } from './SkuListItem'
import { SkuSpec } from './SkuSpec'
import { SkuSpecValue } from './SkuSpecValue'

export class SkuMapValue {
  id: number
  counterPrice: number
  retailPrice: number
  primarySku: boolean
  sellVolume: number
  noActivitySellVolume: number
  valid: boolean
  itemSkuSpecValueList: Array<ItemSkuSpecValueListItem>
  preSellStatus: number
  preSellPrice: number
  preSellVolume: number
  preSellDesc: Object
  purchaseAttribute: number
  giftCardFlag: boolean
  virtualFlag: boolean
  limitedFlag: number
  promId: number
  preLimitFlag: number
  limitPurchaseFlag: boolean
  limitPurchaseCount: number
  limitPointCount: number
  buttonType: number
  limitPrice: number
  selected: boolean
  promValid: boolean
  hdrkDetailVOList: Array<HdrkDetailVOListItem>
  promotionDesc: string
  price: PriceModel
  banner: BannerModel
  itemTagList: Array<ItemTagListItem>
  points: number
  pointsPrice: number
  pic: string
  preemptionStatus: number
  shoppingReward: ShoppingReward
  skuTitle: string
  calcPrice: number
  desc: string
  skuLimit: string
  operationAttribute: number
  skuFreight: SkuFreight
  buyTitle: BuyTitle
}

export class SkuFreight {
  title: string
  freightInfo: string
  vipFreightInfo: string
  policyList: Array<PolicyListItem>
  type: number
}

export class PolicyListItem {
  id: number
  title: string
  content: string
  distributionArea: string
}

export class BuyTitle {
  title: string
  subTitle: string
}

export class HdrkDetailVOListItem {
  id: number
  name: string
  promLimitDesc: string
  activityType: string
  huodongUrlWap: string
  startTime: number
  endTime: number
  promotionType: number
  canUseCoupon: boolean
}