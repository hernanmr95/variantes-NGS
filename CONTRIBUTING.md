# Contribuir a variant-calling-nf

¡Gracias por tu interés! Este pipeline sigue las convenciones habituales de
la comunidad Nextflow/nf-core en la medida de lo posible.

## Flujo de trabajo

1. Haz un fork del repositorio y crea una rama descriptiva (`feature/anotacion-vep`).
2. Añade o modifica el módulo correspondiente en `modules/`.
3. Si añades un parámetro nuevo, documéntalo en `nextflow.config` y en el README.
4. Verifica que el perfil de test sigue funcionando:
   ```bash
   nextflow run main.nf -profile test,docker
   ```
5. Abre un Pull Request describiendo el cambio y su motivación.

## Estilo de los módulos

Cada proceso debe:
- Tener un `container` explícito (preferiblemente de biocontainers/Bioconda).
- Declarar `label` (`low`, `medium`, `high`) acorde a su consumo esperado.
- Usar `publishDir` solo para salidas que el usuario final necesita inspeccionar.
- Evitar rutas absolutas o dependencias del entorno local.

## Reportar bugs

Abre un issue incluyendo: comando ejecutado, perfil usado, versión de
Nextflow (`nextflow -version`) y el mensaje de error completo (o el archivo
`.nextflow.log`).
