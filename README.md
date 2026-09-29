# variantes-NGS

Pipeline modular, reproducible en Nextflow (DSL2) para llamada de variantes germinales
a partir de datos de secuenciación NGS (WGS/WES). Control de calidad integrado en cada etapa.

## Flujo de trabajo:

FASTQ (raw)
   │
[FASTQC]  ── control de calidad inicial
   │
[FASTP]   ── recorte de adaptadores y filtrado por calidad
   │
[BWA-MEM2]── alineamiento contra genoma de referencia
   │
[SAMTOOLS SORT/INDEX]
   │
[MARK DUPLICATES] (Picard)
   │
[BCFTOOLS MPILEUP + CALL] ── llamada de variantes
   │
[BCFTOOLS FILTER]  ── filtrado por calidad/profundidad
   │
[MULTIQC] ── informe agregado de todas las métricas
   │
VCF filtrado + informe HTML


## Requisitos:
- [Nextflow](https://www.nextflow.io/) >= 23.04
- [Docker](https://www.docker.com/) o Singularity/Apptainer
- (Opcional) acceso a un clúster SLURM para el perfil `cluster`

## Uso:
# Test con datos sintéticos incluidos:
nextflow run main.nf -profile test,docker

# Ejecución real con tus propios datos:
nextflow run main.nf \
  -profile docker \
  --input samplesheet.csv \
  --genome assets/reference/genome.fa \
  --outdir results/

### Formato del samplesheet:
```csv
sample,fastq_1,fastq_2
sample1,/ruta/sample1_R1.fastq.gz,/ruta/sample1_R2.fastq.gz
sample2,/ruta/sample2_R1.fastq.gz,/ruta/sample2_R2.fastq.gz
```

## Parámetros principales:
| Parámetro         | Descripción                                   | Default        |
|--------------------|-----------------------------------------------|----------------|
| `--input`          | Ruta al samplesheet CSV                       | `null`         |
| `--genome`         | Referencia FASTA indexada                     | `null`         |
| `--outdir`         | Directorio de salida                          | `./results`    |
| `--min_depth`      | Profundidad mínima para filtrar variantes     | `10`           |
| `--min_qual`       | Calidad mínima (QUAL) para filtrar variantes  | `20`           |
| `--skip_multiqc`   | Omitir el informe agregado                    | `false`        |

Ver `nextflow.config` para la lista completa.

## Perfiles disponibles:
- `test`: usa datos sintéticos pequeños (`assets/test_data/`) para validar que el pipeline corre de punta a punta.
- `docker`: ejecuta cada proceso en su contenedor correspondiente.
- `cluster`: perfil orientado a SLURM (ajustar `conf/cluster.config` a tu entorno).

## Estructura del repositorio:
.
├── main.nf                
├── nextflow.config        
├── modules/               
├── conf/                  
├── assets/test_data/      
├── bin/                  
└── .github/workflows/    

## Salidas
```
results/
├── fastqc/
├── fastp/
├── alignment/          # BAM ordenados e indexados
├── variants/           # VCF crudo y filtrado
├── multiqc/            # informe HTML agregado
└── pipeline_info/      # trazas de ejecución, timeline, reporte de recursos
```
