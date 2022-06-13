require 'rails_helper'

RSpec.describe Post, type: :model do
  it "is valid with valid attributes" do
    expect(Post.new(title: "New Title")).to be_valid
  end
end
