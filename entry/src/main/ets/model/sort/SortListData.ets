import { Category } from '../Category'
import { ItemListItem } from '../ItemListItem'

export class SortListData {
  categoryItems: SortlistCategoryItem
  categoryL2List: Array<Category>
}

export class SortlistCategoryItem {
  category: Category
  itemList: Array<ItemListItem>
}
