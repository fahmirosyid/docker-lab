import subprocess, json, psycopg2, re

conn = psycopg2.connect(host="localhost", dbname="labdb", user="labuser", password="labpass123")
cur = conn.cursor()
conn.autocommit = True

proc = subprocess.Popen(
    ["docker", "compose", "-f", "/home/hisyam/docker-lab/logging/docker-compose.yml", "logs", "fluent-bit", "-f", "--tail=0"],
    stdout=subprocess.PIPE, stderr=subprocess.DEVNULL, text=True
)

print("Inserting logs... Ctrl+C to stop")
count = 0
for line in proc.stdout:
    line = line.strip()
    match = re.search(r'\{.*\}', line)
    if not match:
        continue
    try:
        log = json.loads(match.group())
        cur.execute("""
            INSERT INTO logs.container_logs
                (date, timestamp, level, hostname, service, message, request_id, container_id, source_container, source)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
        """, (
            str(log.get("date", "")),
            str(log.get("timestamp", "")),
            log.get("level", ""),
            log.get("hostname", ""),
            log.get("service", ""),
            log.get("message", ""),
            log.get("request_id", ""),
            log.get("container_id", ""),
            log.get("source_container", ""),
            log.get("source", "")
        ))
        count += 1
        if count % 10 == 0:
            print(f"Inserted {count} logs...")
    except Exception as e:
        pass
