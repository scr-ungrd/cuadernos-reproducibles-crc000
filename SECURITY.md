# Política de seguridad

Es la plantilla de cuaderno reproducible de la colección: no tiene servidores, cuentas de usuario ni credenciales. Aun así, cuida los riesgos propios de un repositorio abierto: secretos, datos personales, rutas locales, dependencias y automatización.

## Versiones compatibles

Se mantiene la última versión publicada en el [sitio](https://scr-ungrd.github.io/cuadernos-reproducibles-crc000/).

## Cómo reportar una vulnerabilidad o una filtración

Escriba a conocimiento@gestiondelriesgo.gov.co e indique el archivo, la línea y qué se expone. No publique el detalle en un *issue* ni en un *pull request*. Acusamos recibo y respondemos por el mismo medio.

## Si se filtra un secreto o un dato personal

1. Revocar o rotar la credencial en el proveedor. Borrar el archivo no basta.
2. Retirar el contenido del repositorio y, si el dato ya se archivó, pedir a Zenodo la retirada o la restricción del registro.
3. Avisar a las personas afectadas.
4. Anotar el incidente en el historial de cambios del repositorio.

## Controles que se aplican

- Escaneo de secretos del árbol y del historial antes de cada *release*, con el resultado archivado en [`metadata/escaneo_seguridad.md`](metadata/escaneo_seguridad.md).
- Dependencias con versión exacta en [`environment.yml`](environment.yml) y auditoría de vulnerabilidades con `pip-audit`.
- Flujo de despliegue con permisos mínimos, y herramientas de compilación con versión fijada y suma de verificación.

Los requisitos completos están en [Requisitos de seguridad](https://scr-ungrd.github.io/cuadernos-reproducibles/requisitos-seguridad) de la colección.
