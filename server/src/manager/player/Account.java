package manager.player;

import java.net.InetSocketAddress;
import java.util.ArrayList;

import com.google.gson.Gson;

import App.app;
import db.db;
import io.netty.channel.ChannelHandlerContext;
import db.account_table;

class loginIp{
	public String	ip;
	public int		count;
	
	loginIp(){
		count = 0;
	}
	
	loginIp(String ip, int count){
		this.ip =ip;
		this.count = count;
	}
}

class AccountInfo{
	protected String	osid;
	protected String	email;
	protected String	phone_number;
	public ArrayList<loginIp> ips = new ArrayList<loginIp>();
	
	public AccountInfo() {
		
	}
}

public class Account {
	public account_table table = new account_table();
	public AccountInfo 	 info  = new AccountInfo();
	
	//  π”√” œ‰√‹¬Î◊¢≤·
	public void registerByEmail(String email, String password, ChannelHandlerContext ctx) {
		if(db.instance().isEmailUsed(email)) {
			protocol.register_result rr = new protocol.register_result();
			rr.account= 0;
			rr.result = 1;
			ctx.write(rr.data());
		}
		else {
			table.password = password;
			info.email = email;
			
			refreshAccountToJson();	
			db.instance().saveNewAccount( table.password, table.info);
			
			loadAccountByEmail(email);
			
			protocol.register_result rr = new protocol.register_result();
			rr.result = 0;
			ctx.write(rr.data());
			
			System.out.println(String.format("account [%d] registerByEmail succeed.", table.account));
		}
	}
	
	//  π”√Œ®“ª◊¢≤·
	public void registerByOSID(String osid) {
		if(!db.instance().isOSIDUsed(osid)) {
			table.password = "";
			info.osid = osid;
			
			refreshAccountToJson();	
			db.instance().saveNewAccount( table.password, table.info);
		}
	}
	
	//  π”√” œ‰√‹¬Îµ«¬º
	public boolean loginByEmail(String email, String password, ChannelHandlerContext ctx) {
		if(db.instance().isEmailUsed(email)) {
			loadAccountByEmail(email);
			if(password.equals(table.password)) {
				protocol.login_result lr = new protocol.login_result();
				lr.result = 0;
				ctx.write(lr.data());
				
				rememberLoginIpAddress(ctx);
				
				return true;
			}
		}
		
		// µ«¬º ß∞‹ 
		protocol.login_result lr = new protocol.login_result();
		lr.result = 1;
		ctx.write(lr.data());	
		return false;
	}
	
	//  π”√Œ®“ªIDµ«¬º
	public boolean loginByOSID(String osid, ChannelHandlerContext ctx) {
		if(!db.instance().isOSIDUsed(osid)) {
			registerByOSID(osid);
		}
		
		loadAccountByOSID(osid);
		protocol.login_result lr = new protocol.login_result();
		lr.result = 0;
		ctx.write(lr.data());
		
		rememberLoginIpAddress(ctx);
		
		return true;
	}
	
	protected void refreshAccountToJson() {
		Gson gson = new Gson();
		table.info = gson.toJson(info);	
	}
	
	public void loadAccountByEmail(String email) {
		table = db.instance().getAccountTableByEmail( email);
		
		Gson gson = new Gson();
		info = gson.fromJson( table.info, AccountInfo.class);
	}
	
	public void loadAccountByOSID(String osid) {
		table = db.instance().getAccountTableByOSID( osid);
		
		Gson gson = new Gson();
		info = gson.fromJson( table.info, AccountInfo.class);
	}
	
	public void saveToDB() {
		refreshAccountToJson();
		
		db.instance().saveAccount(table.account,table.password,table.info);
	}
	
	public String getRemoteIpAddress(ChannelHandlerContext ctx) {
    	InetSocketAddress insocket = (InetSocketAddress) ctx.channel().remoteAddress();
        return insocket.getAddress().getHostAddress();
	}
	
	public void rememberLoginIpAddress(ChannelHandlerContext ctx) {
		String clientIP = getRemoteIpAddress(ctx);
        
        for(int i=0; i<info.ips.size(); i++) {
        	loginIp ip = info.ips.get(i);
        	if(ip.ip.equals(clientIP)) {
        		ip.count++;
                app.logger().info(String.format("Accept connect from client [%s] count[%d]", clientIP, ip.count));
        		return;
        	}
        }
        
        loginIp ip = new loginIp(clientIP, 1);
        info.ips.add(ip);
        app.logger().info(String.format("Accept connect from client [%s] count[%d]", clientIP, 1));
	}
}
