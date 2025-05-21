import os
import subprocess
import hashlib
import datetime
from ver_pi_n import check_ip_reputation
from busqueda_pd_n import extract_pdf_metadata
from grab_pant_n import record_screen
from contseg_n import check_password  # Módulo de verificación de contraseñas

# === Configuración global ===
RUTA_PSMODULES = os.path.join(os.getcwd(), "ps_scripts")
RUTA_REPORTES = os.path.join(os.getcwd(), "reportes")
os.makedirs(RUTA_REPORTES, exist_ok=True)

def ejecutar_powershell(archivo, funcion, parametros=""):
    comando = f'''
    Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force
    Import-Module "{os.path.join(RUTA_PSMODULES, archivo)}"
    {funcion} {parametros}
    '''
    try:
        resultado = subprocess.run(
            ["powershell", "-Command", comando],
            capture_output=True, text=True, timeout=60
        )
        if resultado.stderr.strip():
            print("Error PowerShell:", resultado.stderr)
        return resultado.stdout.strip()
    except Exception as e:
        print(f"Error al ejecutar PowerShell: {e}")
        return ""

def generar_hash(contenido):
    return hashlib.sha256(contenido.encode()).hexdigest()

def guardar_reporte(nombre_tarea, contenido):
    ahora = datetime.datetime.now().strftime("%Y-%m-%d_%H-%M-%S")
    nombre_archivo = f"{nombre_tarea}_{ahora}.txt"
    ruta_completa = os.path.join(RUTA_REPORTES, nombre_archivo)
    hash_contenido = generar_hash(contenido)
    
    with open(ruta_completa, "w", encoding="utf-8") as f:
        f.write(f"Tarea: {nombre_tarea}\n")
        f.write(f"Fecha: {ahora}\n")
        f.write(f"Hash: {hash_contenido}\n")
        f.write(f"Ruta: {ruta_completa}\n\n")
        f.write("=== Resultado ===\n")
        f.write(contenido)

    print(f"\n✅ Reporte guardado: {ruta_completa}")
    print(f"Hash del reporte: {hash_contenido}")

def show_menu():
    print("\n--- Menú Principal de Ciberseguridad ---")
    print("1. Verificar reputación de IP (Python)")
    print("2. Analizar metadatos de PDF (Python)")
    print("3. Grabar pantalla (Python)")
    print("4. Buscar archivos ocultos (PowerShell)")
    print("5. Listar procesos sospechosos (PowerShell)")
    print("6. Verificar seguridad de contraseña (Python)")
    print("7. Salir")

def menu_loop():
    while True:
        show_menu()
        opcion = input("Seleccione una opción (1-7): ").strip()
        if opcion == "1":
            ip = input("Ingrese la IP: ").strip()
            print("Ejecutando verificación de IP...")
            resultado = check_ip_reputation(ip)
            if resultado:
                guardar_reporte("Reputacion_IP", str(resultado))
            else:
                print("No se obtuvo resultado.")
        elif opcion == "2":
            ruta_pdf = input("Ingrese la ruta del PDF: ").strip()
            print("Analizando metadatos del PDF...")
            resultado = extract_pdf_metadata(ruta_pdf)
            if resultado:
                guardar_reporte("Metadatos_PDF", str(resultado))
            else:
                print("No se obtuvo resultado.")
        elif opcion == "3":
            print("Iniciando grabación de pantalla...")
            record_screen()
            print("Grabación terminada.")
        elif opcion == "4":
            ruta = input("Ingrese la ruta para buscar archivos ocultos (ENTER = C:\\Users\\Public): ").strip()
            ruta = ruta if ruta else "C:\\Users\\Public"
            print("Buscando archivos ocultos...")
            salida = ejecutar_powershell("GetArchivos.psm1", "Get-HiddenFiles", f"-FolderPath '{ruta}'")
            if salida:
                guardar_reporte("Archivos_Ocultos", salida)
            else:
                print("No se encontró salida o hubo un error.")
        elif opcion == "5":
            print("Listando procesos sospechosos...")
            salida = ejecutar_powershell("GetProcesos.psm1", "Get-SuspiciousProcesses")
            if salida:
                guardar_reporte("Procesos_Sospechosos", salida)
            else:
                print("No se encontró salida o hubo un error.")
        elif opcion == "6":
            password = input("Ingrese la contraseña a verificar: ").strip()
            print("Verificando seguridad de contraseña...")
            resultado = check_password(password)
            if resultado:
                guardar_reporte("Verificacion_Contrasena", str(resultado))
            else:
                print("No se obtuvo resultado.")
        elif opcion == "7":
            print("Saliendo...")
            break
        else:
            print("Opción inválida, por favor intente de nuevo.")

if __name__ == "__main__":
    menu_loop()
