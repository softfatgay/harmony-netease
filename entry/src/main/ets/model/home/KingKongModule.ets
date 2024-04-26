export class KingKongModule {
  norColor: String
  background: String
  selectedColor: String
  kingKongList: Array<KingKongItem>
}

export class KingKongItem {
  picUrl: string
  schemeUrl: string
  text: string
  textColor: String
}