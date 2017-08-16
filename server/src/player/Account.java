package player;

import com.google.gson.Gson;

import db.db;
import db.account_table;

class AccountInfo{
	protected String	osid;
	protected String	email;
	protected String	phone_number;
	
	public AccountInfo() {
		
	}
}

public class Account {
	public account_table table = new account_table();
	public AccountInfo 	 info  = new AccountInfo();
	
	//  π”√” œ‰√‹¬Î◊¢≤·
	public void registerByEmail(String email, String password) {
		if(db.instance().isEmailUsed(email)) {
			System.out.println("hhhhhhhhhhh");
		}
		else {
			table.password = password;
			info.email = email;
			
			refreshPlayerToJson();	
			db.instance().saveNewAccount( password, table.info);
			
			loadAccountByEmail(email);
			
			System.out.println(String.format("add new account [%d]", table.account));
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
