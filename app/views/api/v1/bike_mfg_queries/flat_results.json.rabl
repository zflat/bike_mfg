#collection @models, :root => :results, :object_root => false
#attributes :name => :text, :id => :id

object false

node do |m|
 {:more => false}
end

node do |m|
 {:q => term}
end

node(:results) do
  if @results
    @results.map { |o| {:text => o.name, :id => o.id} }
  else
    {}
  end
end



