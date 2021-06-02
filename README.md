# vspect

**vspect had been archived and no longer work. Use new V`s official command `v ast`**

inspect [vlang](https://github.com/vlang/v) source file

## Commands

- ast   : Print ast
- tokens: Print tokens

## Usage

```sh
# Print ast
vspect ast example.vv
# Print ast only specified function
vspect ast --fn=add example.vv
# Omit expr details
vspect ast --short-expr example.vv
```

## Installation

```
git clone git@github.com:zakuro9715/vspect && cd vspect
v . -prod
./vspect
```

## Development

- Using [z](https://github.com/zakuro9715/z)
