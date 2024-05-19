import { AppendCommentVO, CommentItemTagVO, CommentReplyVO, ResultItem } from '../ResultItem'
import { Pagination } from './Pagination'

export class CommondPageModel {
  pagination: Pagination
  result: Array<ResultItem>
}

