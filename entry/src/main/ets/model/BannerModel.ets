import { PriceModel } from './PriceModel'

export class BannerModel {
  status: number
  type: number
  processBanner: ProcessBanner
}

export class ProcessBanner {
  title: string
  supplementText: string
  priceInfo: PriceModel
  logoUrl: string
  timePrefix: string
  endTimeGap: number
  bgColor: string
  priceBgColor: string
}
