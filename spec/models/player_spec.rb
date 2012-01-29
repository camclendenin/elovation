require "spec_helper"

describe Player do
  describe "validations" do
    context "name" do
      it "is required" do
        player = FactoryGirl.build(:player, :name => nil)

        player.should_not be_valid
        player.errors[:name].should == ["can't be blank"]
      end

      it "must be unique" do
        FactoryGirl.create(:player, :name => "Drew")
        player = FactoryGirl.build(:player, :name => "Drew")

        player.should_not be_valid
        player.errors[:name].should == ["has already been taken"]
      end
    end
  end

  describe "name" do
    it "has a name" do
      player = FactoryGirl.create(:player, :name => "Drew")

      player.name.should == "Drew"
    end
  end

  describe "recent_results" do
    it "returns 5 of the player's results" do
      game = FactoryGirl.create(:game)
      player = FactoryGirl.create(:player)

      10.times { FactoryGirl.create(:result, :game => game, :winner => player) }

      player.recent_results.size.should == 5
    end

    it "returns the 5 most recently created results" do
      newer_results = nil
      game = FactoryGirl.create(:game)
      player = FactoryGirl.create(:player)

      Timecop.freeze(3.days.ago) do
        5.times.map { FactoryGirl.create(:result, :game => game, :winner => player) }
      end

      Timecop.freeze(1.day.ago) do
        newer_results = 5.times.map { FactoryGirl.create(:result, :game => game, :winner => player) }
      end

      player.recent_results.sort.should == newer_results.sort
    end

    it "orders results by created_at, descending" do
      game = FactoryGirl.create(:game)
      player = FactoryGirl.create(:player)
      old = new = nil

      Timecop.freeze(2.days.ago) do
        old = FactoryGirl.create(:result, :game => game, :winner => player)
      end

      Timecop.freeze(1.days.ago) do
        new = FactoryGirl.create(:result, :game => game, :winner => player)
      end

      player.recent_results.should == [new, old]
    end
  end
end
