class CreatePosts < ActiveRecord::Migration[7.1]
  def change
    create_table :posts do |t|
      # create_table :テーブル名 do |t|
      t.string :location
      t.string :text
      t.timestamps
      # t.データ名：カラム名　　文字列はstring
    end
  end
end

# マイグレーションファイル・・・データベースの設計図
# rails db:migrate を実行して、マイグレーションファイルからテーブルを作成する※都度実行する
# rails g migretion Addカラム名Toテーブル名　カラム名:データ型名　・・・カラムの追加
# 作成済みのファイルの追加や削除の場合は、migrationと記述