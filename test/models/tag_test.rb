require "test_helper"

class TagTest < ActiveSupport::TestCase
  test "valid tag" do
    tag = Tag.new(name: "tag_#{SecureRandom.hex(4)}")
    assert tag.valid?
  end

  test "requires unique name" do
    name = "tag_#{SecureRandom.hex(4)}"
    Tag.create!(name: name)
    duplicate = Tag.new(name: name)
    assert_not duplicate.valid?
    assert_includes duplicate.errors.full_messages, "タグ名はすでに存在します"
  end
end
