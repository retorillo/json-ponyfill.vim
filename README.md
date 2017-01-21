# json-ponyfill.vim

Provide `json_decode` and `json_encode` to the former version of VIM.

```viml
function! s:json_decode(json)
  if !exists("*json_decode")
    return json_ponyfill#json_decode(a:json)
  endif
  return json_decode(a:json)
endfunction

function! s:json_encode(json)
  if !exists("*json_encode")
    return json_ponyfill#json_encode(a:json)
  endif
  return json_encode(a:json)
endfunction
```

## Install (Pathogen)

```bash
git clone https://github.com/retorillo/json-ponyfill.vim ~/.vim/bundle/json-ponyfill.vim
```

## License

Distributed under the MIT license

Copyright (C) 2016-2017 Retorillo
