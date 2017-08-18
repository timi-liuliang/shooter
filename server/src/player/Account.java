package player;

import java.util.ArrayList;

import com.google.gson.Gson;

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
			
			refreshPlayerToJson();	
			db.instance().saveNewAccount( password, table.info);
			
			loadAccountByEmail(email);
			
			protocol.register_result rr = new protocol.register_result();
			rr.result = 0;
			ctx.write(rr.data());
			
			System.out.println(String.format("account [%d] registerByEmail succeed.", table.account));
		}
	}
	
	protected void refreshPlayerToJson() {
		Gson gson = new Gson();
		table.info = gson.toJson(info);	
	}
	
	public void loadAccountByEmail(String email) {
		table = db.instance().getAccountTableByEmail( email);
		
		Gson gson = new Gson();
		info = gson.fromJson( table.info, AccountInfo.class);
	}
}
