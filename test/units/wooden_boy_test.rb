#require 'test/test_helper'
require_relative '../test_helper'

class WoodenBoyTest < Minitest::Test

  def setup
    @pinocchio = Pinocchio::WoodenBoy.new
  end

  def test_should_answer_it_knows_nothing
    unknown_lie = Pinocchio::Lie.new({
      url:    '/nowhere',
      method: 'GET',
      params: {}
    })

    assert_nil @pinocchio.answer(unknown_lie)
  end

  def test_should_see_the_world_as_it_is_the_first_time
    @pinocchio.learn("test/fixtures/hello_world.yml")
    greetings_lie = Pinocchio::Lie.new({
      url:    '/hello_world',
      method: 'GET',
      params: {}
    })

    answer = @pinocchio.answer(greetings_lie)
    refute_nil answer
    assert_equal 'Hello World!', answer.response[:body]
  end

  def test_should_greet_as_a_real_boy
    @pinocchio.learn("test/fixtures/greetings.yml")
    greetings_lie = Pinocchio::Lie.new({
      url:    '/greetings',
      method: 'GET',
      params: {'name' => "Antonio Carlos"}
    })

    answer = @pinocchio.answer(greetings_lie)
    refute_nil answer
    assert_equal 'Hi, Antonio Carlos!', answer.response[:body]
  end
end
