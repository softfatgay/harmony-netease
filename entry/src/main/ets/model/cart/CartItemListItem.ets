export class CartItemListItem {
  uniqueKey: string
  id: number
  itemId: number
  status: number
  skuId: number
  sellVolume: number
  cnt: number
  totalPrice: number
  retailPrice: number
  actualPrice: number
  subtotalPrice: number
  preSellStatus: number
  preSellPrice: number
  preSellVolume: number
  type: number
  source: number
  sources: Array<number>
  itemName: string
  pic: string
  extId: string
  promTag: string
  priceReductDesc: string
  // number crmCartInfo

  valid: boolean
  checked: boolean
  editChecked: boolean
  ///限购
  limitPurchaseFlag: boolean
  ///限购数量
  limitPurchaseCount: number
  ///是否可以购买（0不可以，1可以）
  preemptionStatus: number
  ///是否可以切换属性
  canSwitchSpec: boolean
  stepNo: number
  checkExt: Object
  specArray: Array<SpecListItem>
  cartItemTips: Array<string>
  timingPromotion: string
  finishTip: string
  remainTime: number
  warehouseInfo: WarehouseInfo
  appFreshmanBannerVO: AppFreshmanBannerVO
}

export class SpecListItem {
  specName: String
  specValue: String
}

export class WarehouseInfo {
  desc: string
  type: number
}

export class AppFreshmanBannerVO {
  freshmanDesc: String
  appFreshmanPrice: String
}

