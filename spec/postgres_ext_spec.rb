if Gem.loaded_specs.key?('postgres_ext')
  describe PostgresExt do
    ActiveRecord::Schema.define do
      self.verbose = false

      create_table :scores, force: true do |t|
        t.references :game
        t.references :user
        t.timestamps
      end

      create_table :games, force: true, &:timestamps
    end

    class Score < ActiveRecord::Base
      belongs_to :game
      belongs_to :user
    end

    class Game < ActiveRecord::Base
    end

    class PostgresExtMiddleware
      def self.call(arel, next_middleware)
        next_middleware.call(arel)
      end
    end

    it 'works for Score.with CTE' do
      game = Game.create!
      score = Score.create!(game: game)
      _other_score = Score.create! game: Game.create!
      query = Score
        .with(my_games: Game.where(id: game))
        .joins('INNER JOIN "my_games" ON "scores"."game_id" = "my_games"."id" ')

      expect(PostgresExtMiddleware)
        .to receive(:call)
        .and_wrap_original do |m, arel, next_middleware, context|
        expect(arel.to_sql).to eq context[:original_sql]

        m.call(arel, next_middleware)
      end

      Arel.middleware.apply([PostgresExtMiddleware]) do
        expect(query.reload).to eq [score]
      end
    end

    # TODO: broken in the gem
    xit 'works for Score.from_cte CTE' do
      Arel.middleware.apply([PostgresExtMiddleware]) do
        game = Game.create!
        user = User.create!
        score = Score.create!(game: game, user: user)
        _other_score = Score.create! game: Game.create!, user: User.create!
        query = Score.from_cte('scores_for_game', Score.where(game_id: game)).where(user_id: user)

        expect(PostgresExtMiddleware).to receive(:call).and_wrap_original do |m, arel, context|
          expect(arel.to_sql).to eq context[:original_sql]

          m.call(arel, context)
        end

        expect(query.load).to eq [score]
      end
    end
  end
end
