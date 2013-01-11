
object false

node do |m|
 {:more => false}
end

node(:results) do |m|
  if @results
    @results.map do |brand| 
      { :text => brand.name, 
        :children => brand.models.map do |model| 
          {:text => model.name, :id => model.id, :brand => model.brand.name } 
        end,
        :indirect => false
      }
    end
  else
    {}
  end
end

