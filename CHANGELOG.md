## 1.3.0 - 2024-11-20
- NEW: new command support
    - `sf project deploy start`
    - `sf apex generate class`
    - `sf apex generate trigger`
    - `sf lightning generate component`
- CHANGE:
    - drop Object Model Support
    - drop command line interface

## 1.2.5 - 2024-11-17
- FIX: command line construction bug when using raw_output option

## 1.2.4 - 2024-11-04
- MISC: Schema class enhancement (SfCli::Sf::Sobject::Schema)

## 1.2.3 - 2024-11-03
- NEW: most of  org and project commands have `raw_output` option. When specifying this option, the methods returns the result formatted as same as the original command outputs.
- FIX: now sf.data.query shows errors when csv and human formatted output

## 1.2.2 - 2024-10-16
- NEW: `sf.data.query` can have block
- FIX: Object Model support functions
    - SQOL mistranslations of #not
    - nil was mistranslated in #where

## 1.2.1 - 2024-10-05
- NEW: -e option to sf_cli command to open vscode
- FIX: add some methods, which was lacked, to Schema class (SfCli::Sf::Sobject::Schema)
- MISC: document enhancement

## 1.2.0 - 2024-10-02
- CHANGE: `sf project` commands come back to supported. The following methods got back.
    - `sf.project.generate`
    - `sf.project.generate_manifest`
- NEW: new command support
    - `sf.project.retrieve_start`
- CHANGE: `sf_cli` command interface changed.
    - for using irb, type `sf_cli -i`
- NEW: to generate a project, type `sf_cli -g project PROJECT_NAME`. By typing `sf -g project PROJECT_NAME -o ORG_ALIAS -r`, you can also generate manifest file based on the target org and retrieve metadata at once.

## 1.1.0 - 2024-09-29
- NEW: add some command supports
  - `sf.org.list_metadata_types`
  - `sf.org.list_metadata`
  - `sf.org.list_limits`
- NEW: add a console command; `orgs`

## 1.0.0 - 2024-09-27
- NEW: `sf_cli` command that integrates both command and object model libraries into IRB.
- NEW: (document) command coverage list is added in online document
- Misc: starts semantic versioning

## 0.0.10 - 2024-09-25
made only Object Model enhanncements.

- NEW: `#to_csv`to get query result by csv format
- NEW: `#not` in query methods
- NEW: aggregate functions such as `#count`, `#min` and `#max`
- CHANGE: re-design Schema class
- Misc:
    - refactor `#pluck` for performance enhancement

## 0.0.9 - 2024-09-23
- CHANGE: [BREAKING] change keyword argument `timeout` to `wait` according to the original commands' specification;
    - `sf.data.query`
    - `sf.data.delete_bulk`
    - `sf.data.delete_resume`
    - `sf.data.upsert_bulk`
    - `sf.data.upsert_resume`
- NEW: `#find_by` method for object model
- NEW: `api_version` keyword argument is added to methods whose original commands have that option
- CHANGE: `file` keyword argument accepts IO-like object such as StringIO:
    - `sf.data.upsert_bulk`
    - `sf.data.delete_bulk`

## 0.0.8 - 2024-09-21
Maintenance Release: document enhancement

- CHANGE: document generator change from hanna-rdoc to yard
- NEW: new online document page: https://tmkw.github.io/sf_cli/
## 0.0.7 - 2024-09-19
- NEW: add `sf.apex.run`
## 0.0.6 - 2024-09-16
- NEW: Object Model Support renewal;
  - `SfCli::Sf::Model.connection` represents the connection to Salesforce. It can be set by `set_connection` class method in the module. As of now there is only `SfCommandConnection`, which is based on sf command, as connection adapter. After the connection is set by `set_connection`, it is also automatically set to classes when `SfCli::Sf::Model.generate` method is called.
  - Each object model class has `create` class method for creating a new record.
  - Each object model has `#save` and `#delete` instance methods to create, update and delete the record it represents.
  - Each object class has query interface such as `where`, `select`, `limit` and `order` methods that can be chainable.
  - Each object class has query interface such as `find`, `all`, `take` and `pluck`.
- CHANGE: `sf.sobject.describe` changed to return `schema` object.
## 0.0.5 - 2024-09-08
- CHANGE: target CLI version is changed: from 2.54.6 to 2.56.7
- NEW: new command features are added;
  - `--bulk` option to `sf.data.query`
  - `sf.data.query_resume`
  - `sf.data.upsert_bulk`
  - `sf.data.upsert_resume`
  - `sf.data.delete_bulk`
  - `sf.data.delete_resume`
  - `sf.data.resume`
  - `sf.data.search`
  - `sf.org.list`
  - `sf.login_access_token`
  - `--browser` option to `sf.login_web`
## 0.0.4 - 2024-09-02
- breaking change:
  - Sf class doesn't exist anymore. You can not write like `sf = SfCli::Sf.new`. Instead of that,  global `sf` method is introduced. You can directly type like `sf.org.display`, which is as almost same usability as the original command. 
- sf data query:
  - support child-parent relationship
  - support parent-children relationship
  - add `--result-format` option
- auto generation of \Object Model (experimental)
  - generates SF \Object Classes automatically
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
