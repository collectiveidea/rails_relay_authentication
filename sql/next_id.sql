CREATE sequence global_id_sequence;

CREATE OR REPLACE FUNCTION next_id(OUT result bigint) AS $$  
DECLARE
  our_epoch bigint := 1502383503000;
  seq_id bigint;
  now_millis bigint;
BEGIN  
  SELECT nextval('global_id_sequence') % 8388608 INTO seq_id;

  SELECT FLOOR(EXTRACT(EPOCH FROM clock_timestamp()) * 1000) INTO now_millis;
  result := (now_millis - our_epoch) << 23;
  result := result | (seq_id);
END;  
$$ LANGUAGE PLPGSQL;
