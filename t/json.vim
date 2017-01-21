describe "json_encode"
  it "encode string"
    Expect "\\n" == '\n'
    Expect substitute('foo\n', '\n', '\\n', 'g') == 'foo\n'
    Expect json_ponyfill#json_encode("foo\n") == "\"foo\\n\"" 
  end
  it "encode number"
    Expect json_ponyfill#json_encode(12) == '12'
    Expect json_ponyfill#json_encode(12.345) == '12.345'
  end
  it "encode array"
    Expect json_ponyfill#json_encode(['foo', 'bar', 'baz']) == '["foo","bar","baz"]'
  end
  it "encode nested array"
    Expect json_ponyfill#json_encode(['foo', 'bar', ['baz', 'foobar']]) == '["foo","bar",["baz","foobar"]]'
  end
  it "encode empty object"
    Expect json_ponyfill#json_encode({}) ==  "{}"
  end
  it "encode simple object"
    Expect json_ponyfill#json_encode({"foo": "bar"}) ==  '{"foo":"bar"}'
  end
  it "encode nested object"
    Expect json_ponyfill#json_encode({
     \ 'foo': ['bar', [1, 2, 3] , { 'foobar': 12.345 }]
     \ }) == '{"foo":["bar",[1,2,3],{"foobar":12.345}]}'
  end
end

describe "json_decode"
  it "decode string"
    Expect json_ponyfill#json_decode('"foo"') == "foo"
  end
  it "decode number"
    Expect json_ponyfill#json_decode("12") == 12
    Expect json_ponyfill#json_decode("12.345") == 12.345
  end
  it "decode boolean"
    Expect json_ponyfill#json_decode("true") == 1
    Expect json_ponyfill#json_decode("false") == 0
  end
  it "decode array"
    Expect json_ponyfill#json_decode('["foo", "bar", "baz"]')
      \ == ["foo", "bar", "baz"]
    Expect json_ponyfill#json_decode('[1, 2, 3]')
      \ == [1, 2, 3]
  end
  it "decode object"
    Expect json_ponyfill#json_decode('{ "foo": "bar" }')
      \ == { "foo": "bar" }
    Expect json_ponyfill#json_decode('{ "foo": { "bar": "baz" } }')
      \ == { "foo": { "bar": "baz" } }
    Expect json_ponyfill#json_decode('{ "foo" : { "bar" : "baz", "baz": [ 1, 2, 3 ] } }')
      \ == { "foo": { "bar": "baz", "baz": [1, 2, 3] } }
  end
  it "decode object (Failing)"
    let exception = ""
    try
      call json_ponyfill#json_decode('{ "foo" ":" "baz" }')
    catch /^colon is expected/
      let exception = v:exception
    finally
      Expect exception != ""
    endtry
  end
end
