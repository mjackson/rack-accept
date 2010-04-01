require File.dirname(__FILE__) + '/helper'

class RequestTest < Test::Unit::TestCase

  R = Rack::Accept::Request

  def test_media_type
    request = R.new('HTTP_ACCEPT' => 'text/*;q=0, text/html')
    assert(request.media_type?('text/html'))
    assert(request.media_type?('text/html;level=1'))
    assert(!request.media_type?('text/plain'))
    assert(!request.media_type?('image/png'))

    request = R.new('HTTP_ACCEPT' => '*/*')
    assert(request.media_type?('image/png'))
  end

  def test_best_media_type
    request = R.new('HTTP_ACCEPT' => 'text/*;q=0.5, text/html')
    assert_equal('text/html', request.best_media_type(%w< text/plain text/html >))
    assert_equal('text/plain', request.best_media_type(%w< text/plain image/png >))
    assert_equal('text/plain', request.best_media_type(%w< text/plain text/javascript >))
    assert_equal(nil, request.best_media_type(%w< image/png >))
  end

  def test_charset
    request = R.new('HTTP_ACCEPT_CHARSET' => 'iso-8859-5, unicode-1-1;q=0.8')
    assert(request.charset?('iso-8859-5'))
    assert(request.charset?('unicode-1-1'))
    assert(request.charset?('iso-8859-1'))
    assert(!request.charset?('utf-8'))

    request = R.new('HTTP_ACCEPT_CHARSET' => 'iso-8859-1;q=0')
    assert(!request.charset?('iso-8859-1'))
  end

  def test_best_charset
    request = R.new('HTTP_ACCEPT_CHARSET' => 'iso-8859-5, unicode-1-1;q=0.8')
    assert_equal('iso-8859-5', request.best_charset(%w< iso-8859-5 unicode-1-1 >))
    assert_equal('iso-8859-5', request.best_charset(%w< iso-8859-5 utf-8 >))
    assert_equal('iso-8859-1', request.best_charset(%w< iso-8859-1 utf-8 >))
    assert_equal(nil, request.best_charset(%w< utf-8 >))
  end

  def test_encoding
    request = R.new('HTTP_ACCEPT_ENCODING' => '')
    assert(request.encoding?('identity'))
    assert(!request.encoding?('gzip'))

    request = R.new('HTTP_ACCEPT_ENCODING' => 'gzip')
    assert(request.encoding?('identity'))
    assert(request.encoding?('gzip'))
    assert(!request.encoding?('compress'))

    request = R.new('HTTP_ACCEPT_ENCODING' => 'gzip;q=0, *')
    assert(request.encoding?('compress'))
    assert(request.encoding?('identity'))
    assert(!request.encoding?('gzip'))

    request = R.new('HTTP_ACCEPT_ENCODING' => 'identity;q=0')
    assert(!request.encoding?('identity'))

    request = R.new('HTTP_ACCEPT_ENCODING' => '*;q=0')
    assert(!request.encoding?('identity'))
  end

  def test_best_encoding
    request = R.new('HTTP_ACCEPT_ENCODING' => 'gzip, compress')
    assert_equal('gzip', request.best_encoding(%w< gzip compress >))
    assert_equal('identity', request.best_encoding(%w< identity compress >))
    assert_equal(nil, request.best_encoding(%w< zip >))
  end

  def test_language
    request = R.new({})
    assert(request.language?('en'))
    assert(request.language?('da'))

    request = R.new('HTTP_ACCEPT_LANGUAGE' => 'en;q=0.5, en-gb')
    assert(request.language?('en'))
    assert(request.language?('en-gb'))
    assert(!request.language?('da'))
  end

  def test_best_language
    request = R.new('HTTP_ACCEPT_LANGUAGE' => 'en;q=0.5, en-gb')
    assert_equal('en-gb', request.best_language(%w< en en-gb >))
    assert_equal('en', request.best_language(%w< en da >))
    assert_equal('en-us', request.best_language(%w< en-us en-au >))
    assert_equal(nil, request.best_language(%w< da >))
  end

end
