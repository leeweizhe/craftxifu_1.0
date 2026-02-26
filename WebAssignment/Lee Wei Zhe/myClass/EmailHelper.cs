using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Net;
using System.Net.Mail;

namespace WebAssignment.Lee_Wei_Zhe.myClass
{
    public static class EmailHelper
    {
        public static void SendOtpEmail(string toEmail, string otpCode)
        {
            MailMessage mail = new MailMessage();
            mail.From = new MailAddress("acadeyage@gmail.com");
            mail.To.Add(toEmail);
            mail.Subject = "Your Minecraft Community OTP";
            mail.Body = "Hello!\n\nYour one-time password is: " + otpCode + "\n\nThis code will expire in 10 minutes.";

            using (SmtpClient smtp = new SmtpClient("smtp.gmail.com", 587))
            {
                smtp.EnableSsl = true;
                smtp.UseDefaultCredentials = false;
                smtp.Credentials = new NetworkCredential("acadeyage@gmail.com", "ffhzuhcnyttklujj");
                smtp.Send(mail);
            }
        }
    }
}