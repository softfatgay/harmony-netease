import { SkuSpec } from './SkuSpec'
import { SkuSpecValue } from './SkuSpecValue'
export class SkuListItem {
  id: number
  counterPrice: number
  retailPrice: number
  primarySku: boolean
  sellVolume: number
  noActivitySellVolume: number
  valid: boolean
  baseId: number
  startTime: number
  endTime: number
  name: string
  pinPrice: number
  skuNum: number
  userNum: number
  skuId: number
  itemSkuSpecValueList: Array<ItemSkuSpecValueListItem>
}

export class ItemSkuSpecValueListItem {
  id: number
  skuId: number
  skuSpecId: number
  skuSpecValueId: number
  skuSpec: SkuSpec
  skuSpecValue: SkuSpecValue
}
