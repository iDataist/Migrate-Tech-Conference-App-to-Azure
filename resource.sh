# Variables for MongoDB API resources
uniqueId=20210420
resourceGroup="group$uniqueId"
location="westus2"
sqlServerName="sqlserver$uniqueId"
sqlDatabaseName="techconfdb"
clientIP=$(curl ifconfig.me)
storageAccount="blob$uniqueId"
serviceBus="servicebus$uniqueId"
quque="notificationqueue"
funcApp="funcapp$uniqueId"
appServicePlan="appservice$uniqueId"
webApp="webapp$uniqueId"
# Create a resource group
az group create \
    --name $resourceGroupName \
    --location $location
# Create a PostgreSQL server
az postgres server create \
    --location $location \
    --resource-group $resourceGroupName \
    --name $sqlServerName \
    --admin-user dbadmin \
    --admin-password p@ssword1234
# Create the firewall rule
az postgres server firewall-rule create \
    --resource-group $resourceGroupName \
    --server $sqlServerName \
    --name azureaccess \
    --start-ip-address 0.0.0.0 \
    --end-ip-address 255.255.255.255
echo "client IP address"
echo $clientIP
az postgres server firewall-rule create \
    --resource-group $resourceGroupName \
    --server $sqlServerName \
    --name clientip \
    --start-ip-address $clientIP \
    --end-ip-address $clientIP
# Get the connection information
az postgres server show \
    --resource-group $resourceGroupName \
    --name $sqlServerName 
# Create a SQL database
az postgres db create \
    --name $sqlDatabaseName \
    --resource-group $resourceGroupName \
    --server $sqlServerName 

# # Create a general-purpose storage account 
# az storage account create \
#     --resource-group $resourceGroup \
#     --name $storageAccount \
#     --location $location \
#     --sku Standard_LRS

# # create a Service Bus messaging namespace
# az servicebus namespace create \
# --resource-group $resourceGroup \
# --name $serviceBus \
# --location $location \
# --sku Basic

# # create a queue in the namespace
# az servicebus queue create \
# --resource-group $resourceGroup \
# --namespace-name $serviceBus \
# --name $quque \
# --enable-partitioning true

# # get the primary connection string for the namespace
# connectionString=$(az servicebus namespace authorization-rule keys list \
# --resource-group $resourceGroup \
# --namespace-name $serviceBus \
# --name RootManageSharedAccessKey \
# --query primaryConnectionString \
# --output tsv)

# echo "servicebus connection string"
# echo $connectionString

# # # initiate a local project folder
# # func init QueueFunc --python

# # cd QueueFunc

# # # initiate a function
# # func new --name QueueTrigger --template "Azure Service Bus Queue trigger" --language python

# # # initiate local python environment
# # pipenv shell
# # pipenv install

# # func start

# # Creat a function app
# az functionapp create \
#     --resource-group $resourceGroup \
#     --name $funcApp \
#     --storage-account $storageAccount \
#     --os-type Linux \
#     --consumption-plan-location $location \
#     --runtime python

# # # Deploy the function 
# # func azure functionapp publish funcapp20210411

# # Create an app service plan
# az appservice plan create --name $appServicePlan \
#                           --resource-group $resourceGroup \
#                           --sku F1

# # Create a web app
# az webapp create --name $webApp \
#                  --plan $appServicePlan \
#                  --resource-group $resourceGroup \
#                  --runtime python

# # Deploy the web app
# az webapp up \
#     --resource-group $resourceGroup\
#     --name $webApp \
#     --sku F1 \
#     --verbose \
#     --html           

