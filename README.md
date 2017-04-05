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

## Displaying progress bar

`json_ponyfill#json_decode` will take a long time when parsing large JSON.

Of course my code may be not sophisticated, but originally Vim Script is not
good for large processing.

In this case, consider to use `json_ponlyfill#json_decode(json, { 'progress': 1 })`
to display progress bar like below:

```
json_decode  50% [=========================.........................]
```

**NOTE:** Progress bar use `redraw` command to refresh itself. `redraw` command
wipe previously printed all echo message out.  See `:h redraw`, `:h messages`,
`:h echomsg`, and `:h echoerr` to learn more.

## Unit testing (For plugin developers)

`test/test.vim` is a bit useful snippet for unit testing.

```
:let g:json_ponyfill = 1 | source test/test.vim
```

## License

MIT License

(C) 2016-2017 Retorillo
