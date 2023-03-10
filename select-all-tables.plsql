Set feedback off
Set serverout on
Set trimspool on
Spool C:\TableList.csv
DECLARE
  CURSOR table_names IS
    SELECT
        TABLE_NAME
    FROM
        USER_TABLES
    ORDER BY
        TABLE_NAME;
  table_name VARCHAR2(100);
  table_count VARCHAR2(10);
  table_updated_at VARCHAR2(19);
  sql_count VARCHAR2(1000);
  sql_updated_at VARCHAR2(1000);
  num NUMBER := 1;
BEGIN
  OPEN table_names;
  FETCH table_names INTO table_name;
  IF table_names%NOTFOUND THEN
    CLOSE table_names;
    RAISE NO_DATA_FOUND;
  END IF;
  
  DBMS_OUTPUT.PUT_LINE('NO, TABLE_NAME, COUNT, UPDATED_AT');
  
  LOOP
    BEGIN
      sql_count := 'SELECT COUNT(*) FROM ' || table_name;
      EXECUTE IMMEDIATE sql_count INTO table_count;
      
      sql_updated_at := 'SELECT DECODE(MAX(updated_at), NULL, ''-'', TO_CHAR(MAX(updated_at), ''YYYY-MM-DD HH24:MI:SS'')) FROM ' || table_name;
      EXECUTE IMMEDIATE sql_updated_at INTO table_updated_at;
      
      DBMS_OUTPUT.PUT_LINE(num || ',' || table_name || ',' || table_count || ',' || table_updated_at)
      
      num := num + 1;
      FETCH table_names INTO table_name;
      EXIT WHEN table_names%NOTFOUND
    END;
  END LOOP;
  
  CLOSE table_names;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('No Data Found');
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Exception');
    IF table_names%ISOPEN THEN
      CLOSE table_names;
    END IF;
END;
/
Spool Off
