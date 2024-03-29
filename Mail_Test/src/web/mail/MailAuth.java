package web.mail;

import javax.mail.PasswordAuthentication;
import javax.mail.Authenticator;

public class MailAuth extends Authenticator{
    
    PasswordAuthentication pa;
    
    public MailAuth() {
        String mail_id = "아이디";
        String mail_pw = "비밀번호";
        
        pa = new PasswordAuthentication(mail_id, mail_pw);
    }
    
    public PasswordAuthentication getPasswordAuthentication() {
        return pa;
    }
}
