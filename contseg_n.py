import re
import logging

logging.basicConfig(filename="password_check.log", level=logging.INFO)

def check_password(password):
    valid = True
    messages = []

    if len(password) < 8:
        valid = False
        messages.append("Debe tener al menos 8 caracteres.")
    if not re.search(r"[A-Z]", password):
        valid = False
        messages.append("Debe contener al menos una mayúscula.")
    if not re.search(r"[a-z]", password):
        valid = False
        messages.append("Debe contener al menos una minúscula.")
    if not re.search(r"\d", password):
        valid = False
        messages.append("Debe contener al menos un número.")
    if not re.search(r"[^A-Za-z0-9]", password):
        valid = False
        messages.append("Debe contener al menos un carácter especial.")

    if valid:
        print("La contraseña es segura.")
        logging.info("Contraseña verificada con éxito.")
    else:
        print("La contraseña no es segura:")
        for msg in messages:
            print(f"- {msg}")
        logging.warning("Contraseña débil verificada.")
