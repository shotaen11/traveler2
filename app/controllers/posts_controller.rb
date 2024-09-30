class PostsController < ApplicationController
# 新規投稿画面の作成　※コントローラー名は、複数形で指定する
  def new
    # new を定義し、newアクションが実行される
    @post = Post.new
    # @post・・・コントローラーからviewへ繋げるインスタンス変数、Post.new・・・modelへ。先頭は大文字で書く。
  end

  def create #新規投稿のアクション
    @post = Post.new(post_params) #post_params:ストロングパラメータ　@postにフォームから送信されたデータをセット
    @post.user_id = current_user.id #新しく作成された投稿に、現在ログインしているユーザー（current_user）を紐付け
    if @post.save #保存　※viewに受け渡す
     redirect_to post_path(@post.id) #保存に成功した場合、投稿詳細ページ（post_path(@post.id)）へ
    else
      render :new, status: :unprocessable_entity #失敗した場合、フォームに入力された内容やエラーメッセージが再表示(render :new),フォームに問題があったことを明示する(status: :unprocessable_entity)
    end
  end

  def index #ルーティングのresoucesにおけるindexを定義（閲覧ページ）
    @posts = Post.published.page(params[:page]).reverse_order #変数は複数形とする
    @posts = @posts.where('location LIKE ?', "%#{params[:search]}%") if params[:search].present?
  end

  def show #ルーティングのresoucesにおけるshowを定義（投稿詳細ページ）
    @post = Post.find(params[:id]) #１つだけ取得するので、変数は単数　findメソッドで、postから１つのidを取得
    @post.increment!(:view_count) #閲覧数をインクリメント
    @comment = Comment.new
    @comments = @post.comments.page(params[:page]).per(7).reverse_order
  end

  def edit #ルーティングのresoucesにおけるeditを定義（編集ページ）
    @post = Post.find(params[:id]) #１つだけ取得するので、変数は単数　findメソッドで、postから１つのidを取得
  end

  def update #編集後の保存（更新）
    @post = Post.find(params[:id]) #編集するpostを1つ取得
    if @post.update(post_params) #更新
     redirect_to post_path(@post.id) #更新後のページ行き先
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy #ルーティングのresoucesにおけるdestroyを定義（削除ページ）
    post = Post.find(params[:id]) #viewに渡す必要がないため、ローカル変数
    post.destroy
    redirect_to posts_path #削除後、一覧ページへリダイレクト
  end

  def confirm
    @posts = current_user.posts.draft.page(params[:page]).reverse_order
  end
  
  private #フォームから送信されたデータを安全に扱うための仕組み(ここから下のメソッドは「プライベートメソッド」として扱われ、コントローラの外からは直接呼び出し不可)
  def post_params #フォームから送信されたデータをフィルタリングして、許可されたデータのみを受け取る
    params.require(:post).permit(:user_id, :location, :text, :image, :status, :star)
# requireモデル名:フォームから送信されたparams（パラメータ）の中にpostキーがあることを要求
# permitカラム名:どの属性が許可されているかを明示的に指定
  end
 
end