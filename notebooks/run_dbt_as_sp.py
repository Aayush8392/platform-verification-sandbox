# Databricks notebook source
# MAGIC %pip install -q dbt-databricks

# COMMAND ----------
dbutils.library.restartPython()

# COMMAND ----------
# Runs dbt as a service principal: the warehouse sees the service principal as the writer, not the job owner.
import json, os, tempfile
dbutils.widgets.text("warehouse_id", "")
dbutils.widgets.text("schema", "gold_probe")
host = spark.conf.get("spark.databricks.workspaceUrl")
profile = f"""databricks:
  target: prod
  outputs:
    prod:
      type: databricks
      host: {host}
      http_path: /sql/1.0/warehouses/{dbutils.widgets.get("warehouse_id")}
      catalog: workspace
      schema: {dbutils.widgets.get("schema")}
      auth_type: oauth
      client_id: {dbutils.secrets.get("off-pipeline", "sp_client_id")}
      client_secret: {dbutils.secrets.get("off-pipeline", "sp_client_secret")}
"""
d = tempfile.mkdtemp()
open(os.path.join(d, "profiles.yml"), "w").write(profile)
project = os.path.abspath(os.path.join(os.getcwd(), "..", "dbt_project"))
from dbt.cli.main import dbtRunner
res = dbtRunner().invoke(["build", "--project-dir", project, "--profiles-dir", d, "--target-path", os.path.join(d, "target"), "--log-path", os.path.join(d, "logs")])
summary = [{"node": r.node.name, "status": str(r.status)} for r in (res.result.results if res.result else [])]
if not res.success:
    raise Exception("dbt build failed: " + json.dumps(summary) + " | project=" + project + " exists=" + str(os.path.exists(project)) + " cwd=" + os.getcwd() + " | exception=" + str(res.exception).replace(chr(10), " ")[:1200])
dbutils.notebook.exit(json.dumps({"success": True, "results": summary}))
