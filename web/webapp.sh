uniqueId=20210405
resourceGroup="group$uniqueId"
location='westus2'
appServicePlan="appservice$uniqueId"
webApp="webapp$uniqueId"

# Create an app service plan
az appservice plan create --name $appServicePlan \
                          --resource-group $resourceGroup \
                          --sku F1

# Create a web app
az webapp create --name $webApp \
                 --plan $appServicePlan \
                 --resource-group $resourceGroup \
                 --runtime python

# Deploy the web app
az webapp up \
    --resource-group $resourceGroup\
    --name $webApp \
    --sku F1 \
    --verbose \
    --html       