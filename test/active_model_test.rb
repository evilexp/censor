#encoding: utf-8

require 'test_helper'

class ActiveModelTest < Test::Unit::TestCase

  def generate_new_class(name, options = {})
    Dummy.send(:remove_const, name) if Dummy.const_defined?(name)
    klass = Class.new(Dummy::BaseModel) do
      validates :body, options
    end
    Dummy.const_set(name, klass)
  end

  should 'be invalid when body contains invalid email' do
    klass = generate_new_class('Message', censor: true)
    post  = klass.new(body: 'The message contains email mail@gmail.com')
    assert !post.valid?
    assert post.errors.has_key?(:body)
    assert_equal ['Bad data'], post.errors[:body]
  end

  should 'be valid when body is valid' do
    klass = generate_new_class('Message', censor: true)
    post  = klass.new(body: 'The message is valid')
    assert post.valid?
  end

  should 'be valid when body is in whitelist' do
    klass = generate_new_class('Message', censor: true)
    post  = klass.new(body: 'The message contains email mail.mysite.com')
    assert post.valid?
  end

  should 'be invalid when body is in whitelist and contains invalid email' do
    klass = generate_new_class('Message', censor: true)
    post  = klass.new(body: 'The message contains email email mail@mysite.com and mail@gmail.com')
    assert !post.valid?
    assert post.errors.has_key?(:body)
    assert_equal ['Bad data'], post.errors[:body]
  end

  should 'be invalid when body is in blacklist' do
    klass = generate_new_class('Message', censor: true)
    post  = klass.new(body: 'The message contains skype number')
    assert !post.valid?
    assert post.errors.has_key?(:body)
    assert_equal ['Bad data'], post.errors[:body]
  end

  should 'be invalid when body is in blacklist with international word' do
    klass = generate_new_class('Message', censor: true)
    post  = klass.new(body: 'The message contains скайп number')
    assert !post.valid?
    assert post.errors.has_key?(:body)
    assert_equal ['Bad data'], post.errors[:body]
  end

end