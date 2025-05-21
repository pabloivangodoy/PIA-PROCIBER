
import os
import PyPDF2
import logging

logging.basicConfig(filename="pdf_metadata.log", level=logging.INFO)

def extract_pdf_metadata(pdf_path):
    if not os.path.isfile(pdf_path):
        print("Archivo no encontrado.")
        return

    try:
        with open(pdf_path, "rb") as f:
            reader = PyPDF2.PdfReader(f)
            metadata = reader.metadata
            print(f"\nMetadatos del archivo {pdf_path}:")
            for key, value in metadata.items():
                print(f"{key}: {value}")
            print(f"Número de páginas: {len(reader.pages)}")
            logging.info(f"Analizado PDF: {pdf_path}")
    except Exception as e:
        print(f"Error al leer PDF: {e}")
        logging.error(f"Fallo al leer PDF: {pdf_path} - {e}")
