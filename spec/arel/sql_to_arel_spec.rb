describe 'Arel.sql_to_arel' do
  visit 'select', 'ARRAY[1, 2, 3]'
  visit 'select', '1'
  visit 'select', '1 = 2'
  visit 'select', "3 = ANY('{4,5}'), 'a' = ANY($1)"
  visit 'select', "6 = ALL('{7,8}'), 'b' = ALL($1)"
  visit 'select', '"c" IS DISTINCT FROM "d", 7 IS NOT DISTINCT FROM \'d\''
  visit 'select', "NULLIF(9, 10), NULLIF('e', 'f')"
  visit 'select', "11 IN (12), 'a' NOT IN ('b')"
  visit 'select', "'ghi' NOT LIKE 'gh%', 'ghi' LIKE '_h_' ESCAPE 'i'"
  visit 'select', "'jkl' NOT ILIKE 'jk%', 'jkl' ILIKE '_k_' ESCAPE 'k'"
  visit 'select', "'mn' SIMILAR TO '(m|o)' ESCAPE '_', 'mn' NOT SIMILAR TO '_h{1}%' ESCAPE '_'"
  visit 'select', "'mn' SIMILAR TO '(m|o)', 'mn' NOT SIMILAR TO '_h{1}%'"
  visit 'select', '14 BETWEEN 13 AND 15'
  visit 'select', '16 NOT BETWEEN 17 AND 18'
  visit 'select', '20 BETWEEN SYMMETRIC 21 AND 19, 22 NOT BETWEEN SYMMETRIC 24 AND 23'
  visit 'select', '"field"[1]'
  visit 'select', '"something"[1]'
  visit 'select', '*'
  visit 'sql', 'GRANT INSERT, UPDATE ON mytable TO myuser',
        sql_to_arel: false
  visit 'select', '1 FROM "a" "b"'
  visit 'sql', 'ALTER TABLE stuff ADD COLUMN address text',
        sql_to_arel: false
  visit 'sql', 'ALTER TABLE stuff ADD COLUMN address text',
        sql_to_arel: false
  visit 'select', "B'0101'"
  visit 'select', '1 WHERE (1 AND 2) OR ("a" AND (NOT ("b")))',
        expected_sql: 'SELECT 1 WHERE ((1 AND 2) OR ("a" AND (NOT ("b"))))'
  visit 'select', '1 IS TRUE'
  visit 'select', '"a" IS NOT TRUE'
  visit 'select', "'a' IS FALSE"
  visit 'select', '$1 IS NOT FALSE'
  visit 'select', "'t'::bool IS UNKNOWN"
  visit 'select', '9.0 IS NOT UNKNOWN'
  visit 'select', 'CASE WHEN "a" = "b" THEN 2 = 2 WHEN "a" THEN \'b\' ELSE 1 = 1 END'
  visit 'select', "CASE \"field\" WHEN \"a\" THEN 1 WHEN 'b' THEN 0 ELSE 2 END"
  visit 'sql', 'CHECKPOINT', sql_to_arel: false
  visit 'sql', 'CLOSE cursor;', sql_to_arel: false
  visit 'select', "COALESCE(\"a\", NULL, 2, 'b')"
  # https://github.com/mvgijssel/arel_toolkit/issues/54
  # visit 'sql', 'SELECT a COLLATE "C"', sql_to_arel: false
  visit 'sql', 'CREATE TABLE a (column_def_column text)',
        sql_to_arel: false
  visit 'select', '"id"'
  visit 'select', '"posts"."id"'
  visit 'select', '"public"."posts"."id"'
  visit 'select', '"database"."public"."posts"."id"'
  visit 'sql',
        'WITH "a" AS (SELECT 1) ' \
        'SELECT * FROM (WITH RECURSIVE "c" AS (SELECT 1) SELECT * FROM "c") AS "d"'
  visit 'sql', 'CREATE TABLE a (b integer NOT NULL)',
        sql_to_arel: false
  visit 'sql', 'COPY reports TO STDOUT', sql_to_arel: false
  visit 'sql', "CREATE FUNCTION a(integer) RETURNS integer AS 'SELECT $1;' LANGUAGE SQL;",
        sql_to_arel: false
  visit 'sql', 'CREATE SCHEMA secure', sql_to_arel: false
  visit 'sql', 'CREATE TABLE a (b integer)', sql_to_arel: false
  visit 'sql', 'CREATE TABLE a AS (SELECT * FROM reports)',
        sql_to_arel: false
  visit 'sql', 'CREATE UNLOGGED TABLE a AS (SELECT * FROM reports)',
        sql_to_arel: false
  visit 'sql', 'CREATE TEMPORARY TABLE a AS (SELECT * FROM reports)',
        sql_to_arel: false
  visit 'sql', 'CREATE TRIGGER a AFTER INSERT ON b FOR EACH ROW EXECUTE PROCEDURE b()',
        sql_to_arel: false
  visit 'sql', 'DO $$ a $$', sql_to_arel: false
  visit 'sql',
        'WITH "some_delete_query" AS (SELECT 1 AS "some_column") ' \
        'DELETE FROM ONLY "a" "some_table" ' \
        'USING "other_table", "another_table" ' \
        'WHERE "other_table"."other_column" = 1.0 ' \
        'RETURNING *, "some_delete_query"."some_column"'
  visit 'sql', 'DELETE FROM "a" WHERE CURRENT OF some_cursor_name'
  visit 'sql', 'DELETE FROM "a" WHERE "a"."id" IN (SELECT 2)'
  visit 'sql', 'DELETE FROM "a"'
  # https://github.com/mvgijssel/arel_toolkit/issues/55
  # visit 'sql', 'DISCARD ALL', sql_to_arel: false
  visit 'sql', 'DO $$ a $$', sql_to_arel: false
  visit 'sql', 'DROP TABLE some_tablr', sql_to_arel: false
  visit 'sql', 'EXECUTE some_prepared_statement', sql_to_arel: false
  visit 'sql', 'EXPLAIN SELECT 1', sql_to_arel: false
  visit 'sql', 'FETCH some_cursor', sql_to_arel: false
  visit 'sql', 'PREPARE some_plan (integer) AS (SELECT $1)'
  visit 'sql', 'PREPARE some_plan AS (SELECT $1)'
  visit 'sql', 'DEALLOCATE some_prepared_statement'
  visit 'sql', 'DEALLOCATE ALL'
  visit 'select', '1.9'
  visit 'select', 'SUM("a") AS "some_a_sum"'
  visit 'select', 'rank("b")'
  visit 'select', 'public.rank("c")'
  visit 'select', 'pg_catalog.obj_description("c", \'pg_class\')'
  visit 'select', 'COUNT("c")'
  visit 'select', 'generate_series(1, 5)'
  visit 'select', 'MAX("d")'
  visit 'select', 'MIN("e")'
  visit 'select', 'AVG("f")'
  visit 'select', 'SUM("a" ORDER BY "id", "a" DESC)'
  visit 'select', 'SUM("a") FILTER(WHERE "a" = 1)'
  visit 'select', 'SUM("a") WITHIN GROUP (ORDER BY "a")'
  visit 'select', 'mleast(VARIADIC ARRAY[10, -1, 5, 4.4])'
  visit 'select', 'COUNT(DISTINCT "some_column")'
  visit 'select', "\"posts\".\"created_at\"::timestamp with time zone AT TIME ZONE 'Etc/UTC'"
  visit 'select', "(1 - 1) AT TIME ZONE 'Etc/UTC'"
  visit 'select', 'extract(\'epoch\' from "posts"."created_at")', sql_to_arel: false
  visit 'select', 'extract(\'hour\' from "posts"."updated_at")', sql_to_arel: false
  visit 'select',
        "('2001-02-1'::date, '2001-12-21'::date) OVERLAPS ('2001-10-30'::date, '2002-10-30'::date)"
  visit 'select', 'some_function("a", \'b\', 1)'
  visit 'select', "position('content'::text in 'some content')"
  visit 'select', "overlay('Txxxxas' placing 'hom' from 2 for 4)"
  visit 'select', "overlay('stuff' placing 'ing' from 3)"
  visit 'select', "substring('Thomas' from 2 for 3)"
  visit 'select', "substring('Thomas' from '...$')"
  visit 'select', "substring('Thomas' from '%#\"o_a#\"_' for '#')"
  visit 'select', "trim(both 'xyz')"
  visit 'select', "trim(leading 'yx' from 'yxTomxx')"
  visit 'select', "trim(trailing 'xx' from 'yxTomxx')"
  visit 'select', 'some_func(*)'
  visit 'sql', "CREATE FUNCTION a(integer) RETURNS integer AS 'SELECT $1;' LANGUAGE SQL;",
        sql_to_arel: false
  visit 'sql', 'GRANT some_admins TO some_users',
        sql_to_arel: false
  visit 'sql', 'GRANT SELECT ON some_table TO some_users',
        sql_to_arel: false
  visit 'sql', 'CREATE INDEX some_index ON some_table USING GIN (some_column)',
        sql_to_arel: false
  visit 'sql', 'CREATE INDEX some_index ON some_table (some_column)',
        sql_to_arel: false
  visit 'sql',
        'INSERT INTO "t" ("a", "b", "c", "d") ' \
        'OVERRIDING SYSTEM VALUE ' \
        'VALUES (1, "a", \'c\', \'t\'::bool, 2.0, $1) ' \
        'RETURNING *, "some_column" AS "some_column_alias"'
  visit 'sql',
        'WITH RECURSIVE "a" AS (SELECT "some_table"."a" FROM "some_table") ' \
        'INSERT INTO "t" OVERRIDING USER VALUE VALUES (1)'
  visit 'sql', 'INSERT INTO "t" VALUES (1)'
  visit 'sql', 'INSERT INTO "t" DEFAULT VALUES'
  visit 'sql', 'INSERT INTO "t" VALUES (1) ON CONFLICT DO NOTHING'
  visit 'sql',
        'INSERT INTO "t" VALUES (1) ON CONFLICT DO UPDATE ' \
        'SET "a" = 1, "b" = DEFAULT, "c" = (SELECT 1) ' \
        'WHERE 2 = 3 ' \
        'RETURNING *'
  visit 'sql',
        'INSERT INTO "t" VALUES (1) ON CONFLICT ON CONSTRAINT constraint_name DO UPDATE SET "a" = 1'
  visit 'sql',
        'INSERT INTO "t" VALUES (1) ON CONFLICT ("a", "b") DO UPDATE SET "a" = 1'
  # https://github.com/mvgijssel/arel_toolkit/issues/56
  # visit 'sql', '???', sql_to_arel: false
  visit 'select', '1'
  visit 'sql', 'SELECT INTO TEMPORARY "a_table" FROM "posts"'
  visit 'sql', 'SELECT INTO UNLOGGED "a_table" FROM "posts"'
  visit 'sql', 'SELECT INTO "a_table" FROM "posts"'
  visit 'select', '* FROM "a" INNER JOIN "b" ON 1 = 1'
  visit 'select', '* FROM "a" LEFT OUTER JOIN "c" ON 1 = 1'
  visit 'select', '* FROM "a" FULL OUTER JOIN "d" ON 1 = 1'
  visit 'select', '* FROM "a" RIGHT OUTER JOIN "e" ON 1 = 1'
  visit 'select', '* FROM "a" CROSS JOIN "f"'
  visit 'select', '* FROM "a" NATURAL JOIN "g"'
  visit 'sql', 'LOCK TABLE some_table IN SHARE MODE;',
        sql_to_arel: false
  visit 'select', '1 FOR UPDATE NOWAIT'
  visit 'select', '1 FOR NO KEY UPDATE NOWAIT'
  visit 'select', '1 FOR SHARE SKIP LOCKED'
  visit 'select', '1 FOR KEY SHARE'
  visit 'select', 'LEAST(1, "a", \'2\'), GREATEST($1, \'t\'::bool, NULL)'
  visit 'select', 'NULL'
  visit 'select', '"a" IS NULL AND \'b\' IS NOT NULL'
  # https://github.com/mvgijssel/arel_toolkit/issues/57
  # visit 'sql', '???', sql_to_arel: false
  visit 'select', '$1'
  visit 'select', '?, ?', sql_to_arel: false
  # https://github.com/mvgijssel/arel_toolkit/issues/101
  visit 'sql',
        'PREPARE some_plan (integer) AS (SELECT $1)',
        sql_to_arel: false
  visit 'select', '* FROM some_function(0, 2) AS "some_alias"'
  visit 'select', '* FROM generate_series(1, 2)'
  visit 'select', '* FROM LATERAL ROWS FROM (a(), b()) WITH ORDINALITY'
  visit 'select',
        '* FROM (SELECT \'b\') AS "a" INNER JOIN LATERAL (SELECT 1) AS "b" ON \'t\'::bool'
  visit 'select', '1 FROM "public"."table_is_range_var" "alias", ONLY "b"'
  visit 'select', '1'
  visit 'sql', 'REFRESH MATERIALIZED VIEW view WITH NO DATA',
        sql_to_arel: false
  visit 'sql', 'ALTER TABLE some_table RENAME COLUMN some_column TO a',
        sql_to_arel: false
  visit 'select', '1'
  visit 'sql', 'ALTER GROUP some_role ADD USER some_user',
        sql_to_arel: false
  visit 'select', "ROW(1, 2.5, 'a')"
  visit 'sql', 'CREATE RULE a_rule AS ON SELECT TO some_table DO INSTEAD SELECT * FROM other_table',
        sql_to_arel: false
  visit 'sql',
        '( ( SELECT ' \
        "DISTINCT 'id', (SELECT DISTINCT ON ( 'a' ) 'a'), 1 " \
        'FROM "a" ' \
        "WHERE 't'::bool " \
        'GROUP BY 1 ' \
        'HAVING "a" > 1 ' \
        'WINDOW "b" AS (PARTITION BY "c" ORDER BY "d" DESC) ' \
        'UNION ( ( SELECT 1 UNION ALL SELECT 2.0 ) ' \
        'INTERSECT ( SELECT "a" INTERSECT ALL SELECT $1 ) ) ) ' \
        "EXCEPT ( SELECT 'b' EXCEPT ALL SELECT 't'::bool ) ) " \
        'ORDER BY 1 ASC ' \
        'LIMIT 10 ' \
        'OFFSET 2 ' \
        'FOR UPDATE'
  visit 'sql', 'INSERT INTO som_table (a) VALUES (DEFAULT)',
        sql_to_arel: false
  visit 'select', '1 ORDER BY "a" ASC, 2 DESC NULLS FIRST, \'3\' ASC NULLS LAST'
  visit 'select', 'current_date'
  visit 'select', 'current_time'
  visit 'select', 'current_time(1)'
  visit 'select', 'current_timestamp'
  visit 'select', 'current_timestamp(2)'
  visit 'select', 'localtime'
  visit 'select', 'localtime(3)'
  visit 'select', 'localtimestamp'
  visit 'select', 'localtimestamp(4)'
  visit 'select', 'current_role'
  visit 'select', 'current_user'
  visit 'select', 'session_user'
  visit 'select', 'user'
  visit 'select', 'current_catalog'
  visit 'select', 'current_schema'
  visit 'select', "'some_string'"
  visit 'select', 'EXISTS (SELECT 1 = 1)'
  visit 'select', '"column" > ALL(SELECT AVG("amount") FROM "some_table")'
  visit 'select', '"column" = ANY(SELECT "a" FROM "b")'
  visit 'select', '"column" IN (SELECT "a" FROM "b")'
  visit 'select', '1 < (SELECT 1)'
  visit 'select', 'ARRAY(SELECT 1)'
  visit 'sql',
        'BEGIN; ' \
        'SAVEPOINT "my_savepoint"; ' \
        'RELEASE SAVEPOINT "my_savepoint"; ' \
        'ROLLBACK; ' \
        'ROLLBACK TO "my_savepoint"; ' \
        'COMMIT'
  visit 'sql', 'TRUNCATE public.some_table', sql_to_arel: false
  visit 'select', '1::integer'
  visit 'select', '2::bool'
  visit 'select', "'3'::text"
  visit 'select', "(date_trunc('hour', \"p\".\"created_at\") || '-0')::timestamp with time zone"
  visit 'select', '"a"::varchar'
  visit 'sql',
        'WITH "query" AS (SELECT 1 AS "a") ' \
        'UPDATE ONLY "some_table" "table_alias" ' \
        'SET "b" = "query"."a", "d" = DEFAULT, "e" = (SELECT 1), "d" = ROW(DEFAULT) ' \
        'FROM "query", "other_query" WHERE 1 = 1 ' \
        'RETURNING *, "c" AS "some_column"'
  visit 'sql',
        'UPDATE ONLY "some_table" ' \
        'SET "b" = "query"."a", "c" = 1.0, "d" = \'e`\', "f" = \'t\'::bool ' \
        'WHERE CURRENT OF some_cursor'
  visit 'sql',
        'UPDATE "some_table" SET "b" = 1 - 1, "c" = 2 + 2, "d" = COALESCE(NULL, 1)'
  visit 'sql',
        'UPDATE "some_table" SET "b" = 1 WHERE "b"."id" IN (SELECT 2)'
  visit 'sql', 'VACUUM FULL VERBOSE ANALYZE some_table',
        sql_to_arel: false
  visit 'sql',
        'SET var1 TO 1; ' \
        "SET LOCAL var2 TO 'some setting'; " \
        'SET LOCAL var3 TO DEFAULT; ' \
        "SET TIME ZONE 'UTC'; " \
        'SET LOCAL TIME ZONE DEFAULT'
  visit 'sql', "SET SESSION var4 TO ''", expected_sql: "SET var4 TO ''"
  visit 'sql', 'SHOW some_variable; SHOW TIME ZONE'
  visit 'sql', 'CREATE VIEW some_view AS (SELECT 1)',
        sql_to_arel: false
  visit 'select', 'SUM("a") OVER (RANGE CURRENT ROW)'
  visit 'select', 'SUM("a") OVER (RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)'
  visit 'select', 'SUM("a") OVER (RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)'
  visit 'select', 'SUM("a") OVER (RANGE BETWEEN CURRENT ROW AND CURRENT ROW)'
  visit 'select', 'SUM("a") OVER (RANGE BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING)'
  visit 'select', 'SUM("a") OVER (ROWS 2 PRECEDING)'
  visit 'select', 'SUM("a") OVER (ROWS BETWEEN 2 PRECEDING AND 2 FOLLOWING)'
  visit 'select', 'SUM("a") OVER (ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING)'
  visit 'select', 'SUM("a") OVER (ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)'
  visit 'select', 'SUM("a") OVER (ROWS BETWEEN UNBOUNDED PRECEDING AND 1 FOLLOWING)'
  visit 'select', 'SUM("a") OVER (ROWS BETWEEN 1 PRECEDING AND UNBOUNDED FOLLOWING)'
  visit 'select', 'SUM("a") OVER (ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)'
  visit 'select', 'SUM("a") OVER ()'
  visit 'select', 'WINDOW "b" AS (PARTITION BY "c" ORDER BY "d" DESC)'
  visit 'sql', 'WITH "some_name" AS (SELECT \'a\') SELECT "some_name"'
  visit 'select', 'SUM("a") OVER (ORDER BY "a")'
  visit 'select', 'CAST((AVG("a") OVER running_average) AS FLOAT)',
        expected_sql: 'SELECT (AVG("a") OVER running_average)::double precision'
  visit 'select',
        'SUM("a") OVER w, AVG("a") OVER w FROM "t" ' \
        'WINDOW "w" AS (PARTITION BY "b" ORDER BY "a" DESC)'
  visit 'select', '11 + (11 + 5)'
  visit 'select', '(12 - 12) - 13'
  visit 'select', '3 + (10 * 10)'
  visit 'select', '(6 - 13) / 13'
  visit 'select', '13 % 2'
  visit 'select', '2.0 ^ 3.0'
  visit 'select', ' |/ 16'
  visit 'select', ' ||/ 17'
  visit 'select', '14 !', sql_to_arel: false
  visit 'select', '!! 15'
  visit 'select', ' @ -5'
  visit 'select', '2 & 3'
  visit 'select', '2 | 3'
  visit 'select', '17 # 5'
  visit 'select', ' ~ 5'
  visit 'select', '1 << 4'
  visit 'select', '8 >> 2'
  visit 'select', '8 < 7'
  visit 'select', '5 > 4'
  visit 'select', '9 <= 9'
  visit 'select', '6 >= 6'
  visit 'select', '1 = 1'
  visit 'select', '2 != 3'
  visit 'select', 'ARRAY[1, 4, 3] @> ARRAY[3, 1]'
  visit 'select', 'ARRAY[2, 7] <@ ARRAY[1, 7, 4, 2, 6]'
  visit 'select', 'ARRAY[1, 4, 3] && ARRAY[2, 1]'
  visit 'select', 'ARRAY[1, 2, 3] || ARRAY[4, 5, 6]'
  visit 'select', 'ARRAY[1] || ARRAY[ARRAY[4], ARRAY[7]]'
  visit 'select', '3 || ARRAY[4, 5, 6]'
  visit 'select', 'ARRAY[4, 5, 6] || 7'
  visit 'select', "'192.168.1/24'::inet <<= '192.168.1/24'::inet"
  visit 'select', "'192.168.1/24'::inet >>= '192.168.1/24'::inet"
  visit 'select', '\'[{"a":"foo"},{"b":"bar"},{"c":"baz"}]\'::json -> 2'
  visit 'select', '\'{"a": {"b":"foo"}}\'::json -> \'a\''
  visit 'select', "'[1,2,3]'::json ->> 2"
  visit 'select', '\'{"a":1,"b":2}\'::json ->> \'b\''
  visit 'select', '\'{"a": {"b":{"c": "foo"}}}\'::json #> \'{a,b}\''
  visit 'select', '\'{"a":[1,2,3],"b":[4,5,6]}\'::json #>> \'{a,2}\''
  visit 'select', '\'{"a":1, "b":2}\'::jsonb @> \'{"b":2}\'::jsonb'
  visit 'select', '\'{"b":2}\'::jsonb <@ \'{"a":1, "b":2}\'::jsonb'
  visit 'select', '\'{"a":1, "b":2}\'::jsonb ? \'b\''
  visit 'select', '\'{"a":1, "b":2, "c":3}\'::jsonb ?| ARRAY[\'b\', \'c\']'
  visit 'select', '\'["a", "b"]\'::jsonb ?& ARRAY[\'a\', \'b\']'
  visit 'select', "'thomas' ~ '.*thomas.*'"
  visit 'select', "'thomas' ~* '.*Thomas.*'"
  visit 'select', "'thomas' !~ '.*Thomas.*'"
  visit 'select', "'thomas' !~* '.*vadim.*'"
  visit 'select', "('a' || 'b') @@ (to_tsquery('a') && to_tsquery('b'))"
  visit 'select', '1 FETCH FIRST 2 ROWS ONLY', expected_sql: 'SELECT 1 LIMIT 2'
  visit 'select', 'CAST(3 AS TEXT)', expected_sql: 'SELECT 3::text'
  visit 'select', "inet '192.168.1.6'", expected_sql: "SELECT '192.168.1.6'::inet"
  visit 'select', '"a" <= SOME(SELECT 1)', expected_sql: 'SELECT "a" <= ANY(SELECT 1)'
  visit 'select', 'SUM(ALL "a")', expected_sql: 'SELECT SUM("a")'

  # 'https://www.postgresql.org/docs/10/functions-math.html#FUNCTIONS-MATH-FUNC-TABLE'
  visit 'select', 'abs(-17.4)'
  visit 'select', 'cbrt(27.0)'
  visit 'select', 'ceil(-42.8)'
  visit 'select', 'ceiling(-95.3)'
  visit 'select', 'degrees(0.5)'
  visit 'select', 'div(9, 4)'
  visit 'select', 'exp(1.0)'
  visit 'select', 'floor(-42.8)'
  visit 'select', 'ln(2.0)'
  visit 'select', 'log(100.0)'
  visit 'select', 'log(2.0, 64.0)'
  visit 'select', 'mod(9, 4)'
  visit 'select', 'pi()'
  visit 'select', 'power(9.0, 3.0)'
  visit 'select', 'power(9.0, 3.0)'
  visit 'select', 'radians(45.0)'
  visit 'select', 'round(42.4)'
  visit 'select', 'round(42.4382, 2)'
  visit 'select', 'scale(8.41)'
  visit 'select', 'sign(-8.4)'
  visit 'select', 'sqrt(2.0)'
  visit 'select', 'trunc(42.8)'
  visit 'select', 'trunc(42.4382, 2)'
  visit 'select', 'width_bucket(5.35, 0.024, 10.06, 5)'
  visit 'select', 'width_bucket(5.35, 0.024, 10.06, 5)'
  visit 'select',
        "width_bucket(now(), ARRAY['yesterday', 'today', 'tomorrow']::timestamp with time zone[])"

  # 'https://www.postgresql.org/docs/10/functions-math.html#FUNCTIONS-MATH-RANDOM-TABLE'
  visit 'select', 'random()'
  visit 'select', 'setseed("dp")'

  # 'https://www.postgresql.org/docs/10/functions-math.html#FUNCTIONS-MATH-TRIG-TABLE'
  visit 'select', 'acos("x")'
  visit 'select', 'asin("x")'
  visit 'select', 'atan("x")'
  visit 'select', 'atan2("y", "x")'
  visit 'select', 'cos("x")'
  visit 'select', 'cot("x")'
  visit 'select', 'sin("x")'
  visit 'select', 'tan("x")'

  # 'https://www.postgresql.org/docs/10/functions-string.html#FUNCTIONS-STRING-SQL'
  visit 'select', "'Post' || 'greSQL'"
  visit 'select', "'Value: ' || 42"
  visit 'select', "bit_length('jose')"
  visit 'select', "char_length('jose')"
  visit 'select', "lower('TOM')"
  visit 'select', "octet_length('jose')"
  visit 'select', "overlay('Txxxxas' placing 'hom' from 2 for 4)"
  visit 'select', "position('om' in 'Thomas')"
  visit 'select', "substring('Thomas' from 2 for 3)"
  visit 'select', "substring('Thomas' from '...$')"
  visit 'select', "substring('Thomas' from '%#\"o_a#\"_' for '#')"
  visit 'select', "trim(both 'xyz' from 'yxTomxx')"
  visit 'select', "trim(both from 'yxTomxx', 'xyz')",
        expected_sql: "SELECT trim(both 'xyz' from 'yxTomxx')"
  visit 'select', "upper('tom')"

  # 'https://www.postgresql.org/docs/10/functions-string.html#FUNCTIONS-STRING-OTHER'
  visit 'select', "ascii('x')"
  visit 'select', "btrim('xyxtrimyyx', 'xyz')"
  visit 'select', 'chr(65)'
  visit 'select', "concat('abcde', 2, NULL, 22)"
  visit 'select', "concat_ws(',', 'abcde', 2, NULL, 22)"
  visit 'select', "convert('text_in_utf8', 'UTF8', 'LATIN1')"
  visit 'select', "convert_from('text_in_utf8', 'UTF8')"
  visit 'select', "convert_to('some text', 'UTF8')"
  visit 'select', "decode('MTIzAAE=', 'base64')"
  visit 'select', "encode('123\\000\\001', 'base64')"
  visit 'select', "format('Hello %s, %1$s', 'World')"
  visit 'select', "initcap('hi THOMAS')"
  visit 'select', "left('abcde', 2)"
  visit 'select', "length('jose')"
  visit 'select', "length('jose', 'UTF8')"
  visit 'select', "lpad('hi', 5, 'xy')"
  visit 'select', "ltrim('zzzytest', 'xyz')"
  visit 'select', "md5('abc')"
  visit 'select', "parse_ident('\"SomeSchema\".someTable')"
  visit 'select', 'pg_client_encoding()'
  visit 'select', "quote_ident('Foo bar')"
  visit 'select', "quote_literal(E'O\\'Reilly')", expected_sql: "SELECT quote_literal('O''Reilly')"
  visit 'select', 'quote_literal(42.5)'
  visit 'select', 'quote_nullable(NULL)'
  visit 'select', 'quote_nullable(42.5)'
  visit 'select', "regexp_match('foobarbequebaz', '(bar)(beque)')"
  visit 'select', "regexp_matches('foobarbequebaz', 'ba.', 'g')"
  visit 'select', "regexp_replace('Thomas', '.[mN]a.', 'M')"
  visit 'select', "regexp_split_to_array('hello world', '\s+')"
  visit 'select', "regexp_split_to_table('hello world', '\s+')"
  visit 'select', "repeat('Pg', 4)"
  visit 'select', "replace('abcdefabcdef', 'cd', 'XX')"
  visit 'select', "reverse('abcde')"
  visit 'select', "right('abcde', 2)"
  visit 'select', "rpad('hi', 5, 'xy')"
  visit 'select', "rtrim('testxxzx', 'xyz')"
  visit 'select', "split_part('abc~@~def~@~ghi', '~@~', 2)"
  visit 'select', "strpos('high', 'ig')"
  visit 'select', "substr('alphabet', 3, 2)"
  visit 'select', "to_ascii('Karel')"
  visit 'select', 'to_hex(2147483647)'
  visit 'select', "translate('12345', '143', 'ax')"

  # 'https://www.postgresql.org/docs/10/functions-binarystring.html#FUNCTIONS-BINARYSTRING-SQL'
  visit 'select', "'\\Post'::bytea || '\\047gres\\000'::bytea"
  visit 'select', "octet_length('jo\\000se'::bytea)"
  visit 'select', "overlay('Th\\000omas'::bytea placing '\\002\\003'::bytea from 2 for 3)"
  visit 'select', "position('\\000om'::bytea in 'Th\\000omas'::bytea)"
  visit 'select', "substring('Th\\000omas'::bytea from 2 for 3)"
  visit 'select', "trim(both '\\000\\001'::bytea from '\\000Tom\\001'::bytea)"

  # 'https://www.postgresql.org/docs/10/functions-binarystring.html#FUNCTIONS-BINARYSTRING-OTHER'
  visit 'select', "btrim('\\000trim\\001'::bytea, '\\000\\001'::bytea)"
  visit 'select', "decode('123\\000456', 'escape')"
  visit 'select', "encode('123\\000456'::bytea, 'escape')"
  visit 'select', "get_bit('Th\\000omas'::bytea, 45)"
  visit 'select', "get_byte('Th\\000omas'::bytea, 4)"
  visit 'select', "length('jo\\000se'::bytea)"
  visit 'select', "md5('Th\\000omas'::bytea)"
  visit 'select', "set_bit('Th\\000omas'::bytea, 45, 0)"
  visit 'select', "set_byte('Th\\000omas'::bytea, 4, 64)"

  # 'https://www.postgresql.org/docs/10/functions-matching.html#FUNCTIONS-POSIX-TABLE'
  visit 'select', "'thomas' ~ '.*thomas.*'"
  visit 'select', "'thomas' ~* '.*Thomas.*'"
  visit 'select', "'thomas' !~ '.*Thomas.*'"
  visit 'select', "'thomas' !~* '.*vadim.*'"

  # 'https://www.postgresql.org/docs/10/functions-formatting.html#FUNCTIONS-FORMATTING-TABLE'
  visit 'select', "to_char(current_timestamp, 'HH12:MI:SS')"
  visit 'select', "to_char('15h 2m 12s'::interval, 'HH24:MI:SS')"
  visit 'select', "to_char(125, '999')"
  visit 'select', "to_char(125.8::real, '999D9')"
  visit 'select', "to_char(-125.8, '999D99S')"
  visit 'select', "to_date('05 Dec 2000', 'DD Mon YYYY')"
  visit 'select', "to_number('12,454.8-', '99G999D9S')"
  visit 'select', "to_timestamp('05 Dec 2000', 'DD Mon YYYY')"

  # 'https://www.postgresql.org/docs/10/functions-formatting.html#FUNCTIONS-FORMATTING-EXAMPLES-TABLE'
  visit 'select', "to_char(current_timestamp, 'Day, DD  HH12:MI:SS')"
  visit 'select', "to_char(current_timestamp, 'FMDay, FMDD  HH12:MI:SS')"
  visit 'select', "to_char(-0.1, '99.99')"
  visit 'select', "to_char(-0.1, 'FM9.99')"
  visit 'select', "to_char(0.1, '0.9')"
  visit 'select', "to_char(12, '9990999.9')"
  visit 'select', "to_char(12, 'FM9990999.9')"
  visit 'select', "to_char(485, '999')"
  visit 'select', "to_char(-485, '999')"
  visit 'select', "to_char(485, '9 9 9')"
  visit 'select', "to_char(1485, '9,999')"
  visit 'select', "to_char(1485, '9G999')"
  visit 'select', "to_char(148.5, '999.999')"
  visit 'select', "to_char(148.5, 'FM999.999')"
  visit 'select', "to_char(148.5, 'FM999.990')"
  visit 'select', "to_char(148.5, '999D999')"
  visit 'select', "to_char(3148.5, '9G999D999')"
  visit 'select', "to_char(-485, '999S')"
  visit 'select', "to_char(-485, '999MI')"
  visit 'select', "to_char(485, '999MI')"
  visit 'select', "to_char(485, 'FM999MI')"
  visit 'select', "to_char(485, 'PL999')"
  visit 'select', "to_char(485, 'SG999')"
  visit 'select', "to_char(-485, 'SG999')"
  visit 'select', "to_char(-485, '9SG99')"
  visit 'select', "to_char(-485, '999PR')"
  visit 'select', "to_char(485, 'L999')"
  visit 'select', "to_char(485, 'RN')"
  visit 'select', "to_char(485, 'FMRN')"
  visit 'select', "to_char(5.2, 'FMRN')"
  visit 'select', "to_char(482, '999th')"
  visit 'select', "to_char(485, '\"Good number:\"999')"
  visit 'select', "to_char(485.8, '\"Pre:\"999\" Post:\" .999')"
  visit 'select', "to_char(12, '99V999')"
  visit 'select', "to_char(12.4, '99V999')"
  visit 'select', "to_char(12.45, '99V9')"
  visit 'select', "to_char(0.0004859, '9.99EEEE')"

  # 'https://www.postgresql.org/docs/10/functions-datetime.html#OPERATORS-DATETIME-TABLE'
  visit 'select', "'2001-09-28'::date + '7'::integer"
  visit 'select', "'2001-09-28'::date + '1 hour'::interval"
  visit 'select', "'2001-09-28'::date + '03:00'::time"
  visit 'select', "'1 day'::interval + '1 hour'::interval"
  visit 'select', "'2001-09-28 01:00'::timestamp + '23 hours'::interval"
  visit 'select', "'01:00'::time + '3 hours'::interval"
  visit 'select', " - '23 hours'::interval"
  visit 'select', "'2001-10-01'::date - '2001-09-28'::date"
  visit 'select', "'2001-10-01'::date - '7'::integer"
  visit 'select', "'2001-09-28'::date - '1 hour'::interval"
  visit 'select', "'05:00'::time - '03:00'::time"
  visit 'select', "'05:00'::time - '2 hours'::interval"
  visit 'select', "'2001-09-28 23:00'::timestamp - '23 hours'::interval"
  visit 'select', "'1 day'::interval - '1 hour'::interval"
  visit 'select', "'2001-09-29 03:00'::timestamp - '2001-09-27 12:00'::timestamp"
  visit 'select', "900 * '1 second'::interval"
  visit 'select', "21 * '1 day'::interval"
  visit 'select', "'3.5'::double precision * '1 hour'::interval"
  visit 'select', "'1 hour'::interval / '1.5'::double precision"

  # 'https://www.postgresql.org/docs/10/functions-datetime.html#FUNCTIONS-DATETIME-TABLE'
  visit 'select', "age('2001-04-10'::timestamp, '1957-06-13'::timestamp)"
  visit 'select', "age('1957-06-13'::timestamp)"
  visit 'select', 'clock_timestamp()'
  visit 'select', 'current_date'
  visit 'select', 'current_time'
  visit 'select', 'current_timestamp'
  visit 'select', "date_part('hour', '2001-02-16 20:38:40'::timestamp)"
  visit 'select', "date_part('month', '2 years 3 months'::interval)"
  visit 'select', "date_trunc('hour', '2001-02-16 20:38:40'::timestamp)"
  visit 'select', "date_trunc('hour', '2 days 3 hours 40 minutes'::interval)"
  visit 'select', "extract('hour' from '2001-02-16 20:38:40'::timestamp)", sql_to_arel: false
  visit 'select', "extract('month' from '2 years 3 months'::interval)", sql_to_arel: false
  visit 'select', "isfinite('2001-02-16'::date)"
  visit 'select', "isfinite('2001-02-16 21:28:30'::timestamp)"
  visit 'select', "isfinite('4 hours'::interval)"
  visit 'select', "justify_days('35 days'::interval)"
  visit 'select', "justify_hours('27 hours'::interval)"
  visit 'select', "justify_interval('1 mon -1 hour'::interval)"
  visit 'select', 'localtime'
  visit 'select', 'localtimestamp'
  visit 'select', 'make_date(2013, 7, 15)'
  visit 'select', 'make_interval(days => 10)'
  visit 'select', 'make_time(8, 15, 23.5)'
  visit 'select', 'make_timestamp(2013, 7, 15, 8, 15, 23.5)'
  visit 'select', 'make_timestamptz(2013, 7, 15, 8, 15, 23.5)'
  visit 'select', 'now()'
  visit 'select', 'statement_timestamp()'
  visit 'select', 'timeofday()'
  visit 'select', 'transaction_timestamp()'
  visit 'select', 'to_timestamp(1284352323)'

  # 'https://www.postgresql.org/docs/10/functions-datetime.html#FUNCTIONS-DATETIME-ZONECONVERT-TABLE'
  visit 'select', "'2001-02-16 20:38:40'::timestamp AT TIME ZONE 'America/Denver'"
  visit 'select', "'2001-02-16 20:38:40-05'::timestamp with time zone AT TIME ZONE 'America/Denver'"
  visit 'select',
        "'2001-02-16 20:38:40-05'::timezone AT TIME ZONE 'Asia/Tokyo' AT TIME ZONE 'America/Chicag'"

  # 'https://www.postgresql.org/docs/10/functions-enum.html#FUNCTIONS-ENUM-TABLE'
  visit 'select', 'enum_first(NULL::rainbow)'
  visit 'select', 'enum_last(NULL::rainbow)'
  visit 'select', 'enum_range(NULL::rainbow)'
  visit 'select', "enum_range('orange'::rainbow, 'green'::rainbow)"
  visit 'select', "enum_range(NULL, 'green'::rainbow)"
  visit 'select', "enum_range('orange'::rainbow, NULL)"

  # 'https://www.postgresql.org/docs/10/functions-geometry.html#FUNCTIONS-GEOMETRY-OP-TABLE'
  visit 'select', "'((0,0),(1,1))'::box + '(2.0,0)'::point"
  visit 'select', "'((0,0),(1,1))'::box - '(2.0,0)'::point"
  visit 'select', "'((0,0),(1,1))'::box * '(2.0,0)'::point"
  visit 'select', "'((0,0),(2,2))'::box / '(2.0,0)'::point"
  visit 'select', "'((1,-1),(-1,1))'::box # '((1,1),(-2,-2))'::box"
  visit 'select', " # '((1,0),(0,1),(-1,0))'::path"
  visit 'select', " @-@ '((0,0),(1,0))'::path"
  visit 'select', " @@ '((0,0),10)'::circle"
  visit 'select', "'(0,0)'::point ## '((2,0),(0,2))'::lseg"
  visit 'select', "'((0,0),1)'::circle <-> '((5,0),1)'::circle"
  visit 'select', "'((0,0),(1,1))'::box && '((0,0),(2,2))'::box"
  visit 'select', "'((0,0),1)'::circle << '((5,0),1)'::circle"
  visit 'select', "'((5,0),1)'::circle >> '((0,0),1)'::circle"
  visit 'select', "'((0,0),(1,1))'::box &< '((0,0),(2,2))'::box"
  visit 'select', "'((0,0),(3,3))'::box &> '((0,0),(2,2))'::box"
  visit 'select', "'((0,0),(3,3))'::box <<| '((3,4),(5,5))'::box"
  visit 'select', "'((3,4),(5,5))'::box |>> '((0,0),(3,3))'::box"
  visit 'select', "'((0,0),(1,1))'::box &<| '((0,0),(2,2))'::box"
  visit 'select', "'((0,0),(3,3))'::box |&> '((0,0),(2,2))'::box"
  visit 'select', "'((0,0),1)'::circle <^ '((0,5),1)'::circle"
  visit 'select', "'((0,5),1)'::circle >^ '((0,0),1)'::circle"
  visit 'select', "'((-1,0),(1,0))'::lseg ?# '((-2,-2),(2,2))'::box"
  visit 'select', " ?- '((-1,0),(1,0))'::lseg"
  visit 'select', "'(1,0)'::point ?- '(0,0)'::point"
  visit 'select', " ?| '((-1,0),(1,0))'::lseg"
  visit 'select', "'(0,1)'::point ?| '(0,0)'::point"
  visit 'select', "'((0,0),(0,1))'::lseg ?-| '((0,0),(1,0))'::lseg"
  visit 'select', "'((-1,0),(1,0))'::lseg ?|| '((-1,2),(1,2))'::lseg"
  visit 'select', "'((0,0),2)'::circle @> '(1,1)'::point"
  visit 'select', "'(1,1)'::point <@ '((0,0),2)'::circle"
  visit 'select', "'((0,0),(1,1))'::polygon ~= '((1,1),(0,0))'::polygon"

  # 'https://www.postgresql.org/docs/10/functions-geometry.html#FUNCTIONS-GEOMETRY-FUNC-TABLE'
  visit 'select', "area('((0,0),(1,1))'::box)"
  visit 'select', "center('((0,0),(1,2))'::box)"
  visit 'select', "diameter('((0,0),2.0)'::circle)"
  visit 'select', "height('((0,0),(1,1))'::box)"
  visit 'select', "isclosed('((0,0),(1,1),(2,0))'::path)"
  visit 'select', "isopen('[(0,0),(1,1),(2,0)]'::path)"
  visit 'select', "length('((-1,0),(1,0))'::path)"
  visit 'select', "npoints('[(0,0),(1,1),(2,0)]'::path)"
  visit 'select', "npoints('((1,1),(0,0))'::polygon)"
  visit 'select', "pclose('[(0,0),(1,1),(2,0)]'::path)"
  visit 'select', "popen('((0,0),(1,1),(2,0))'::path)"
  visit 'select', "radius('((0,0),2.0)'::circle)"
  visit 'select', "width('((0,0),(1,1))'::box)"

  # 'https://www.postgresql.org/docs/10/functions-geometry.html#FUNCTIONS-GEOMETRY-CONV-TABLE'
  visit 'select', "box('((0,0),2.0)'::circle)"
  visit 'select', "box('(0,0)'::point)"
  visit 'select', "box('(0,0)'::point, '(1,1)'::point)"
  visit 'select', "box('((0,0),(1,1),(2,0))'::polygon)"
  visit 'select', "bound_box('((0,0),(1,1))'::box, '((3,3),(4,4))'::box)"
  visit 'select', "circle('((0,0),(1,1))'::box)"
  visit 'select', "circle('(0,0)'::point, 2.0)"
  visit 'select', "circle('((0,0),(1,1),(2,0))'::polygon)"
  visit 'select', "line('(-1,0)'::point, '(1,0)'::point)"
  visit 'select', "lseg('((-1,0),(1,0))'::box)"
  visit 'select', "lseg('(-1,0)'::point, '(1,0)'::point)"
  visit 'select', "path('((0,0),(1,1),(2,0))'::polygon)"
  visit 'select', 'point(23.4, -44.5)'
  visit 'select', "point('((-1,0),(1,0))'::box)"
  visit 'select', "point('((0,0),2.0)'::circle)"
  visit 'select', "point('((-1,0),(1,0))'::lseg)"
  visit 'select', "point('((0,0),(1,1),(2,0))'::polygon)"
  visit 'select', "polygon('((0,0),(1,1))'::box)"
  visit 'select', "polygon('((0,0),2.0)'::circle)"
  visit 'select', "polygon(12, '((0,0),2.0)'::circle)"
  visit 'select', "polygon('((0,0),(1,1),(2,0))'::path)"

  # 'https://www.postgresql.org/docs/10/functions-net.html#CIDR-INET-OPERATORS-TABLE'
  visit 'select', "'192.168.1.5'::inet < '192.168.1.6'::inet"
  visit 'select', "'192.168.1.5'::inet <= '192.168.1.5'::inet"
  visit 'select', "'192.168.1.5'::inet = '192.168.1.5'::inet"
  visit 'select', "'192.168.1.5'::inet >= '192.168.1.5'::inet"
  visit 'select', "'192.168.1.5'::inet > '192.168.1.4'::inet"
  visit 'select', "'192.168.1.5'::inet != '192.168.1.4'::inet"
  visit 'select', "'192.168.1.5'::inet << '192.168.1/24'::inet"
  visit 'select', "'192.168.1/24'::inet <<= '192.168.1/24'::inet"
  visit 'select', "'192.168.1/24'::inet >> '192.168.1.5'::inet"
  visit 'select', "'192.168.1/24'::inet >>= '192.168.1/24'::inet"
  visit 'select', "'192.168.1/24'::inet && '192.168.1.80/28'::inet"
  visit 'select', " ~ '192.168.1.6'::inet"
  visit 'select', "'192.168.1.6'::inet & '0.0.0.255'::inet"
  visit 'select', "'192.168.1.6'::inet | '0.0.0.255'::inet"
  visit 'select', "'192.168.1.6'::inet + 25"
  visit 'select', "'192.168.1.43'::inet - 36"
  visit 'select', "'192.168.1.43'::inet - '192.168.1.19'::inet"

  # 'https://www.postgresql.org/docs/10/functions-net.html#CIDR-INET-FUNCTIONS-TABLE'
  visit 'select', "abbrev('10.1.0.0/16'::inet)"
  visit 'select', "abbrev('10.1.0.0/16'::cidr)"
  visit 'select', "broadcast('192.168.1.5/24')"
  visit 'select', "family('::1')"
  visit 'select', "host('192.168.1.5/24')"
  visit 'select', "hostmask('192.168.23.20/30')"
  visit 'select', "masklen('192.168.1.5/24')"
  visit 'select', "netmask('192.168.1.5/24')"
  visit 'select', "network('192.168.1.5/24')"
  visit 'select', "set_masklen('192.168.1.5/24', 16)"
  visit 'select', "set_masklen('192.168.1.0/24'::cidr, 16)"
  visit 'select', "text('192.168.1.5'::inet)"
  visit 'select', "inet_same_family('192.168.1.5/24', '::1')"
  visit 'select', "inet_merge('192.168.1.5/24', '192.168.2.5/24')"

  # 'https://www.postgresql.org/docs/10/functions-net.html#MACADDR-FUNCTIONS-TABLE'
  visit 'select', "trunc('12:34:56:78:90:ab'::macaddr)"

  # 'https://www.postgresql.org/docs/10/functions-net.html#MACADDR8-FUNCTIONS-TABLE'
  visit 'select', "trunc('12:34:56:78:90:ab:cd:ef'::macaddr8)"
  visit 'select', "macaddr8_set7bit('00:34:56:ab:cd:ef'::macaddr8)"

  # 'https://www.postgresql.org/docs/10/functions-textsearch.html#TEXTSEARCH-OPERATORS-TABLE'
  visit 'select', "to_tsvector('fat cats ate rats') @@ to_tsquery('cat & rat')"
  visit 'select', "to_tsvector('fat cats ate rats') @@@ to_tsquery('cat & rat')"
  visit 'select', "'a:1 b:2'::tsvector || 'c:1 d:2 b:3'::tsvector"
  visit 'select', "'fat | rat'::tsquery && 'cat'::tsquery"
  visit 'select', "'fat | rat'::tsquery || 'cat'::tsquery"
  visit 'select', "!! 'cat'::tsquery"
  visit 'select', "to_tsquery('fat') <-> to_tsquery('rat')"
  visit 'select', "'cat'::tsquery @> 'cat & rat'::tsquery"
  visit 'select', "'cat'::tsquery <@ 'cat & rat'::tsquery"

  # 'https://www.postgresql.org/docs/10/functions-textsearch.html#TEXTSEARCH-FUNCTIONS-TABLE'
  visit 'select', "array_to_tsvector('{fat,cat,rat}'::text[])"
  visit 'select', 'get_current_ts_config()'
  visit 'select', "length('fat:2,4 cat:3 rat:5A'::tsvector)"
  visit 'select', "numnode('(fat & rat) | cat'::tsquery)"
  visit 'select', "plainto_tsquery('english', 'The Fat Rats')"
  visit 'select', "phraseto_tsquery('english', 'The Fat Rats')"
  visit 'select', "querytree('foo & ! bar'::tsquery)"
  visit 'select', "setweight('fat:2,4 cat:3 rat:5B'::tsvector, 'A')"
  visit 'select', "setweight('fat:2,4 cat:3 rat:5B'::tsvector, 'A', '{cat,rat}')"
  visit 'select', "strip('fat:2,4 cat:3 rat:5A'::tsvector)"
  visit 'select', "to_tsquery('english', 'The & Fat & Rats')"
  visit 'select', "to_tsvector('english', 'The Fat Rats')"
  visit 'select', "to_tsvector('english', '{\"a\": \"The Fat Rats\"}'::json)"
  visit 'select', "ts_delete('fat:2,4 cat:3 rat:5A'::tsvector, 'fat')"
  visit 'select', "ts_delete('fat:2,4 cat:3 rat:5A'::tsvector, ARRAY['fat', 'rat'])"
  visit 'select', "ts_filter('fat:2,4 cat:3b rat:5A'::tsvector, '{a,b}')"
  visit 'select', "ts_headline('x y z', 'z'::tsquery)"
  visit 'select', "ts_headline('{\"a\":\"x y z\"}'::json, 'z'::tsquery)"
  visit 'select', 'ts_rank("textsearch", "query")'
  visit 'select', "ts_rank_cd('{0.1, 0.2, 0.4, 1.0}', \"textsearch\", \"query\")"
  visit 'select', "ts_rewrite('a & b'::tsquery, 'a'::tsquery, 'foo|bar'::tsquery)"
  visit 'select', "ts_rewrite('a & b'::tsquery, 'SELECT t,s FROM aliases')"
  visit 'select', "tsquery_phrase(to_tsquery('fat'), to_tsquery('cat'))"
  visit 'select', "tsvector_to_array('fat:2,4 cat:3 rat:5A'::tsvector)"
  visit 'select', "tsvector_update_trigger(\"tsvcol\", 'pg_catalog.swedish', \"title\", \"body\")"
  visit 'select', 'tsvector_update_trigger_column("tsvcol", "configcol", "title", "body")'
  visit 'select', "unnest('fat:2,4 cat:3 rat:5A'::tsvector)"

  # 'https://www.postgresql.org/docs/10/functions-textsearch.html#TEXTSEARCH-FUNCTIONS-DEBUG-TABLE'
  visit 'select', "ts_debug('english', 'The Brightest supernovaes')"
  visit 'select', "ts_lexize('english_stem', 'stars')"
  visit 'select', "ts_parse('default', 'foo - bar')"
  visit 'select', "ts_parse(3722, 'foo - bar')"
  visit 'select', "ts_token_type('default')"
  visit 'select', 'ts_token_type(3722)'
  visit 'select', "ts_stat('SELECT vector from apod')"

  it 'returns an Arel::SelectManager for only the top level SELECT' do
    sql = 'SELECT 1, (SELECT 2)'
    result = Arel.sql_to_arel(sql)
    arel = result.first

    expect(arel.class).to eq Arel::SelectManager

    subquery_grouping = arel.projections[1]

    expect(subquery_grouping.class).to eq Arel::Nodes::Grouping

    subquery = subquery_grouping.expr

    expect(subquery.class).to eq Arel::Nodes::SelectStatement
  end

  it 'returns an Arel::InsertManager' do
    sql = 'INSERT INTO a ("b") VALUES (1)'
    result = Arel.sql_to_arel(sql)
    arel = result.first

    expect(arel.class).to eq Arel::InsertManager
  end

  it 'returns an Arel::UpdateManager' do
    sql = 'UPDATE "some_table" SET "some_column" = 2.0'
    result = Arel.sql_to_arel(sql)
    arel = result.first

    expect(arel.class).to eq Arel::UpdateManager
  end

  it 'returns an Arel::DeleteManager' do
    sql = 'DELETE FROM "some_table"'
    result = Arel.sql_to_arel(sql)
    arel = result.first

    expect(arel.class).to eq Arel::DeleteManager
  end

  it 'returns a result object when calling map' do
    sql = 'SELECT 1'
    result = Arel.sql_to_arel(sql)
    new_result = result.map { 10 }

    expect(result).to be_a(Arel::SqlToArel::Result)
    expect(new_result).to be_a(Arel::SqlToArel::Result)
  end

  it 'works for conditional deletes from active record' do
    user = User.create! id: 1
    Post.create! owner: user
    Post.create!

    operation = -> { Post.joins(:owner).where(users: { id: user }).delete_all }
    delete_sql = Arel.middleware.to_sql(:delete) { operation.call }

    expected_sql = 'DELETE FROM "posts" WHERE "posts"."id" IN (SELECT "posts"."id" FROM "posts" ' \
                   'INNER JOIN "users" ON "users"."id" = "posts"."owner_id" WHERE "users"."id" = $1)'

    expect(delete_sql).to eq([expected_sql])
    expect { operation.call }.to change { Post.count }.from(2).to(1)
  end

  it 'works for conditional updates from active record' do
    user = User.create! id: 1
    Post.create! owner: user, public: false
    Post.create! public: false

    operation = lambda do
      Post.joins(:owner).where(users: { id: user }).update_all public: Arel.sql("'t'::bool")
    end
    update_sql = Arel.middleware.to_sql(:update) { operation.call }

    expected_sql = 'UPDATE "posts" SET "public" = \'t\'::bool WHERE ' \
                   '"posts"."id" IN (SELECT "posts"."id" FROM "posts" INNER JOIN "users" ' \
                   'ON "users"."id" = "posts"."owner_id" WHERE "users"."id" = $1)'

    expect(update_sql).to eq([expected_sql])

    expect { operation.call }.to change { Post.where(public: true).reload.count }.from(0).to(1)
  end

  it 'handles binds from ActiveRecord' do
    query = Post.where(id: 7)
    sql, binds = ActiveRecord::Base.connection.send(:to_sql_and_binds, query.arel)
    parsed_arel = Arel.sql_to_arel(sql, binds: binds)

    expect(query.arel.to_sql).to eq parsed_arel.to_sql
  end

  it 'translates double single quotes correctly' do
    sql = "SELECT 1 FROM \"posts\" WHERE \"id\" = 'a''bc123'"
    result = Arel.sql_to_arel(sql)

    expect(result.to_sql).to eq sql
  end

  it 'throws a nice error message' do
    sql = 'SELECT 1=1'
    result = PgQuery.parse(sql)
    result.tree.stmts.first.stmt.select_stmt.target_list.first.res_target.val.a_expr.kind = -1

    expect(PgQuery).to receive(:parse).with(sql).and_return(result)

    message = <<~STRING
      SQL: SELECT 1=1
      BINDS: []
      message: Unknown Expr type `-1`
    STRING

    expect do
      Arel.sql_to_arel(sql)
    end.to raise_error do |error|
      expect(message).to eq error.message
    end
  end

  it 'comparison operators work with Arel::Nodes::Quoted' do
    t = Post.arel_table
    sql = t
      .where(t[:id].eq(Arel::Nodes.build_quoted(nil)))
      .where(t[:id].not_eq(Arel::Nodes.build_quoted(nil)))
      .to_sql

    expect(sql)
      .to eq 'SELECT FROM "posts" WHERE "posts"."id" IS NULL AND "posts"."id" IS NOT NULL'
  end
end
