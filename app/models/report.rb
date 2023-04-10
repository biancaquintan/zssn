class Report < ApplicationRecord
  def self.calc_average_infections
    @data = {}
    
    @data[:infection] = "#{((User.where(infection: true).count.to_f / User.count.to_f) * 100).to_i}%"
    @data[:uninfection] = "#{((User.where(infection: false).count.to_f / User.count.to_f) * 100).to_i}%"

    @data
  end

  def self.calc_average_items_users
    items = Item.all
    users = User.where(infection: false)
    @data = {}
    @response = []

    items.each do |item|
      @data["users_by_#{item.name}"] = 0
      @data["total_#{item.name}"] = 0

      users.each do |user|
        if user.inventory.items.include?(item)
          @data["users_by_#{item.name}"] += 1
          @data["total_#{item.name}"] += user.inventory.items.to_a.count(item)
        end
      end

      calc_item = (@data["total_#{item.name}"]).to_f/(@data["users_by_#{item.name}"]).to_f
      @response << "#{item.name} / #{calc_item} usuários"

    end

    @response
  end

  def self.calc_total_lost
    @result = []
    infected_users = User.where(infection: true)
    infected_users.each do |user|
      total = user.inventory.items.pluck(:value).sum
      @result << "#{user.name} / #{total} point(s) lost"
    end
    @result
  end
end
