# simpleyaml.lua

Very simple [YAML](https://yaml.org/) parser written in Lua.

Features:

- understands a "useful" subset of YAML
- parses correct files
  - line-based parser, each line needs to contain a key
  - almost no error handling
- no dependencies
- single-file

## Example

Input:

```yaml
---

# Example

someExample:
  someKey: Here is some string
  anotherKey: 42
  subExample1:
    foo: bar
  subExample2:
    hello: world

anotherExample:
  thats: it
```

Output:

```
{
  anotherExample = {
    thats = "it"
  },
  someExample = {
    anotherKey = "42",
    someKey = "Here is some string",
    subExample1 = {
      foo = "bar"
    },
    subExample2 = {
      hello = "world"
    }
  }
}
```

## Documentation

Example usage:

```lua
simpleyaml = require("simpleyaml.lua")
local parsed = simpleyaml.parse_file("path/to/file.yaml")
```

Functions:

- `parse_file(path)`
  Takes a `path` to a YAML file and returns a table representing the key-value pairs in the file.
  No type conversions are performed, there are only strings.
  May return `nil` in case of error.

