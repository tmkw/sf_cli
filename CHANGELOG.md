## 0.0.4 - 2024-09-02
- breaking change:
  - Sf class doesn't exist anymore. You can not write like `sf = SfCli::Sf.new`. Instead of that,  global `sf` method is introduced. You can directly type like `sf.org.display`, which is as almost same usability as the original command. 
- sf data query:
  - support child-parent relationship
  - support parent-children relationship
  - add `--result-format` option
- auto generation of Object Model (experimental)
  - generates SF Object Classes automatically
  - relationship is supported

## 0.0.3 - 2024-08-25
add command operations:

- sf data get record
- sf data create record
- sf data update record
- sf data delete record

## 0.0.2 - 2024-08-18
this version up was made by mistake.
nothing was changed.

## 0.0.1 - 2024-08-18
support some command operations:

- sf org login web
- sf display
- sf data query
- sf sobject describe
- sf sobject list
- sf project generate
- sf project generate manifest
