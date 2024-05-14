import List from '@ohos.util.List'
import { FinalPriceInfoVO } from './home/FinalPriceInfoVO'
import { HotSaleListBottomInfo } from './home/HotSaleListBottomInfo'
import { ItemTagListItem } from './ItemTagListItem'
import { ListPromBanner } from './ListPromBanner'
import { SkuSpecListItem } from './SkuSpecListItem'
import { Logo } from './Logo'
import { KingKongType } from './kinfkong/KingKongType'

export class ItemListItem extends KingKongType{
  id: number
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
  goodCmtRate: string
  hotSaleListBottomInfo: HotSaleListBottomInfo
  itemTagList: Array<ItemTagListItem>
  listPromBanner: ListPromBanner
  skuSpecList: List<SkuSpecListItem>
  topLogo: Logo
  preLogo: Array<Logo>
  ///新品首发中使用
  sortOriginPrice: Number
}