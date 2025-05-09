import cv2
import numpy as np
import mss
import time
import logging

logging.basicConfig(filename="screen_recorder.log", level=logging.INFO)

def record_screen():
    duration = 10  # segundos
    fps = 30
    width, height = 1920, 1080

    output = cv2.VideoWriter("screen_capture.avi", cv2.VideoWriter_fourcc(*"XVID"), fps, (width, height))

    print("Grabando pantalla...")
    logging.info("Inicio de grabación de pantalla.")

    try:
        with mss.mss() as sct:
            start = time.time()
            while time.time() - start < duration:
                img = np.array(sct.grab(sct.monitors[1]))
                frame = cv2.cvtColor(img, cv2.COLOR_BGRA2BGR)
                output.write(frame)
        print("Grabación finalizada.")
        logging.info("Grabación completada.")
    except Exception as e:
        print(f"Error durante la grabación: {e}")
        logging.error(f"Error en la grabación: {e}")
    finally:
        output.release()
