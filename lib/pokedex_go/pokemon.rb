class PokedexGo::Pokemon
    @@all = []
    attr_reader(
        :number, :gen, :buddy_dist,
        :egg, :evo_cost, :new_move_cost,
        :name, :stamina, :attack,
        :defense, :max_cp, :pve_rating,
        :type, :profile_url, :weight,
        :height, :fast_moves, :charge_moves,
        :pve_movesets, :pvp_movesets, :female_ratio,
        :weaknesses, :resistances
    )

    def initialize(attributes = {})
        attributes.each do |key, value|
            instance_variable_set("@#{key}", value)
        end

        @@all << self
    end

    def self.all()
        return @@all
    end

    def self.sort(method)
        @@all.sort do |a, b|
            a.instance_variable_get("@#{method}") <=> b.instance_variable_get("@#{method}")
        end
    end
end