require "spec_helper"

describe OmniAuth::BookingSync::Identifier do
  describe "#value" do
    it "returns a number" do
      expect(OmniAuth::BookingSync::Identifier.new("1").value).to eq 1
    end

    it "returns nil if blank" do
      expect(OmniAuth::BookingSync::Identifier.new("").value).to be_nil
    end

    it "returns nil if non numeric characters given" do
      expect(OmniAuth::BookingSync::Identifier.new("a").value).to be_nil
    end

    it "returns nil if negative number" do
      expect(OmniAuth::BookingSync::Identifier.new("-1").value).to be_nil
    end
  end

  describe "#valid?" do
    it "returns true if a number" do
      expect(OmniAuth::BookingSync::Identifier.new("1")).to be_valid
    end

    it "returns false if blank" do
      expect(OmniAuth::BookingSync::Identifier.new("")).not_to be_valid
    end

    it "returns false if non numeric characters given" do
      expect(OmniAuth::BookingSync::Identifier.new("a")).not_to be_valid
    end

    it "returns false if negative number" do
      expect(OmniAuth::BookingSync::Identifier.new("-1")).not_to be_valid
    end
  end
end
