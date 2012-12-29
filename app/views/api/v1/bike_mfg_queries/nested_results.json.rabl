#collection @models, :root => :results, :object_root => false
#attributes :name => :text, :id => :id

object false

node do |m|
 {:more => false}
end

#node(:results) do
#  @models.map { |o| {:text => o.name, :id => o.id} } unless @models.nil?
#end

node(:results) do |m|
  if @results
    @results.map { |b| {:text => b.name, :children => b.models.map { |m| {:text => m.name, :id => m.id, :brand => m.brand.name} } } }
  else
    {}
  end
end

