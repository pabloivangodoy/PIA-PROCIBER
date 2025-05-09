import requests
import logging

logging.basicConfig(filename="ip_check.log", level=logging.INFO)

API_KEY = "1997e9e0a724138ea35f1b28483df058ae10fd0b8bdffe2bccdfe01248d38b57567197cf1b7a4a5c"

def check_ip_reputation(ip):
    url = "https://api.abuseipdb.com/api/v2/check"
    headers = {"Key": API_KEY, "Accept": "application/json"}
    params = {"ipAddress": ip, "maxAgeInDays": "90"}

    try:
        response = requests.get(url, headers=headers, params=params)
        response.raise_for_status()
        data = response.json()["data"]

        print(f"\nInformación de la IP {ip}:")
        print(f"- País: {data.get('countryCode')}")
        print(f"- ISP: {data.get('isp')}")
        print(f"- Reportes: {data.get('totalReports')}")
        print(f"- Confianza en abuso: {data.get('abuseConfidenceScore')}%")
        logging.info(f"Verificada IP: {ip}")
    except Exception as e:
        print(f"Error verificando IP: {e}")
        logging.error(f"Fallo al verificar IP: {ip} - {e}")
