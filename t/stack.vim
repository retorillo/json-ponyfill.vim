describe "Stack"
  before
    let g:stack = [ "foo", "bar" ]
  end
  after
    unlet g:stack
  end
  it "json#stackpeek"
    Expect retorillo#json#stackpeek(g:stack) == "bar"
  end
  it "retorillo#json#stackpush"
    call retorillo#json#stackpush(g:stack, "baz")
    Expect retorillo#json#stackpeek(g:stack) == "baz"
  end
  it "retorillo#json#stackpop"
    Expect retorillo#json#stackpop(g:stack) == "bar"
    Expect len(g:stack) == 1
    Expect retorillo#json#stackpop(g:stack) == "foo"
    Expect len(g:stack) == 0
    Expect retorillo#json#stackpop(g:stack) == ""
  end
end
