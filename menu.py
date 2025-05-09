from ver_pi import check_ip_reputation
from busqueda_pd import extract_pdf_metadata
from contseg import check_password
from grab_pant import record_screen
from shod import scan_port

def main():
    while True:
        print("\n--- Menú Principal de Ciberseguridad ---")
        print("1. Verificar reputación de IP")
        print("2. Analizar metadatos de PDF")
        print("3. Verificar seguridad de contraseña")
        print("4. Grabar pantalla")
        print("5. Escanear puerto con Shodan")
        print("6. Salir")

        try:
            choice = int(input("Seleccione una opción: "))
        except ValueError:
            print("Por favor ingrese un número válido.")
            continue

        if choice == 1:
            ip = input("Ingrese la IP a verificar: ")
            check_ip_reputation(ip)
        elif choice == 2:
            path = input("Ruta del archivo PDF: ")
            extract_pdf_metadata(path)
        elif choice == 3:
            pwd = input("Ingrese la contraseña a verificar: ")
            check_password(pwd)
        elif choice == 4:
            record_screen()
        elif choice == 5:
            port = input("Ingrese el puerto a escanear: ")
            scan_port(port)
        elif choice == 6:
            print("Saliendo del programa...")
            break
        else:
            print("Opción no válida. Intente de nuevo.")

if __name__ == "__main__":
    main()
