require File.dirname(__FILE__) + '/helper'

class MediaTypeTest < Test::Unit::TestCase

  M = Rack::Accept::MediaType

  def test_qvalue
    m = M.new('text/html, text/*;q=0.3, */*;q=0.5')
    assert_equal(0.5, m.qvalue('image/png'))
    assert_equal(0.3, m.qvalue('text/plain'))
    assert_equal(1, m.qvalue('text/html'))

    m = M.new('text/html')
    assert_equal(0, m.qvalue('image/png'))

    m = M.new('')
    assert_equal(1, m.qvalue('text/html'))
  end

  def test_matches
    m = M.new('text/*, text/html, text/html;level=1, */*')
    assert_equal(%w{*/*}, m.matches(''))
    assert_equal(%w{*/*}, m.matches('image/jpeg'))
    assert_equal(%w{text/* */*}, m.matches('text/plain'))
    assert_equal(%w{text/html text/* */*}, m.matches('text/html'))
    assert_equal(%w{text/html;level=1 text/html text/* */*}, m.matches('text/html;level=1'))
  end

end
