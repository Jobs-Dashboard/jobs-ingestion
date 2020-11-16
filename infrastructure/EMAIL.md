# This is how to quickly and easimply set up sending email with AWS SES and SMTP

1. Create or use an email account (i created jobs.dashboard.data@gmail.com)
1. Verify the email address (aws will send a code to the email and you will enter the code to verify)
    ![verify](images/verify.png)
1. You can test that its working by generating some test smtp credentials and a test iam user and sending a test email with the below code
    * create an iam user for smtp authentication (ses-smtp-user.mypurpose) and create smtp credentials (user and password)
        * https://docs.aws.amazon.com/ses/latest/DeveloperGuide/smtp-credenials.html
        * You can view a list of existing SMTP credentials that you've created using this procedure by going to the IAM console at https://console.aws.amazon.com/iam/. In the navigation pane, under Access management, choose Users. Use the search bar to find all users that contain the text "ses-smtp-user".
1. remove the test user and credentials after you're done

## Code for testing email sending

```python
import smtplib
import email.utils
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText

# Replace sender@example.com with your "From" address.
# This address must be verified.
SENDER = 'jobs.dashboard.data@gmail.com'
SENDERNAME = 'Sender Name'

# Replace recipient@example.com with a "To" address. If your account
# is still in the sandbox, this address must be verified.
RECIPIENT  = 'jobs.dashboard.data@gmail.com'

# Replace smtp_username with your Amazon SES SMTP user name.
USERNAME_SMTP = "AKIAQUQBI3UGKRJN7Q5Q"

# Replace smtp_password with your Amazon SES SMTP password.
PASSWORD_SMTP = "BF14x/LMrl4TKCNSoqnvLo/rutfA3nwnlhwryUTt5ptn"

# If you're using Amazon SES in an AWS Region other than US West (Oregon),
# replace email-smtp.us-west-2.amazonaws.com with the Amazon SES SMTP
# endpoint in the appropriate region.
HOST = "email-smtp.eu-west-1.amazonaws.com"
PORT = 587

# The subject line of the email.
SUBJECT = 'Amazon SES Test (Python smtplib)'

# The email body for recipients with non-HTML email clients.
BODY_TEXT = ("Amazon SES Test\r\n"
             "This email was sent through the Amazon SES SMTP "
             "Interface using the Python smtplib package."
            )

# The HTML body of the email.
BODY_HTML = """<html>
<head></head>
<body>
  <h1>Amazon SES SMTP Email Test</h1>
  <p>This email was sent with Amazon SES using the
    <a href='https://www.python.org/'>Python</a>
    <a href='https://docs.python.org/3/library/smtplib.html'>
    smtplib</a> library.</p>
</body>
</html>
            """

# Create message container - the correct MIME type is multipart/alternative.
msg = MIMEMultipart('alternative')
msg['Subject'] = SUBJECT
msg['From'] = email.utils.formataddr((SENDERNAME, SENDER))
msg['To'] = RECIPIENT

# Record the MIME types of both parts - text/plain and text/html.
part1 = MIMEText(BODY_TEXT, 'plain')
part2 = MIMEText(BODY_HTML, 'html')

# Attach parts into message container.
# According to RFC 2046, the last part of a multipart message, in this case
# the HTML message, is best and preferred.
msg.attach(part1)
msg.attach(part2)

# Try to send the message.
try:
    server = smtplib.SMTP(HOST, PORT)
    server.ehlo()
    server.starttls()
    #stmplib docs recommend calling ehlo() before & after starttls()
    server.ehlo()
    server.login(USERNAME_SMTP, PASSWORD_SMTP)
    server.sendmail(SENDER, RECIPIENT, msg.as_string())
    server.close()
# Display an error message if something goes wrong.
except Exception as e:
    print ("Error: ", e)
else:
    print ("Email sent!")

```