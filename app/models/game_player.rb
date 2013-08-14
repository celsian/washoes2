class GamePlayer < ActiveRecord::Base
  has_many :points, dependent: :destroy
  belongs_to :game
  belongs_to :player
  belongs_to :bracket

  accepts_nested_attributes_for :points

  def total_points
    total_array = []

    self.points.each do |point|
      if point['score']
        total_array << point['score']
      end
    end

    total = total_array.reduce(0, :+)
  end

  def total
    if self.points.length < 2
      0
    else
      # self.points.map {|point| point['score']}.reduce(0, :+)
      total_array = []

      self.points.each do |point|
        if point['score']
          total_array << point['score']
        end
      end

      total = total_array.reduce(0, :+)

      if total > 63
        total
      elsif total > 42
        total - 42
      elsif total > 21
        total - 21
      else
        total
      end

    end
  end

end
