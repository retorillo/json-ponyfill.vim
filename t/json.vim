describe "JSON Parse"
  it "String"
    Expect retorillo#json#parse('"foo"') == "foo"
  end
  it "Number"
    Expect retorillo#json#parse("12") == 12
    Expect retorillo#json#parse("12.345") == 12.345
  end
  it "Boolean"
    Expect retorillo#json#parse("true") == 1
    Expect retorillo#json#parse("false") == 0
  end
  it "Array"
    Expect retorillo#json#parse('["foo", "bar", "baz"]')
      \ == ["foo", "bar", "baz"]
    Expect retorillo#json#parse('[1, 2, 3]')
      \ == [1, 2, 3]
  end
  it "Object"
    Expect retorillo#json#parse('{ "foo": "bar" }')
      \ == { "foo": "bar" }
    Expect retorillo#json#parse('{ "foo": { "bar": "baz" } }')
      \ == { "foo": { "bar": "baz" } }
    Expect retorillo#json#parse('{ "foo" : { "bar" : "baz", "baz": [ 1, 2, 3 ] } }')
      \ == { "foo": { "bar": "baz", "baz": [1, 2, 3] } }
  end
  it "Object (Failing)"
    let exception = ""
    try
      call retorillo#json#parse('{ "foo" ":" "baz" }')
    catch /^colon is expected/
      let exception = v:exception
    finally
      Expect exception != ""
    endtry
  end
end
