export class CartBottomBannerVO{
  promotionCartLeadInfo:PromotionCartLeadInfo
}

export class PromotionCartLeadInfo{
  icon:string
  content:Array<PromotionCartLeadInfoContent>
  button:PromotionCartLeadInfoButton
  spmcTip:SpmcTip
}

export class SpmcTip{
  title:string
  content:string
  saveList:Array<SaveList>
}

export class SaveList{
  title:string
  detail:string
  showStar:boolean
}

export class PromotionCartLeadInfoContent{
  value:string
  type:number
  schemeUrl:string
  bold:boolean
  crossLine:boolean
  underLine:boolean
  fontSize:number
}

export class PromotionCartLeadInfoButton{
  name:string
  picUrl:string
  schemeUrl:string
  jumpType:string
}