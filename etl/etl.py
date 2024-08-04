import pandas as pd
import pyodbc

# Conexión a la base de datos
conn = pyodbc.connect(
    'DRIVER={ODBC Driver 17 for SQL Server};'
    'SERVER=ACHI\SQLEXPRESS;'
    'DATABASE=Dengue_Datamart;'
    'Trusted_Connection=yes;'
)

# Lectura de datos de origen
df_source = pd.read_csv("data_source/data_dengue.csv", low_memory=False)

# Crear DataFrame según dimensiones
cols_DimFecha = ['fecha_not', 'fecha_inv', 'fecharegw']
df_DimFecha = df_source[cols_DimFecha].copy()

# Convertir las columnas a datetime
df_DimFecha['fecha_not'] = pd.to_datetime(df_DimFecha['fecha_not'], format='%d/%m/%Y', dayfirst=True)
df_DimFecha['fecha_inv'] = pd.to_datetime(df_DimFecha['fecha_inv'], format='%d/%m/%Y', dayfirst=True)
df_DimFecha['fecharegw'] = pd.to_datetime(df_DimFecha['fecharegw'], format='%d/%m/%Y %H:%M', dayfirst=True)

# Eliminar duplicados globalmente en todas las columnas
df_DimFecha = df_DimFecha.drop_duplicates(subset=['fecha_not', 'fecha_inv', 'fecharegw'], keep='first')

# Insertar datos en la tabla SQL Server
cursor = conn.cursor()

# Nombre de la tabla en SQL Server
table_name = 'DimFecha'

# Transacción para insertar datos
try:
    for index, row in df_DimFecha.iterrows():
        cursor.execute(f"""
            INSERT INTO {table_name} (FechaNot, FechaInv, FechaRegw)
            VALUES (?, ?, ?)
        """, row['fecha_not'], row['fecha_inv'], row['fecharegw'])
    
    # Confirmar los cambios
    conn.commit()
except Exception as e:
    # Deshacer los cambios en caso de error
    conn.rollback()
    print(f"Error: {e}")
finally:
    # Cerrar el cursor y la conexión
    cursor.close()
    conn.close()
