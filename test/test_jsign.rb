# encoding: utf-8

require 'json'

require 'test/helper'
require 'jsign'

class TestJsign < Test::Unit::TestCase
  
  def dummykey
    File.join("test", "dummykey.pem")
  end


  def dummypub
    File.join("test", "dummypub.pem")
  end


  def test_retains_data
    json = '{"a":1}'
    assert Jsign.sign(json, dummykey).start_with?(json[0...-1])
  end

  
  def test_embeds_sig
    json = '{"a":1}'
    assert_match( /,"_jsign":"/, 
                  Jsign.sign(json, dummykey) )
  end


  def test_is_valid_json
    json = '{"a":1}'
    assert_nothing_raised{ JSON.load(json) }
    assert_nothing_raised do
      JSON.load(Jsign.sign(json, dummykey))
    end
  end
  
  
  def test_carries_sig
    json = '{"a":1}'
    jsigned = Jsign.sign(json, dummykey)

    obj = JSON.load(jsigned)
    assert obj.has_key?("_jsign")
  end


  def test_carries_sig_contents
    json = '{"a":1}'
    jsigned = Jsign.sign(json, dummykey)

    obj = JSON.load(jsigned)
    assert !obj["_jsign"].empty?
    
  end


  def test_verifies
    json = '{"a":1}'
    jsigned = Jsign.sign(json, dummykey)
    assert( Jsign.verify(jsigned, dummypub), 
            "Valid data fails to verify!" )
  end


  def test_doesnt_verify_altered
    json = '{"a":1}'
    jsigned = Jsign.sign(json, dummykey)
    jsigned[2] = "b"

    assert( !Jsign.verify(jsigned, dummypub),
            "An altered message was verified!" )
  end

end # class TestJsign
