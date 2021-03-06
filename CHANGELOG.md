# Changelog

## [v0.4.2](https://github.com/mvgijssel/arel_toolkit/tree/v0.4.2) (2020-01-08)

[Full Changelog](https://github.com/mvgijssel/arel_toolkit/compare/v0.4.1...v0.4.2)

**Breaking changes:**

- Remove path, inline visit and improve recursion for improved performance [\#152](https://github.com/mvgijssel/arel_toolkit/pull/152) ([Willianvdv](https://github.com/Willianvdv))

**Implemented enhancements:**

- Validate whether setting a session variable transformation does the right thing [\#155](https://github.com/mvgijssel/arel_toolkit/issues/155)
- Add ability to mutate nodes with precomputed Arel::Nodes::Enhance [\#158](https://github.com/mvgijssel/arel_toolkit/pull/158) ([mvgijssel](https://github.com/mvgijssel))

## [v0.4.1](https://github.com/mvgijssel/arel_toolkit/tree/v0.4.1) (2019-11-13)

[Full Changelog](https://github.com/mvgijssel/arel_toolkit/compare/v0.4.0...v0.4.1)

**Implemented enhancements:**

- Create a transformer that replaces a table reference with a subquery [\#141](https://github.com/mvgijssel/arel_toolkit/issues/141)
- Same signature for all middleware helpers [\#135](https://github.com/mvgijssel/arel_toolkit/issues/135)
- Instantiate PG::Result object instead of duck typed object [\#130](https://github.com/mvgijssel/arel_toolkit/issues/130)
- Add `to\_sql` to Arel.middleware which prints the sql after middleware processing [\#127](https://github.com/mvgijssel/arel_toolkit/issues/127)
- Extend Middleware to include the response from the database [\#126](https://github.com/mvgijssel/arel_toolkit/issues/126)
- Extend AddSchemaToTable to support multiple schemas and regclass typecasts [\#124](https://github.com/mvgijssel/arel_toolkit/issues/124)
- Optional context argument for Arel middleware [\#110](https://github.com/mvgijssel/arel_toolkit/issues/110)
- Handle is\_rowsfrom in pg\_query\_visitor\#visit\_RangeFunction [\#36](https://github.com/mvgijssel/arel_toolkit/issues/36)
- Bump nokogiri from 1.10.3 to 1.10.4 [\#132](https://github.com/mvgijssel/arel_toolkit/pull/132) ([dependabot[bot]](https://github.com/apps/dependabot))

**Fixed bugs:**

- Bundle install fails with missing arel\_toolkit/pg\_result\_init [\#148](https://github.com/mvgijssel/arel_toolkit/issues/148)
- Handle column reference with 3 \(or more\) fields [\#145](https://github.com/mvgijssel/arel_toolkit/issues/145)
- Error when aliasing a range select  [\#144](https://github.com/mvgijssel/arel_toolkit/issues/144)
- Make sure the method signatures of PostgreSQLAdapter match [\#122](https://github.com/mvgijssel/arel_toolkit/issues/122)
- Fix missing middleware method and fix \(again\) infinite middleware recursion [\#120](https://github.com/mvgijssel/arel_toolkit/issues/120)
- Use named window with OVER. [\#149](https://github.com/mvgijssel/arel_toolkit/pull/149) ([khaleksa](https://github.com/khaleksa))

## [v0.4.0](https://github.com/mvgijssel/arel_toolkit/tree/v0.4.0) (2019-07-31)

[Full Changelog](https://github.com/mvgijssel/arel_toolkit/compare/v0.3.0...v0.4.0)

**Implemented enhancements:**

- Replace Arel::Nodes::UnboundColumnReference with Arel::Nodes::UnqualifiedColumn [\#91](https://github.com/mvgijssel/arel_toolkit/issues/91)
- Add brakeman to check for security vulnerabilities [\#10](https://github.com/mvgijssel/arel_toolkit/issues/10)
- Rename Arel.transformer to Arel.enhance [\#111](https://github.com/mvgijssel/arel_toolkit/issues/111)
- Ability to query an Arel transformer tree [\#103](https://github.com/mvgijssel/arel_toolkit/issues/103)
- Implement PREPARE and DEALLOCATE statement [\#101](https://github.com/mvgijssel/arel_toolkit/issues/101)
- Create Arel transformer class to safely and easily mutate an Arel AST [\#89](https://github.com/mvgijssel/arel_toolkit/issues/89)
- Test and verify compatibility with Arel extension gems [\#81](https://github.com/mvgijssel/arel_toolkit/issues/81)
- Automatically load Railtie when gem is included in Rails [\#66](https://github.com/mvgijssel/arel_toolkit/issues/66)
- Create remove ActiveRecord specifics transformer [\#63](https://github.com/mvgijssel/arel_toolkit/issues/63)

**Fixed bugs:**

- TypeError: superclass mismatch for class Overlap [\#93](https://github.com/mvgijssel/arel_toolkit/issues/93)

## [v0.3.0](https://github.com/mvgijssel/arel_toolkit/tree/v0.3.0) (2019-07-01)

[Full Changelog](https://github.com/mvgijssel/arel_toolkit/compare/v0.2.0...v0.3.0)

**Implemented enhancements:**

- Implement Functions and Operators from PostgreSQL docs [\#84](https://github.com/mvgijssel/arel_toolkit/issues/84)
- Implement more missing operators and visitors [\#82](https://github.com/mvgijssel/arel_toolkit/issues/82)
- Improve error message when unable to parse sql to arel [\#71](https://github.com/mvgijssel/arel_toolkit/issues/71)
- Publish coverage information to GitHub pages [\#64](https://github.com/mvgijssel/arel_toolkit/issues/64)
- Add ActiveRecord comparison testing [\#61](https://github.com/mvgijssel/arel_toolkit/issues/61)
- Make Arel::TreeManager equal to other trees [\#59](https://github.com/mvgijssel/arel_toolkit/issues/59)
- Add support for Arel.middleware [\#52](https://github.com/mvgijssel/arel_toolkit/issues/52)
- Handle multiple tree entries in pg\_query\_visitor\#accept [\#33](https://github.com/mvgijssel/arel_toolkit/issues/33)

**Fixed bugs:**

- Fix invalid generated SQL, add missing visitors and extend operators [\#79](https://github.com/mvgijssel/arel_toolkit/issues/79)
- Fix handling of equality with Arel::Nodes::Quoted [\#77](https://github.com/mvgijssel/arel_toolkit/issues/77)
- Fix default values for Delete- and UpdateStatement [\#75](https://github.com/mvgijssel/arel_toolkit/issues/75)
- Unknown operator `` for IN statement [\#73](https://github.com/mvgijssel/arel_toolkit/issues/73)
- NameError: undefined local variable or method `number' for \#\<Arel::SqlToArel::PgQueryVisitor:0x000055dfdd14c6f8\> [\#69](https://github.com/mvgijssel/arel_toolkit/issues/69)
- Make compatible with postgres\_ext [\#67](https://github.com/mvgijssel/arel_toolkit/issues/67)

**Closed issues:**

- File issues for commented out rspec test [\#51](https://github.com/mvgijssel/arel_toolkit/issues/51)

## [v0.2.0](https://github.com/mvgijssel/arel_toolkit/tree/v0.2.0) (2019-05-30)

[Full Changelog](https://github.com/mvgijssel/arel_toolkit/compare/v0.1.0...v0.2.0)

**Implemented enhancements:**

- Handle op in pg\_query\_visitor\#visit\_SelectStmt [\#38](https://github.com/mvgijssel/arel_toolkit/issues/38)
- Introduce Guard [\#5](https://github.com/mvgijssel/arel_toolkit/issues/5)
- Add WITH, OVERRIDING and RETURNING to INSERT [\#28](https://github.com/mvgijssel/arel_toolkit/issues/28)
- Return \(Select|Update|Insert|Delete\)Manager instead of \(Select|Update|Insert|Delete\)Statement [\#25](https://github.com/mvgijssel/arel_toolkit/issues/25)
- Implement UNION in sql\_to\_arel [\#24](https://github.com/mvgijssel/arel_toolkit/issues/24)
- Extract Arel extensions to their own files [\#23](https://github.com/mvgijssel/arel_toolkit/issues/23)
- Implement pg\_query\_visitor method for DELETE [\#22](https://github.com/mvgijssel/arel_toolkit/issues/22)
- Implement pg\_query\_visitor method for INSERT [\#21](https://github.com/mvgijssel/arel_toolkit/issues/21)
- Implement pg\_query\_visitor method for UPDATE [\#20](https://github.com/mvgijssel/arel_toolkit/issues/20)
- Implement all the visitor methods in PgQueryVisitor for SELECT statements [\#11](https://github.com/mvgijssel/arel_toolkit/issues/11)
- 22/implement delete [\#30](https://github.com/mvgijssel/arel_toolkit/pull/30) ([mvgijssel](https://github.com/mvgijssel))
- Added WITH, OVERRIDING and RETURINING to INSERT [\#29](https://github.com/mvgijssel/arel_toolkit/pull/29) ([mvgijssel](https://github.com/mvgijssel))
- Added badges to README \(and fix setup\) [\#3](https://github.com/mvgijssel/arel_toolkit/pull/3) ([mvgijssel](https://github.com/mvgijssel))
- Configure codeclimate [\#2](https://github.com/mvgijssel/arel_toolkit/pull/2) ([mvgijssel](https://github.com/mvgijssel))
- Updated travis file [\#1](https://github.com/mvgijssel/arel_toolkit/pull/1) ([mvgijssel](https://github.com/mvgijssel))

**Fixed bugs:**

- Fix CodeClimate coverage [\#8](https://github.com/mvgijssel/arel_toolkit/issues/8)

**Closed issues:**

- Remove unnecessary to\_arel remains [\#15](https://github.com/mvgijssel/arel_toolkit/issues/15)
- Merge to\_arel gem [\#4](https://github.com/mvgijssel/arel_toolkit/issues/4)
- Create issues for unknown branches in pg\_query\_visitor [\#19](https://github.com/mvgijssel/arel_toolkit/issues/19)



\* *This Changelog was automatically generated by [github_changelog_generator](https://github.com/github-changelog-generator/github-changelog-generator)*
