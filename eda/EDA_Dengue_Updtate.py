# Databricks notebook source
from pyspark.sql.functions import *
from pyspark.sql.types import *

# COMMAND ----------

# MAGIC %md
# MAGIC ## Lectura dataset

# COMMAND ----------

df_dengue = spark.read.csv("dbfs:/FileStore/_bigdata/ANALISIS_DATOS_DENGUE_UCONTINENTAL_LIMPIA.csv", header=True, inferSchema=False)
display(df_dengue)

# COMMAND ----------

df_dengue.printSchema()

# COMMAND ----------

# MAGIC %md
# MAGIC ## Conteo de registros nulos

# COMMAND ----------

null_counts = df_dengue.select([count(when(col(c).isNull(), c)).alias(c) for c in df_dengue.columns])
display(null_counts)

# COMMAND ----------

# MAGIC %md
# MAGIC ## Descarte de columnas por cantidad de registros nulos

# COMMAND ----------

# Umbral para  nulos (50%)
threshold = 0.5

# Número total de filas
total_rows = df_dengue.count()

# Filtrar columnas con nulos por encima del umbral
columns_to_drop = [c for c in null_counts.columns if null_counts.collect()[0][c] / total_rows > threshold]

# Eliminar las columnas
df_cleaned = df_dengue.drop(*columns_to_drop)


# COMMAND ----------

# MAGIC %md
# MAGIC ## Schema del nuevo df

# COMMAND ----------

df_cleaned.count()

# COMMAND ----------

df_cleaned.printSchema()

# COMMAND ----------

display(df_cleaned)

# COMMAND ----------

# MAGIC %md
# MAGIC ## Outliers

# COMMAND ----------

numeric_cols = [f.name for f in df_cleaned.schema.fields if isinstance(f.dataType, (IntegerType, FloatType, DoubleType))]

# Calculamos el IQR para cada columna numérica
from pyspark.sql.functions import expr

def calculate_iqr(df, column):
    q1 = df.approxQuantile(column, [0.25], 0.01)[0]
    q3 = df.approxQuantile(column, [0.75], 0.01)[0]
    iqr = q3 - q1
    lower_bound = q1 - 1.5 * iqr
    upper_bound = q3 + 1.5 * iqr
    return lower_bound, upper_bound

outliers = {}
for col in numeric_cols:
    lower_bound, upper_bound = calculate_iqr(df_cleaned, col)
    outliers[col] = (lower_bound, upper_bound)

# Opcional: Filtrar outliers
df_no_outliers = df_cleaned
for col, (lower, upper) in outliers.items():
    df_no_outliers = df_no_outliers.filter((col >= lower) & (col <= upper))


# COMMAND ----------

# MAGIC %md
# MAGIC ## DF sin outliers

# COMMAND ----------

display(df_no_outliers)

# COMMAND ----------

df_no_outliers.printSchema()

# COMMAND ----------

dbfs_path = "dbfs:/FileStore/_bigdata/data_output/dengue_clean.csv"

# COMMAND ----------

df_no_outliers.write.option("header", "true").csv(dbfs_path)

# COMMAND ----------

df_no_outliers.coalesce(1).write.option("header", "true").csv(dbfs_path)
