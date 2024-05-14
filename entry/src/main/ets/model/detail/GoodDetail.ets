import HashMap from '@ohos.util.HashMap'
import { BannerModel } from '../BannerModel'
import { CategoryL1ListItem } from '../CategoryL1ListItem'
import { FinalPriceInfoVO } from '../home/FinalPriceInfoVO'
import { IssueListItem } from '../IssueListItem'
import { ItemTagListItem } from '../ItemTagListItem'
import { ListPromBanner } from '../ListPromBanner'
import { PriceModel } from '../PriceModel'
import { ResultItem } from '../ResultItem'
import { ShoppingReward } from '../ShoppingReward'
import { ShoppingRewardRule } from '../ShoppingRewardRule'
import { SkuListItem } from '../SkuListItem'
import { HdrkDetailVOListItem, SkuFreight, SkuMapValue } from '../SkuMapValue'
import { SkuSpecListItem } from '../SkuSpecListItem'
import { TopLogo } from '../TopLogo'

export class GoodDetail {
  id: number
  listPicUrl: string
  name: string
  seoTitle: string
  simpleDesc: string
  primaryPicUrl: string
  primarySkuId: number
  retailPrice: number
  counterPrice: number
  status: number
  rank: number
  soldOut: boolean
  underShelf: boolean
  updateTime: number
  price: PriceModel
  itemDetail: ItemDetail
  skuList: Array<SkuListItem>
  attrList: Array<AttrListItem>
  skuMap: Map<string, SkuMapValue>
  skuSpecList: Array<SkuSpecListItem>
  sellVolume: number
  issueList: Array<IssueListItem>
  hdrkDetailVOList: Array<HdrkDetailVOListItem>
  comments: Array<ResultItem>
  newItemFlag: boolean
  primarySkuPreSellPrice: number
  primarySkuPreSellStatus: number
  pieceNum: number
  pieceUnitDesc: string
  colorNum: number
  limitedFlag: number
  promId: number
  preLimitFlag: number
  productPlace: string
  promotionDesc: string
  specialPromTag: string
  extraPrice: string
  appExclusiveFlag: boolean
  itemTagList: Array<ItemTagListItem>
  isPreemption: number
  preemptionStatus: number
  buttonType: number
  showTime: number
  onSaleTime: number
  itemPromValid: boolean
  autoOnsaleTime: number
  autoOnsaleTimeLeft: number
  displaySkuId: number
  saleCenterSkuId: number
  itemType: number
  points: number
  showPoints: boolean
  pointsPrice: number
  forbidExclusiveCal: boolean
  commentCount: number = 0
  commentWithPicCount: number
  freightInfo: string
  itemLimit: string
  itemSizeTableFlag: boolean
  itemSizeTableDetailFlag: boolean
  featuredSeries: FeaturedSeries
  categoryList: Array<CategoryL1ListItem>

  ///是否有评价率
  goodCmtRate: string
  promoTip: string
  shoppingReward: ShoppingReward
  shoppingRewardRule: ShoppingRewardRule
  recommendReason: Array<string>
  skuFreight: SkuFreight
  fullRefundPolicy: FullRefundPolicy
  couponShortNameList: Array<string>
  detailPromBanner: DetailPromBanner
  welfareCardVO: WelfareCardVO
  simpleBrandInfo: SimpleBrandInfo
  spmcBanner: SpmcBanner
  listPromBanner: ListPromBanner
  brandInfo: BrandInfo
  promTag: string
  specList: Array<SpecListItem>
  adBanners: Array<AdBannersItem>
  tryOutEventReport: TryOutEventReport
  banner: BannerModel
  showPrice: boolean
  countryInfo: string
  promDesc: string
  topLogo: TopLogo
  finalPriceInfoVO: FinalPriceInfoVO
}

export class ItemDetail {
  detailHtml: string
  picUrl1: string
  picUrl2: string
  picUrl3: string
  picUrl4: string
  picUrl5: string
  videoInfo: VideoInfo
}

export class VideoInfo {
  mp4VideoUrl: string
  mp4VideoSize: string
  webmVideoUrl: string
  webmVideoSize: string
}

export class AttrListItem {
  attrName: string
  attrValue: string
}

export class FeaturedSeries {
  detailPicUrl: string
  id: number
}

export class FullRefundPolicy {
  detailTitle: string
  titles: Array<string>
  content: Array<string>
}

export class DetailPromBanner {
  bannerType: number
  bannerTitleUrl: string
  bannerContentUrl: string
  promoTitle: string
  promoSubTitle: string
  startTime: string
  activityPrice: string
  retailPrice: string
  activityPriceExt: string
  sellVolumeDesc: string
  countdown: number
}

class WelfareCardVO {
  picUrl: string
  schemeUrl: string
}

export class SpmcBanner {
  spmcDesc: string
  spmcPrice: string
  spmcPrivilegeMess: string
  spmcEconomizePrice: string
  spmcTagDesc: string
  spmcLinkUrl: string
  btnValue: string
}

export class SimpleBrandInfo {
  title: string
  ownType: number = -1
  logoUrl: string
  aspectRatio: number
}

export class SpecListItem {
  specName: string
  specValue: string
}

export class BrandInfo {
  brandId: number
  title: string
  subTitle: string
  desc: string
  brandType: number
  type: number
  picUrl: string
  ownType: number
  merchantId: any
}

export class AdBannersItem {
  picUrl: string
  targetUrl: string
  extra: AdBannersExtra
}

export class AdBannersExtra {
  materialContentFrom: number
  taskType: number
  itemFrom: number
  resourcesId: number
  rcmdSort: boolean
  materialName: string
  crmUserGroupName: string
  materialType: string
  crmUserGroupId: string
  materialId: string
  taskId: string
}

export class TryOutEventReport {
  nickName: string
  job: string
  title: string
  score: number
  avatar: string
  detail: Detail
}

export class Detail {
  reportDetail: string
}