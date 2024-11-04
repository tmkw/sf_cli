# sf_cli
A class library for introducing Salesforce CLI to Ruby scripting.
Currenty only sf command is the target of development.

current version: 1.2.4

## Documents
- [Class Library Reference](https://tmkw.github.io/sf_cli/)

## Examples
```ruby
  sf.org.login_web
  sf.data.get_record :Account, where: {Name: 'Jonny B.Good', Country: 'USA'}
  sf.apex.run file: 'path/to/file'
```
