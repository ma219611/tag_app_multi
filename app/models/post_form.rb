class PostForm
  include ActiveModel::Model

  ## PostFormクラスのオブジェクトがPostモデルの属性を扱えるようにする
  attr_accessor(
    :text, :image,
    :id, :created_at, :datetime, :updated_at, :datetime,
    :tag_name,
    tag_names: []
   )

  with_options presence: true do
    validates :text
    validates :image
  end

  validates :tag_name, length: { maximum: 5 }
  # フリマにあるけど、tag_appにはいれない

  def save
    binding.pry
    post = Post.create(text: text, image: image)

    tag = Tag.where(tag_name: tag_name).first_or_initialize
    tag.save

    PostTagRelation.create(post_id: post.id, tag_id: tag.id)
  end

  def update(params, post)
    # 一度タグの紐付けを消す
    post.post_tag_relations.destroy_all

    # paramsからタグを消す、タグの返り値を変数に代入。タグがなければnilが返り値
    tag_name = params.delete(:tag_name)

    # もしタグがすでにあれば情報を取得、なければインスタンス生成
    tag = Tag.where(tag_name: tag_name).first_or_initialize if tag_name.present?

    # もしタグが存在していればタグを保存
    tag.save if tag_name.present?
    post.update(params)
    PostTagRelation.create(post_id: post.id, tag_id: tag.id) if tag_name.present?
  end

end




# def update(params, post)
#   post.update(params)
# end