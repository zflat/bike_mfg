# -*- mode: ruby -*-

object false

node do |m|
 {:more => false}
end

node do |m|
 {:q => term}
end

node(:results) do |m|
  if @results
    @results.map do |brand| 
      if brand.nil?
        nil
      else
        { :text => brand.name, 
          :brand_id => brand.id,
          :children => brand.models ? brand.models.map{ |model| 
            { :text => model.name, 
              :id => model.id, 
              :brand => (model.brand.nil?) ? nil : model.brand.name,
              :brand_id => (model.brand.nil?) ? nil : model.brand.id } 
          } : [],
          :direct => brand.direct
        }
      end
    end
  else
    []
  end
end

