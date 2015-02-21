require 'spec_helper'

RSpec.describe 'api/v1/bike_mfg_queries/nested_results.json.rabl', :type => :view do

  describe 'empty query term' do
    let(:request_stub){
      OpenStruct.new(:term => '')
    }

    let(:results){
      Rabl::Renderer.json(request_stub, 'api/v1/bike_mfg_queries/nested_results', :scope => request_stub)
    }

    it 'has no matches' do
      expect(results).to_not be_nil
    end
  end # 'empty query term' do
    
end

