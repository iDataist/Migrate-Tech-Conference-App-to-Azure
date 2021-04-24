# TechConf Registration Website

## Project Overview
The TechConf website allows attendees to register for an upcoming conference. Administrators can also view the list of attendees and notify all attendees via a personalized email message.

The application works but the following pain points have triggered the need for migration to Azure:
 - The web application is not scalable to handle user load at peak.
 - When the admin sends out notifications, it's currently taking a long time because it's looping through all attendees, resulting in some HTTP timeout exceptions.
 - The current architecture is not cost-effective.

I migrated the application to Azure in the following steps: 
- Migrated a PostgreSQL database backup to an Azure Postgres database instance
- Refactored the notification logic to an Azure Function via a service bus queue message
- Migrated and deployed the web app to an Azure App Service



## Dependencies

You will need to install the following locally:
- [Postgres](https://www.postgresql.org/download/)
- [Visual Studio Code](https://code.visualstudio.com/download)
- [Azure Function tools V3](https://docs.microsoft.com/en-us/azure/azure-functions/functions-run-local?tabs=windows%2Ccsharp%2Cbash#install-the-azure-functions-core-tools)
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)
- [Azure Tools for Visual Studio Code](https://marketplace.visualstudio.com/items?itemName=ms-vscode.vscode-node-azure-pack)

## Steps to deploy the webapp in Azure

1. Create the PostgreSql server in Azure by running the command below. The output should look like [1_postgresql.txt](https://github.com/iDataist/Migrate-Tech-Conference-App-to-Azure/blob/main/output/1_postgresql.txt). 
    ```
    bash postgresql.sh
    ```
2. Open pgAdmin, connect to the Azure PostgreSql server, restore the database from [techconfdb_backup.tar](https://github.com/iDataist/Migrate-Tech-Conference-App-to-Azure/blob/main/data/techconfdb_backup.tar), and modify the dataytpe for the id column in the attendee and notification tables using the [modify_id_datatype.sql](https://github.com/iDataist/Migrate-Tech-Conference-App-to-Azure/blob/main/data/modify_id_datatype.sql) script. 
    ![](output/add_azure_server_1.png)
    ![](output/add_azure_server_2.png)
    ![](output/restore.png)
    ![](output/modify_id.png)
3. Initiate the Azure Functions and update the [__init__.py](https://github.com/iDataist/Migrate-Tech-Conference-App-to-Azure/blob/main/function/QueueTrigger/__init__.py) file to customize the function. Refactor the post logic in `web/app/routes.py -> notification()` using servicebus `queue_client`.  

   ```bash
   # initiate local python environment
   pipenv shell
   pipenv install

   # initiate a local project folder
   func init function --python

   cd function

   # initiate a function
   func new --name QueueTrigger --template "Azure Service Bus Queue trigger" --language python
   ``` 
4. Create the function app resources in Azure by running the command below. The output should look like [3_funcapp.txt](https://github.com/iDataist/Migrate-Tech-Conference-App-to-Azure/blob/main/output/3_funcapp.txt). 
    ```
    bash funcapp.sh
    ```
5. Create the service bus resources in Azure by running the command below. The output should look like [2_servicebus.txt](https://github.com/iDataist/Migrate-Tech-Conference-App-to-Azure/blob/main/output/2_servicebus.txt). 
    ```
    bash servicebus.sh
    ```

6. Update "AzureWebJobsStorage", "AzureWebJobsServiceBus" and "SENDGRID_API_KEY" in local.settings.json and the function app configuration from the Azure portal. 
    ![](output/funcapp_config.png)
    Update the following in the `config.py` file: 
      - `POSTGRES_URL`
      - `POSTGRES_USER`
      - `POSTGRES_PW`
      - `POSTGRES_DB`
      - `SERVICE_BUS_CONNECTION_STRING`
7. Test the function app and webapp locally.
   ```bash
   cd function

   # initiate local python environment
   pipenv shell
   pipenv install

   # test func locally
   func start
   ``` 
    ```bash
    # cd into NeighborlyFrontEnd
    cd web

    # install dependencies
    pipenv install

    # go into the shell
    pipenv shell

    # test the webapp locally
    python application.py   
    ```
8. Deploy the function app and the webapp with Azure.
    ```bash
    # cd into NeighborlyAPI
    cd function

    # install dependencies
    pipenv install

    # go into the shell
    pipenv shell

    # deploy Azure Functions
    func azure functionapp publish funcapp20210405
    ```
    ```bash
    # cd into NeighborlyFrontEnd
    cd web

    # install dependencies
    pipenv install

    # go into the shell
    pipenv shell

    # deploy the webapp 
    az webapp up \
        --resource-group group20210405 \
        --name techconf2022 \
        --sku F1 
    ```

## [Monthly Cost Analysis](https://azure.microsoft.com/en-us/pricing/calculator/)

| Azure Resource | Service Tier | Monthly Cost |
| ------------ | ------------ | ------------ |
| *Azure Postgres Database* | General Purpose | $127.90       |
| *Azure Service Bus*   |   Basic      |     $0.05         |
| *Azure App Service*   |   Basic      |       $54.75       |
| *Azure Function App*   |   Consumption   |    $0.00         |
| *Azure Storage*   |   Standard      |       $20.80       |
## Architecture Explanation
 - The web application is scalable to handle user load at peak.
 - The function app is scalable. When the admin sends out notifications, there will not be HTTP timeout exceptions. 
 - The architecture is cost-effective. All the services are reasonably priced.