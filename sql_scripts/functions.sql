CREATE OR REPLACE FUNCTION update_nulls_to_zero(table_name TEXT, column_names TEXT[])
RETURNS VOID AS $$
DECLARE
    column_name TEXT;
BEGIN
    FOREACH column_name IN ARRAY column_names
    LOOP
        EXECUTE format('UPDATE %I SET %I = 0 WHERE %I IS NULL', table_name, column_name, column_name);
    END LOOP;
END;
$$
 LANGUAGE plpgsql;