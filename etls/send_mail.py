import os
import sys
import argparse
import logging
import smtplib
import email.utils
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText


def main(**kwargs) -> None:
    # Replace sender@example.com with your "From" address.
    # This address must be verified.
    SENDER = os.environ['MAIL_FROM']
    SENDERNAME = os.environ['MAIL_FROM']

    # Replace recipient@example.com with a "To" address. If your account
    # is still in the sandbox, this address must be verified.
    RECIPIENT = os.environ['MAIL_FROM']

    # Replace smtp_username with your Amazon SES SMTP user name.
    USERNAME_SMTP = os.environ['MAIL_USERNAME']

    # Replace smtp_password with your Amazon SES SMTP password.
    PASSWORD_SMTP = os.environ['MAIL_PASSWORD']

    # If you're using Amazon SES in an AWS Region other than US West (Oregon),
    # replace email-smtp.us-west-2.amazonaws.com with the Amazon SES SMTP
    # endpoint in the appropriate region.
    HOST = os.environ['MAIL_HOST']
    PORT = 587

    # The subject line of the email.
    SUBJECT = kwargs['subject']

    # The email body for recipients with non-HTML email clients.
    BODY_TEXT = kwargs['body_text']

    # The HTML body of the email.
    BODY_HTML = f"""<html>
    <head></head>
    <body>
    <p>{kwargs['body_text']}</p>
    </body>
    </html>
    """

    # Create message container - the correct MIME type is
    # multipart/alternative.
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
        # stmplib docs recommend calling ehlo() before & after starttls()
        server.ehlo()
        server.login(USERNAME_SMTP, PASSWORD_SMTP)
        server.sendmail(SENDER, RECIPIENT, msg.as_string())
        server.close()
    # Display an error message if something goes wrong.
    except Exception as e:
        logger.error("Error: ", e)
    else:
        logger.info("Email sent!")


def _configure_argparser():
    '''Configures the argument parser.
    '''
    parser = argparse.ArgumentParser(description='Send Email.')

    parser.add_argument(
        '--subject',
        required=True,
    )
    parser.add_argument(
        '--body-text',
        required=False,
        help='The text of the email body.',
    )

    return parser


if __name__ == '__main__':

    # configure logger
    logging.basicConfig(stream=sys.stdout, level=logging.INFO)
    logger = logging.getLogger(__name__)
    logger.info("Configured the logger.")

    # configure parser
    parser = _configure_argparser()
    kwargs = vars(parser.parse_args())
    logger.info("Configured the parser.")

    # scrape and store the jobs data
    main(**kwargs)
