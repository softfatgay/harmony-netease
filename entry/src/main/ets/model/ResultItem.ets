export class ResultItem {
  skuInfo: Array<String>
  frontUserName: string
  content: string
  createTime: number
  picList: Array<string>
  frontUserAvatar: string
  commentReplyVO: CommentReplyVO
  memberLevel: number
  appendCommentVO: AppendCommentVO
  star: number
  itemId: number
  commentItemTagVO: CommentItemTagVO
}

export class CommentReplyVO {
  replyContent: string
}

export class AppendCommentVO {
  content: string
  createTime: number
  picList: Array<string>
}

export class CommentItemTagVO {
  schemeUrl: string
  type: number
}