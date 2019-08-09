def remove_active_record_info(arel)
  next_middleware = ->(next_arel) { next_arel }
  Arel::Transformer::RemoveActiveRecordInfo.call(arel, next_middleware)
end

ActiveRecord::Base.establish_connection(
  adapter: 'postgresql',
  host: 'localhost',
  databse: 'arel_toolkit_test',
  username: 'postgres',
)

ActiveRecord::Schema.define do
  self.verbose = false

  create_table :users, force: :cascade do |t|
    t.string :username

    t.timestamps
  end

  create_table :posts, force: :cascade do |t|
    t.string :title
    t.text :content
    t.boolean :public
    t.integer :owner_id

    t.timestamps
  end
end

ActiveRecord::Base.connection.execute(
  'CREATE OR REPLACE VIEW public_posts AS SELECT * FROM posts WHERE public = true',
)

ActiveRecord::Base.connection.execute(
  'DROP MATERIALIZED VIEW IF EXISTS posts_count; ' \
  'CREATE MATERIALIZED VIEW posts_count AS SELECT COUNT(*) FROM posts',
)

ActiveRecord::Base.connection.execute(
  'CREATE OR REPLACE FUNCTION view_count(integer, integer)' \
  "RETURNS integer LANGUAGE SQL AS 'SELECT 4'",
)

ActiveRecord::Base.connection.execute(
  <<~SQL,
    DROP AGGREGATE IF EXISTS sum_view_count(integer);
    CREATE AGGREGATE sum_view_count(integer) (
      SFUNC = public.view_count,
      STYPE = integer,
      INITCOND = '0'
    )
  SQL
)

class Post < ActiveRecord::Base
  belongs_to :owner, class_name: 'User'
end

class User < ActiveRecord::Base
  has_many :posts, foreign_key: :owner_id
end

class PublicPost < ActiveRecord::Base
  self.table_name = :public_posts
end

class PostsCount < ActiveRecord::Base
  self.table_name = :posts_count
end

Arel::Middleware::Railtie.insert_postgresql unless Gem.loaded_specs.key?('railties')
