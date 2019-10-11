package web.mail;

import java.io.UnsupportedEncodingException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Properties;
 
import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
 
public class MailSend {
    
    public void MailSend() throws ParseException {
        Properties prop = System.getProperties();
        prop.put("mail.smtp.starttls.enable", "true");
        prop.put("mail.smtp.host", "smtp.gmail.com");
        prop.put("mail.smtp.auth", "true");
        prop.put("mail.smtp.port", "587");
        
        Authenticator auth = new MailAuth();
        
        Session session = Session.getDefaultInstance(prop, auth);
        
        MimeMessage msg = new MimeMessage(session);
        
       
    	
    	try {
        	Date nowTime = new Date();
        	String book="2019-09-29 11:57:00.0";
        	Date booked= new SimpleDateFormat("yyyy-mm-dd HH:mm:ss.S").parse(book);


        	if(nowTime == booked)
        	{
        	msg.setSentDate(new Date());
            
            msg.setFrom(new InternetAddress("받을 메일 주소", "VISITOR"));
            InternetAddress to = new InternetAddress("메일을 받을 메일 주소");         
            msg.setRecipient(Message.RecipientType.TO, to);            
            msg.setSubject("제목", "UTF-8");            
            msg.setText("안녕하세요 테스트 메일입니다.", "UTF-8");            
            
            Transport.send(msg);}
            
        } catch(AddressException ae) {            
            System.out.println("AddressException : " + ae.getMessage());           
        } catch(MessagingException me) {            
            System.out.println("MessagingException : " + me.getMessage());
        } catch(UnsupportedEncodingException e) {
            System.out.println("UnsupportedEncodingException : " + e.getMessage());			
        }
                
    }
}