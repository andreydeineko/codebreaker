require 'spec_helper'

module Codebreaker

  describe Game do
    let(:output) { double('output').as_null_object }
    let(:game)   { Game.new(output) }

    describe "#secret_code" do
      it "generates secret code in range between 1 and 5" do
        game.start
        game.instance_variable_get(:@secret).to_i.should be_a_kind_of(Fixnum)
        game.instance_variable_get(:@secret).to_s.length.should == 4
      end
    end

    describe "#start" do
      it "sends a welcome message" do
        output.should_receive(:puts).with("Welcome to Codebreaker! \nAt any point of the game you can request hint by typing 'hint' \nYou have 10 attempt, good luck!")
        game.start('1234')
      end

      it "prompts for the first guess" do
        output.should_receive(:puts).with('Enter guess (4 numbers between 1 and 5): ' )
        game.start('1234')
      end
    end

    describe "#guess" do
      it "sends the mark to output" do
        game.start('1234')
        output.should_receive(:puts).with('++++')
        game.guess('1234')
      end
    end
  end

  describe Marker do
    describe "#exact_match_count" do
      context "with no matches" do
        it "returns 0" do
          marker = Marker.new('1234','5555')
          marker.exact_match_count.should == 0
        end
      end
      
      context "with 1 exact match" do
        it "returns 1" do
          marker = Marker.new('1234','1555')
          marker.exact_match_count.should == 1
        end
      end
      
      context "with 1 number match" do
        it "returns 0" do
          marker = Marker.new('1234','2555')
          marker.exact_match_count.should == 0
        end
      end
      
      context "with 1 exact match and 1 number match" do
        it "returns 1" do
          marker = Marker.new('1234','1525')
          marker.exact_match_count.should == 1
        end
      end
    end

    describe "#number_match_count" do
      context "with no matches" do
        it "returns 0" do
          marker = Marker.new('1234','5555')
          marker.number_match_count.should == 0
        end
      end

      context "with 1 number match" do
        it "returns 1" do
          marker = Marker.new('1234','2555')
          marker.number_match_count.should == 1
        end
      end
      
      context "with 1 exact match" do
        it "returns 0" do
          marker = Marker.new('1234','1555')
          marker.number_match_count.should == 0
        end
      end
      
      context "with 1 exact match and 1 number match" do
        it "returns 1" do
          marker = Marker.new('1234','1525')
          marker.number_match_count.should == 1
        end
      end

      context "with 1 exact match duplicated in guess" do
    it "returns 0" do
      pending("refactor number_match_count")
      marker = Marker.new('1234','1155')
      marker.number_match_count.should == 0
    end
    end
    end
  end

end