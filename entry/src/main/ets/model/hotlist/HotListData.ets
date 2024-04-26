import { ItemListItem } from '../ItemListItem'

export class HotListData {
  itemList: Array<ItemListItem>
  extra: Extra
}

class Extra {
  rankLongId: number
}