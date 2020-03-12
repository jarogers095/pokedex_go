module Sortable
    def sort(method)
        self.all.sort! do |a, b|
            a.instance_variable_get("@#{method}") <=> b.instance_variable_get("@#{method}")
        end
    end
end