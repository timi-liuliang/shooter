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
	public account_table table;
	public AccountInfo 	 info;
	
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
		}
	}
	
	protected boolean refreshPlayerToJson() {
		Gson gson = new Gson();
		String new_json = gson.toJson(info);	
		if(table.info!=new_json)
		{
			table.info = new_json;
			
			return true;
		}
			
		return false;
	}
	
	public void loadAccountByEmail(String email) {
		table = db.instance().getAccountTableByEmail( email);
		
		Gson gson = new Gson();
		info = gson.fromJson( table.info, AccountInfo.class);
	}
}
