# Databricks notebook source
import json
dbutils.widgets.text("target", "unknown")
target = dbutils.widgets.get("target")
who = spark.sql("select current_user()").first()[0]
rows = spark.sql("select count(*) from workspace.off_verify.catalogue_test").first()[0]
dbutils.notebook.exit(json.dumps({"target": target, "run_as": who, "catalogue_test_rows_visible": int(rows)}))
