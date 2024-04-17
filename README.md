# Energy maket insights
### Analysis of electricity production in Germany

## Problem

In Europe, transitioning to renewable energy sources is crucial for meeting climate goals. However, there is a lack of clear, timely visibility into the shares of renewable versus fossil fuel energy sources in electricity production. This gap makes it difficult to effectively assess and manage progress toward a more sustainable energy supply. A detailed understanding of the current landscape of energy production in real-time is necessary to support policy and economic decisions that promote renewable energy use and reduce dependence on fossil fuels.

## Introduction

The **Energy Market Insights** project tackles the challenge of streamlining data management for European energy production metrics by deploying a sophisticated data engineering pipeline. Using "mage.ai" for orchestration within a Docker container, this system automates the ETL (extract, transform, load) processes required to analyze energy data. Managed via Terraform on AWS, the infrastructure is ready to use in a few clicks and supports a seamless data flow from extraction from the [ENTSO-E](https://transparency.entsoe.eu/) API to storage in a Redshift data warehouse. From this data, it is now possible to provide graphical and understandable insights into the data situation.

data cource: https://transparency.entsoe.eu/





## Table of Contents

- [Introduction](#introduction)
- [System Architecture](#system-architecture)
- [Dependencies](#dependencies)
- [Installation](#installation)
- [Usage](#usage)
- [Pipeline Details](#pipeline-details)
- [Dashboard](#dashboard)
- [Configuration](#configuration)
- [Contributors](#contributors)
- [License](#license)

## System Architecture

![System Architecture Diagram](img/infra.png)  

This project uses Terraform to set up the data infrastructure on AWS. The primary components include:
- **Mage.ai Instance**: Orchestrates the data pipeline within a Docker container.
- **Redshift Cluster**: Acts as the data warehousing solution.
- **RDS database** for storing mage meta data
- **S3 bucket** as a data lake
- **AWS faregate** to hsot the container
- **load balancer and auto scaling** to scale the mage ui if it encounters heavy load
- and some configuration for **IAM** and **network**

Local Docker configurations for testing are available in the `/mage` folder, with AWS configurations defined within Terraform manifests in `/aws-infra`.

## **Dependencies**

If you want to reproduce this project you will need:

- an AWS account and locally set service account credentials
- Terraform installed on your local machine

You wonder how to do this? Find a tutorial [hier](https://spacelift.io/blog/terraform-tutorial).

## Installation

Clone the project repository:

```
git clone https://github.com/d-gilles/energy_data_insides
```

**Variables** and **settings** can be modified in the **`aws-infra/terraform.tfvars`**.

## Usage

You can run all commands from the root directory of the project.
To initialize terraform run:
```
make init
```

To set up the AWS infrastructure:

```
make setup_aws
```

After setting up the infrastructure, you may need to wait a few minutes for the AWS components to initialize fully. Once ready, you can start the Mage UI in your browser:

```bash
make start_ui
```

To list the contents of the S3 datalake:

```bash
make s3list
```

To turn off all services and destroy the AWS setup:

```bash
make off
```

## **Pipeline Details**

![System Architecture Diagram](img/pipeline.png)  

The data pipeline performs the following operations:

1. **Data Ingestion**: Loads data from the ENTSO-E API, which provides energy production data across Europe.
2. **Data Cleaning**: Validates and cleans data, renaming columns and storing cleaned versions locally.
3. **Data Loading**: Uploads the cleaned data to an S3 datalake and writes it into a Redshift table.
4. **Data Transformation**

## Transformations
Two dtb models, that perform the following:
- Aggregates daily data into summary entries.
- Separates energy production types into fossil and renewable categories, summarized daily.

## **Dashboard**

The AWS QuickSight dashboard includes:

- A stacked line (area) chart of the last week's energy production, updated every 15 minutes.
- A graph providing insights into energy trends. Suggestion: Compare fossil vs. renewable energy production over the last month.





## notes
das sind notizen zum erstellen einer README.md zum einem keystone project des data talks club data engineering zoomcamps 2024.

ich benötige für meine abschlussarbeit eines data engineering bootcamps eine readme.md für mein github repo. 

das project mach folgendes:
- es nutzt terraform, um eine daten infrastructur auf aws aufzusetzen. die kernkomponeneten dieser infrastructur sind eine mage.ai instance, die zur orkestrierung der data pipeline eingesetzt wird, in einem docker container und ein redshift cluster, der als dwh dient. (note: ein diagramm kann eingefügt werden)
- der ordner mage enthält die docker configuration für locales testen. Die eigentliche configuration des Container aus AWS wird über das terraform manifest definiert. diese basiert auf dem officiellen maige docker image, das bei start durch ein start script ergänzt wird. diese script läd die benötigte mage pipeline aus einem weiteren  und requerements.txt direkt in den laufenden container und installiert alle für das project nötigen komponenten.
- die pipeline führt folgende schritte aus:
   - sie läd daten über die stromproduction in deutschland von einer API auf der seite entsoe.eu, die daten über die energie produktion in europa bereitstellt.
   - die daten werden in batches zu je einem tag mit einträgen alle 15 min geladen. und local gespeichert
   - die daten werden geprüft, bereinigt, die spalten namen werden angepasset und die bereinigte datei wird auch local abgelegt 
   - die bereinigten daten werden auf einen S3 bucket (datalake) geladen
   - die bereinigten daten werden in einen redshift table (energy_production) geschrieben
   - wenn alle schritte bis hierher erfolgreich waren, werden die local gespeicherten daten gelöscht.
 
Transformer:
- ein transformer (sql) nimmt die daten von einem tag (96 stk) und agregiert diese zu einem einzigen eintrag in einem neuen table (energy_prod_day)
- ein transformer nimmt diese daten und aggregiert diese zu einem weiterein table (energy_prod_kind) in dem pro tag nur noch 2 wert stehen: fossil und renewable

Dashboard:
Am ende wird manuel ein aws quickside dashboard erstellt, das 3 graphen enthält.
- einen gestapleten line(area) chart mit allen einträgen (frequenz 15 min.) der letzen Woche, gestapelt alle unteschiedlichern energie produktions arten 
- sowie einen weitern graph mit interssanten insides (mach gerne einen vorschlag)

Makefile:
(hier ist der gesamte inhalt des makefiles:
setup_aws:
	cd ./aws-infra && \
	terraform apply

start_ui:
	# Open the mage ui in browser.
	# Wait a view minutes after setting up the infrastructure.
	# The load balancer takes some time to fully spin up.
	@echo "Opening URL from alb_dns_name.txt..."
	@url=$$(cat ./aws-infra/infra_details/alb_dns_name.txt); \
	if ! echo "$$url" | grep -q "^http://\|^https://"; then \
		url="http://$$url"; \
	fi; \
	echo "Formatted URL: $$url"; \
	open "$$url" # Use 'xdg-open' on Linux

s3list:
	# List the content of your S3 datalake
	@bucket_name=$$(cat ./aws-infra/infra_details/bucketname.txt); \
	aws s3 ls s3://"$$bucket_name"

off:
	cd ./aws-infra && \
	terraform destroy)


Variablen können in der aws_infra/terraform.tfvars geändert werden.

das project liegt hier: https://github.com/d-gilles/energy_data_insides
die data pipeline liegt hier: https://github.com/d-gilles/energy_data_etl
die pipeline wird beim starten des containers auf aws automatisch in den container geladen und steht in der ui zur verfügung.

reproduzieren:
wenn sie das benötigen sie folgende dinge:
- aws account 
- service account credentials local eingerichted (benötigt terraform zum einrichten der infrastruktur)
- das geclonte github repo des projects

einrichten:
- make setup_aws
nachdem der vorgang abgeschlossen ist, benötigt aws eine weile um den Container breeit zu stellen, dies kann ein paar minuten dauern.
- make start_ui
dies öffnet die mage ui in ihrem browser

die daten pipeline ist bereits vorhanden, sie  müssen nun lediglich einen backfill ausführen um die daten von der api in ihre redshift dwh zu schreiben.

