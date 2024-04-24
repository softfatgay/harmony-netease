import List from '@ohos.util.List'
import { NewItemTagModel } from './NewItemTagModel'

export class NewItemModel {
  scenePicUrl: String
  simpleDesc: String
  retailPrice: Number
  itemTagList: List<NewItemTagModel>
  id: Number
}