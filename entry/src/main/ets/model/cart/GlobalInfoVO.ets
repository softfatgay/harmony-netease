export class GlobalInfoVO{
  showTotalPrice:string
  showActualPrice:string
  showActivityPrice:string
  skuMaxCount:number
  selectedCount:number
  rebateCardLeadInfo:RebateCardLeadInfo
  countCornerMark:string
  allChecked:boolean
  canAllCheck:boolean
}

export class RebateCardLeadInfo{
  iconUrl:string
  text:string
  schemeUrl:string
}