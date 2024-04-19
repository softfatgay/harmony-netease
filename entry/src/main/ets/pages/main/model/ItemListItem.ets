import List from '@ohos.util.List'
import { FinalPriceInfoVO } from './FinalPriceInfoVO'
import { HotSaleListBottomInfo } from './HotSaleListBottomInfo'
import { ItemTagListItem } from './ItemTagListItem'
import { ListPromBanner } from './ListPromBanner'
import { SkuSpecListItem } from './SkuSpecListItem'
import { TopLogo } from './TopLogo'

export class ItemListItem {
  id: Number
  listPicUrl: string
  name: string
  seoTitle: String
  simpleDesc: String
  primaryPicUrl: String
  primarySkuId: Number
  retailPrice: number
  counterPrice: Number
  status: Number
  rank: Number
  soldOut: boolean
  underShelf: boolean
  sellVolume: Number
  newItemFlag: boolean
  pieceNum: Number
  pieceUnitDesc: String
  colorNum: Number
  limitedFlag: Number
  promId: Number
  preLimitFlag: Number
  scenePicUrl: String
  zoomTransPicV2Url: String
  finalPriceInfoVO: FinalPriceInfoVO
  productPlace: String
  promDesc: string
  promTag: String
  goodCmtRate: String
  hotSaleListBottomInfo: HotSaleListBottomInfo
  itemTagList: List<ItemTagListItem>
  listPromBanner: ListPromBanner
  skuSpecList: List<SkuSpecListItem>
  topLogo: TopLogo
  preLogo: Array<TopLogo>
  ///新品首发中使用
  sortOriginPrice: Number
}