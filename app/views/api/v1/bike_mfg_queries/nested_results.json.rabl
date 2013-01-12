object false

node do |m|
 {:more => false}
end

node(:results) do |m|
  if @results
    @results.map do |brand| 
      { :text => brand.name, 
        :id => brand.id,
        :children => brand.models ? brand.models.map do |model| 
          {:text => model.name, :id => model.id, 
            :brand => model.brand.name,  :brand_id => model.brand.id} 
        end : [],
        :direct => brand.direct
      }
    end
  else
    ['no results here!']
  end
end

