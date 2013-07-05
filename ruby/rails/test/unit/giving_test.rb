require 'test_helper'

class GivingTest < ActiveRecord::TestCase

  def test_delete_giver_deletes_givings
    giver = create_user('giver')
    Giving.create(:user=>giver, :gift=>create_gift)
    assert_difference 'Giving.count', -1 do
      giver.destroy
    end
  end

  def test_delete_gift_deletes_givings
    gift = create_gift
    Giving.create(:user=>create_user, :gift=>gift)
    assert_difference 'Giving.count', -1 do
      gift.destroy
    end
  end

  def test_delete_gift_deletes_taggings
    gift = create_gift
    gift.tag 'foo bar baz'
    gift.save!
    assert_difference 'GiftTag.count', -3 do
      gift.destroy
    end
  end

end
