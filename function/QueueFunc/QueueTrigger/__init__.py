export PATH=~/anaconda3/bin:$PATH
import logging
import azure.functions as func
import psycopg2
import os
from datetime import datetime
from sendgrid import SendGridAPIClient
from sendgrid.helpers.mail import Mail
from datetime import date

def main(msg: func.ServiceBusMessage):

    notification_id = int(msg.get_body().decode('utf-8'))
    logging.info('Python ServiceBus queue trigger processed message: %s',notification_id)

    # Get connection to database
    conn = psycopg2.connect(dbname="techconfdb", user="dbadmin@sqlserver20210405", password="p@ssword1234", host="sqlserver20210405.postgres.database.azure.com")
    cur = conn.cursor()
    try:
        # Get notification message and subject from database using the notification_id
        subject = cur.execute("SELECT subject FROM notification WHERE id={};".format(notification_id))
        body = cur.execute("SELECT message FROM notification WHERE id={};".format(notification_id))

        # Get attendees email and name
        attendees = cur.execute("SELECT email, first_name FROM attendee;").fetchall()
        # Loop through each attendee and send an email with a personalized subject
        num_attendee_notified = 0
        for (email, first_name) in attendees:
            mail = Mail(
                from_email='hui.ren@idataist.com',
                to_emails= email,
                subject= subject,
                plain_text_content= "Hi {}, \n {}".format(first_name, body))
            try:
                sg = SendGridAPIClient(os.environ.get('SENDGRID_API_KEY'))
                response = sg.send(mail)
                if response.status_code == "200":
                    num_attendee_notified += 1
            except Exception as e:
                print(e.message)
        status = "{} of attendees notified".format(num_attendee_notified)
        # Update the notification table by setting the completed date and updating the status with the total number of attendees notified
        cur.execute("UPDATE notification SET status = {}, completed_data = {} WHERE id = {};".format(status, date.today(), notification_id))
    except (Exception, psycopg2.DatabaseError) as error:
        logging.error(error)
    finally:
        # Close connection
        cur.close()
        conn.close()