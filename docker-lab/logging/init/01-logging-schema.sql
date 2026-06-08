-- ==============================================
-- Schema untuk Centralized Logging
-- ==============================================
-- PENTING: Fluent Bit pgsql plugin INSERT ke kolom:
--   tag (varchar), time (timestamp), data (jsonb)
-- Jangan ubah nama kolom ini — harus persis sesuai plugin.
-- ==============================================

CREATE SCHEMA IF NOT EXISTS logs;

-- Tabel utama: format sesuai Fluent Bit pgsql plugin
CREATE TABLE logs.fluentbit (
    id       BIGSERIAL PRIMARY KEY,
    tag      VARCHAR(200),
    time     TIMESTAMP,
    data     JSONB
);

-- Index untuk performa query
CREATE INDEX idx_fb_time ON logs.fluentbit(time);
CREATE INDEX idx_fb_tag  ON logs.fluentbit(tag);
CREATE INDEX idx_fb_data ON logs.fluentbit USING GIN(data);

-- ==============================================
-- VIEWS: Parsing JSONB ke format readable
-- ==============================================

-- View: semua log dengan field diekstrak dari JSONB
CREATE OR REPLACE VIEW logs.parsed_logs AS
SELECT
    id,
    tag,
    time AS received_at,
    -- Container info (diisi oleh Docker fluentd driver)
    REPLACE(data->>'container_name', '/', '') AS container_name,
    LEFT(data->>'container_id', 12)           AS container_id,
    data->>'source'                           AS source,
    -- Isi log (bisa plain text atau JSON)
    data->>'log'                              AS raw_log,
    -- Jika log berbentuk JSON, ekstrak level dan message
    CASE
        WHEN (data->>'log')::jsonb IS NOT NULL
        THEN (data->>'log')::jsonb->>'level'
        ELSE NULL
    END AS log_level,
    CASE
        WHEN (data->>'log')::jsonb IS NOT NULL
        THEN (data->>'log')::jsonb->>'message'
        ELSE data->>'log'
    END AS message
FROM logs.fluentbit
ORDER BY time DESC;

-- View: log terbaru (100 entry)
CREATE OR REPLACE VIEW logs.recent_logs AS
SELECT
    id,
    to_char(time, 'YYYY-MM-DD HH24:MI:SS') AS time,
    tag,
    REPLACE(data->>'container_name', '/', '') AS container,
    data->>'source' AS source,
    LEFT(data->>'log', 200) AS log_preview
FROM logs.fluentbit
ORDER BY time DESC
LIMIT 100;

-- View: log yang berisi JSON — parsed level dan message
-- (untuk log-generator dan flask yang output structured JSON)
CREATE OR REPLACE VIEW logs.structured_logs AS
SELECT
    id,
    time AS received_at,
    tag,
    REPLACE(data->>'container_name', '/', '') AS container_name,
    (data->>'log')::jsonb->>'level'           AS log_level,
    (data->>'log')::jsonb->>'message'         AS message,
    (data->>'log')::jsonb->>'hostname'        AS hostname,
    (data->>'log')::jsonb->>'service'         AS service
FROM logs.fluentbit
WHERE data->>'log' IS NOT NULL
  AND LEFT(TRIM(data->>'log'), 1) = '{'
ORDER BY time DESC;

-- View: error summary per container
CREATE OR REPLACE VIEW logs.error_summary AS
SELECT
    REPLACE(data->>'container_name', '/', '') AS container_name,
    (data->>'log')::jsonb->>'level'           AS log_level,
    COUNT(*)                                  AS count,
    MAX(time)                                 AS last_seen
FROM logs.fluentbit
WHERE data->>'log' IS NOT NULL
  AND LEFT(TRIM(data->>'log'), 1) = '{'
  AND (data->>'log')::jsonb->>'level' IN ('ERROR', 'WARN', 'CRITICAL')
GROUP BY 1, 2
ORDER BY count DESC;

-- Fungsi: cleanup log > 30 hari
CREATE OR REPLACE FUNCTION logs.cleanup_old_logs()
RETURNS INTEGER AS $$
DECLARE
    deleted_count INTEGER;
BEGIN
    DELETE FROM logs.fluentbit
    WHERE time < NOW() - INTERVAL '30 days';
    GET DIAGNOSTICS deleted_count = ROW_COUNT;
    RETURN deleted_count;
END;
$$ LANGUAGE plpgsql;


