require File.dirname(__FILE__) + '/helper'

class CharsetTest < Test::Unit::TestCase

  C = Rack::Accept::Charset

  def test_qvalue
    c = C.new('')
    assert_equal(0, c.qvalue('unicode-1-1'))
    assert_equal(1, c.qvalue('iso-8859-1'))

    c = C.new('unicode-1-1')
    assert_equal(1, c.qvalue('unicode-1-1'))
    assert_equal(0, c.qvalue('iso-8859-5'))
    assert_equal(1, c.qvalue('iso-8859-1'))

    c = C.new('unicode-1-1, *;q=0.5')
    assert_equal(1, c.qvalue('unicode-1-1'))
    assert_equal(0.5, c.qvalue('iso-8859-5'))
    assert_equal(0.5, c.qvalue('iso-8859-1'))

    c = C.new('iso-8859-1;q=0, *;q=0.5')
    assert_equal(0.5, c.qvalue('iso-8859-5'))
    assert_equal(0, c.qvalue('iso-8859-1'))

    c = C.new('*;q=0')
    assert_equal(0, c.qvalue('iso-8859-1'))
  end

  def test_matches
    c = C.new('iso-8859-1, iso-8859-5, *')
    assert_equal(%w{*}, c.matches(''))
    assert_equal(%w{iso-8859-1 *}, c.matches('iso-8859-1'))
    assert_equal(%w{*}, c.matches('unicode-1-1'))
  end

end
