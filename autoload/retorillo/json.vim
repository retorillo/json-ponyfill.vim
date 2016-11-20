let s:ignoreCharacterPattern = "\\s"
let s:keywordStarterPattern = "\\c[_a-z]"
let s:keywordCharacterPattern = "\\c[_a-z0-9]"
let s:numberStarterPattern = "[0-9]"
let s:numberCharacterPattern = "[.0-9]"
let s:floatPattern = "\\v^[0-9]+(\\.[0-9]+)?$"
let s:integerPattern = "\\v^[0-9]+$"

function! s:stackpush(list, item)
  call add(a:list, a:item)
endfunction 
function! s:stackpeek(list)
  if !empty(a:list)
    return get(a:list, len(a:list) - 1)
  endif
  return ""
endfunction
function! s:stackpop(list)
  if !empty(a:list)
    let peek = s:stackpeek(a:list)
    call remove(a:list, len(a:list) - 1)
    return peek
  endif
  return ""
endfunction

function! retorillo#json#stackpush(list, item)
  return s:stackpush(a:list, a:item)
endfunction
function! retorillo#json#stackpeek(list)
  return s:stackpeek(a:list)
endfunction
function! retorillo#json#stackpop(list)
  return s:stackpop(a:list)
endfunction

function! s:parsestring(json, from)
    if a:json[a:from] != '"'
      throw '" is expected'
    endif
    let l = strlen(a:json)
    let i = a:from + 1
    let e = 0
    let b = ""
    while i < l
      let c = a:json[i]
      if e == 1
        let b = b . c
        let e = 0
      elseif c == '"'
        return { "value": b, "index": i }
      elseif c == "\\"
        let e = 1
      else
        let b = b . c
      endif
      let i = i + 1
    endwhile
    throw '" is unclosed'
endfunction
function! s:parsearray(json, from)
  if a:json[a:from] != "["
    throw "[ is expected"
  endif
  let l = strlen(a:json)
  let i = a:from + 1
  let s = []
  while i < l
    let c = a:json[i]
    if c == "]"
      let r = []
      while !empty(s)
        if !empty(r)
          let comma = s:stackpop(s)
          if comma != ","
            throw ", is expected"
          endif
        endif
        call insert(r, s:stackpop(s), 0)
      endwhile
      return { "value": r, "index": i }
    elseif c == ","
      call s:stackpush(s, c)
    else
      if matchstr(c, s:ignoreCharacterPattern) == ""
        let p = s:parsejson(a:json, i)
        call add(s, p["value"])
        let i = p["index"]
      endif
    endif
    let i = i + 1
  endwhile
  throw "] is expected"
endfunction
function! s:parseobject(json, from)
  if a:json[a:from] != "{"
    throw "{ is expected"
  endif
  let l = strlen(a:json)
  let i = a:from + 1
  let s = []
  while i < l
    let c = a:json[i]
    if c == "}"
      let r = {}
      while !empty(s)
        if !empty(r)
          let comma = s:stackpop(s)
          if !comma["token"] || comma["value"] != ","
            throw ", is expected"
          endif
        endif
        if len(s) < 3
          throw "'". s:stackpeek(s)["value"] .'" is unexpeted'
        endif
        let value = s:stackpop(s)
        let colon = s:stackpop(s)
        let name = s:stackpop(s)
        if !colon["token"] || colon["value"] != ":"
          throw 'colon is expected before "'.colon["value"]"\""
        endif
        if name["token"] || type(name["value"]) != 1
          throw name["value"].' is unexpected'
        endif
        let r[name["value"]] = value["value"] 
      endwhile
      return { "value": r, "index": i }
    elseif matchstr(c, "[:,]") != ""
      call s:stackpush(s, { "token": 1, "value": c, "index": i })
    else
      if matchstr(c, s:ignoreCharacterPattern) == ""
        let p = s:parsejson(a:json, i)
        let i = p["index"]
        call s:stackpush(s, { "token": 0, "value": p["value"], "index": i })
      endif
    endif
    let i = i + 1
  endwhile
  throw "} is expected"
endfunction
function! s:parsenumber(json, from)
  let l = strlen(a:json)
  let i = a:from
  let b = ""
  while i < l
    let c = a:json[i]
    if matchstr(c, s:numberCharacterPattern) == ""
      break
    endif
    let b = b . c
    let i = i + 1
  endwhile
  if matchstr(b, s:integerPattern) != ""
    let v = str2nr(b)
  elseif matchstr(b, s:floatPattern) != ""
    let v = str2float(b)
  else
    throw "invalid number format: " . b
  endif
  return { "value": v, "index": i - 1 }
endfunction
function! s:parsekeyword(json, from)
  let l = strlen(a:json)
  let i = a:from
  let b = ""
  while i < l
    let c = a:json[i]
    if matchstr(c, s:keywordCharacterPattern) == ""
      break
    endif
    let b = b . c
    let i = i + 1
  endwhile
  if matchstr(b, "^true$") != ""
    let v = 1
  elseif matchstr(b, "\\v^(false|null)$") != ""
    let v = 0
  else
    throw "unkown identifier: ".b
  endif
    return { "value": v, "index": i - 1 }
  endif
endfunction
function! s:parsejson(json, from)
  let l = strlen(a:json)
  let i = a:from
  while i < l
    let c = a:json[i]
    if c == "{"
      return s:parseobject(a:json, i)
    elseif c == "["
      return s:parsearray(a:json, i)
    elseif c == '"'
      return s:parsestring(a:json, i)
    elseif matchstr(c, s:numberStarterPattern) != ""
      return s:parsenumber(a:json, i)
    elseif matchstr(c, s:keywordStarterPattern) != ""
      return s:parsekeyword(a:json, i)
    else
      if matchstr(c, s:ignoreCharacterPattern) == ""
        throw "unexpected character: ". c . " (index: ". i .")"
      endif
    endif
    let i = i + 1
  endwhile
  throw "invalid format"
endfunction

function! retorillo#json#parse(json)
  return s:parsejson(a:json, 0)["value"]
endfunction
