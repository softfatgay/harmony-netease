export class SkuSpec {
  name: string
  id: number
  type: number
  skuSpecValueList: Array<SkuSpecValueListItem>
}

export class SkuSpecValueListItem {
  id: number
  value: string
}