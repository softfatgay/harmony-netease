import { BannerInfo } from './BannerInfo'
import { BuyNow } from './BuyNow'
export class TopicItem {
  topicId: string
  type: number
  pubType: number
  readCount: number
  style: number
  schemeUrl: string
  nickname: string
  bannerUrl: string
  avatar: string
  title: string
  subTitle: string
  picUrl: string
  newAppBanner;
  hasVideo: boolean
  hasLookCollects: boolean
  size: number
  duration: number
  supportNum: number
  appBanHeight: number
  appBanWidth: number
  newAppBannerWidth: number
  newAppBannerHeight: number
  supportFlag: boolean
  bannerInfo: BannerInfo
  lookPics: Array<any>
  buyNow: BuyNow
}