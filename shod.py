import shodan
import logging

logging.basicConfig(filename="shodan_scan.log", level=logging.INFO)

API_KEY = "vgUk6sLr5kx3iG0rKEMOkxt1QG1qida4"

def scan_port(port):
    try:
        port_int = int(port)
        query = f"port:{port_int}"
    except ValueError:
        print("El puerto debe ser un número.")
        return

    try:
        api = shodan.Shodan(API_KEY)
        results = api.search(query)
        print(f"Se encontraron {results['total']} resultados.\n")

        for i, result in enumerate(results["matches"][:5], 1):
            print(f"--- Resultado #{i} ---")
            print(f"IP: {result['ip_str']}")
            print(f"Organización: {result.get('org', 'N/A')}")
            print(f"País: {result.get('location', {}).get('country_name', 'N/A')}")
            print(f"Banner:\n{result['data']}\n")

        logging.info(f"Búsqueda en Shodan completada para el puerto {port}")
    except shodan.APIError as e:
        print(f"Error en Shodan: {e}")
        logging.error(f"Error Shodan - Puerto {port}: {e}")
