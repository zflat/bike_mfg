# -*- mode: ruby -*-

object false

node do |m|
 {:more => false}
end

node do |m|
 {:q => term}
end

node(:results) do
  if @results
    if @results.first.respond_to?(:brand)
      @results.map { |o|
        {
          :text => o.name, 
          :id => o.id, 
          :brand => (o.brand.nil?) ? nil : o.brand.name, 
          :brand_id => (o.brand.nil?) ? nil : o.brand.id
        } 
      }
    else
      @results.map { |o| {:text => o.name, :id => o.id} }
    end
  else
    {}
  end
end



