import cv2
import numpy as np
import mss
import time
import logging

logging.basicConfig(filename="screen_recorder.log", level=logging.INFO)

def record_screen():
    # Pedir valores al usuario
    try:
        duration = int(input("⏱️ Ingrese la duración en segundos (por defecto 10): ") or 10)
        fps = int(input("🎞️ Ingrese los FPS (por defecto 30): ") or 30)
        width = int(input("📐 Ingrese el ancho de resolución (por defecto 1920): ") or 1920)
        height = int(input("📐 Ingrese el alto de resolución (por defecto 1080): ") or 1080)
    except ValueError:
        print("⚠️ Entrada inválida. Se usarán valores por defecto.")
        duration, fps, width, height = 10, 30, 1920, 1080

    output_filename = "screen_capture.avi"
    output = cv2.VideoWriter(output_filename, cv2.VideoWriter_fourcc(*"XVID"), fps, (width, height))

    print(f"\n🔴 Grabando pantalla {width}x{height} a {fps} FPS durante {duration} segundos...")
    logging.info(f"Inicio de grabación: {width}x{height} @ {fps}fps por {duration}s.")

    try:
        with mss.mss() as sct:
            monitor = sct.monitors[1]  # pantalla completa
            start = time.time()
            while time.time() - start < duration:
                img = np.array(sct.grab(monitor))
                frame = cv2.cvtColor(img, cv2.COLOR_BGRA2BGR)
                frame_resized = cv2.resize(frame, (width, height))
                output.write(frame_resized)
        print("✅ Grabación finalizada. Guardado como:", output_filename)
        logging.info("Grabación completada.")
    except Exception as e:
        print(f"❌ Error durante la grabación: {e}")
        logging.error(f"Error en la grabación: {e}")
    finally:
        output.release()


