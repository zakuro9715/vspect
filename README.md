# vspect

**vspect had been archived and no longer work. Use V's [vast](https://github.com/vlang/v/tree/ba86d619fa41fded96391b712eaa00c5db0a57a4/cmd/tools/vast)**

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
