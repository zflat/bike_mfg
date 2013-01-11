require 'spec_helper'

module BikeMfg
  
  describe Query do
    
    describe "phrase_difference" do
      
      describe "A='1 2 3' B='1 4 5'" do
        it "should return 4 5" do
          a = '1 2 3'
          b = '4 5'
          
          d = Query::phrase_difference(a, b)
          expect(d).to eq('4 5')
        end

        describe "a='same' b='same'" do
          it "should be blank" do
            aa = 'same'
            bb = aa
            dd = Query::phrase_difference(aa, bb)
            expect(dd).to eq('')
          end
        end
      end
      
    end #  describe "phrase_difference"

    describe "Matcher" do
      describe "on to_s function" do
        before :each do
          @m = Query::Matcher.new('to_s')
        end

        it "should match a String object with an equal string" do
          s0 = 'test'
          s1 = String.new(s0)
          
          expect(@m.match?(s0, s1)).to be_true
        end

      end #  describe "on to_s function" 

    end # describe Matcher


    describe "matcher_AND" do
      before(:all) do
        @matcher = Query::Matcher.new('to_s')
      end
      describe "list ['ab 1', 'cd 2', 'ef 3']"
      before :each do
        @list = ['ab 12', 'ad 13', 'ef 3']
      end

      describe "phrase 'a 1'  " do
        before :each do
          @phrase = 'a 1'
        end

        it "should match 2 in the list" do
          ret = Query::match_AND(@list, @phrase, @matcher)
          expect(ret.count).to eq(2)
        end # it "should match 2 in the list"

      end #  describe "phrase '1 2'  "
    end #   describe "matcher_AND"

  end #   describe Query

end # module BikeMfg
