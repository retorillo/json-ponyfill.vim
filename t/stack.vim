describe "Stack"
  before
    let g:stack = [ "foo", "bar" ]
  end
  after
    unlet g:stack
  end
  it "json#stackpeek"
    Expect json_ponyfill#stackpeek(g:stack) == "bar"
  end
  it "json_ponyfill#stackpush"
    call json_ponyfill#stackpush(g:stack, "baz")
    Expect json_ponyfill#stackpeek(g:stack) == "baz"
  end
  it "json_ponyfill#stackpop"
    Expect json_ponyfill#stackpop(g:stack) == "bar"
    Expect len(g:stack) == 1
    Expect json_ponyfill#stackpop(g:stack) == "foo"
    Expect len(g:stack) == 0
    Expect json_ponyfill#stackpop(g:stack) == ""
  end
end
