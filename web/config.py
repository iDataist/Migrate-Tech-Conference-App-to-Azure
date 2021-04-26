import os

app_dir = os.path.abspath(os.path.dirname(__file__))

class BaseConfig:
    DEBUG = True
    POSTGRES_URL='sqlserver20210405.postgres.database.azure.com'
    POSTGRES_USER='dbadmin@sqlserver20210405'
    POSTGRES_PW='p@ssword1234'
    POSTGRES_DB='techconfdb'
    DB_URL = 'postgresql://{user}:{pw}@{url}/{db}'.format(user=POSTGRES_USER,pw=POSTGRES_PW,url=POSTGRES_URL,db=POSTGRES_DB)
    SQLALCHEMY_DATABASE_URI = os.getenv('SQLALCHEMY_DATABASE_URI') or DB_URL
    CONFERENCE_ID = 1
    SECRET_KEY = 'LWd2tzlprdGHCIPHTd4tp5SBFgDszm'
    SERVICE_BUS_CONNECTION_STRING ='Endpoint=sb://servicebus20210405.servicebus.windows.net/;SharedAccessKeyName=RootManageSharedAccessKey;SharedAccessKey=Jczh/N2LvYlsSsmZv4OuzDcIyd89fuaNdvbSL3GAQ7A=' 
    SERVICE_BUS_QUEUE_NAME ='notificationqueue'
    # ADMIN_EMAIL_ADDRESS: 'hui.ren@idataist.com'
    # SENDGRID_API_KEY = '' 

class DevelopmentConfig(BaseConfig):
    DEBUG = True


class ProductionConfig(BaseConfig):
    DEBUG = False