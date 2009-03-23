require 'test/unit'
require File.dirname(__FILE__) + '/test_helper.rb'
class ValidatesNotProfaneTest < Test::Unit::TestCase
  # Replace this with your real tests.
  load_schema
  
  class User < ActiveRecord::Base
    validates_not_profane :name
    validates_not_profane :bio, :tolerance => 5
  end

  class Post < ActiveRecord::Base
    validates_not_profane :subject, :racist => true
    validates_not_profane :post,    :sexual => true
  end
  
  def test_schema_has_loaded_correctly
    assert_equal [], User.all
    assert_equal [], Post.all
  end
  
  def test_basic_blocks_profane
    u = User.new(:name => "fucker")
    assert_not_valid u
  end
  
  def test_basic_allows_clean
    u = User.new(:name => "Steve")
    assert_valid u
  end
  
  def test_tolerance_blocks
    u = User.new(:bio => "fucking prick") # badness = 5
    assert_not_valid u
  end
  
  def test_tolerance_allows
    u = User.new(:bio => "queef") # badness = 4
    assert_valid u
  end
  
  def test_racist_blocks
    u = Post.new(:subject => "mick") # i feel the least bad for using this slur
    assert_not_valid u               # because I'm Irish
  end
  
  def test_racist_allows_others
    u = Post.new(:subject => "fucker")
    assert_valid u
  end
  
  def test_sexual_blocks
    u = Post.new(:post => "cocksucker")
    assert_not_valid u
  end
  
  def test_sexual_allows_others
    u = Post.new(:post => "mick") # again, I'm Irish
    assert_valid u
  end
  
  
end
