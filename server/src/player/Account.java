package player;

import db.db;

class AccountInfo{
	protected String	osid;
	protected String	email;
	protected String	phone_number;
	
	public AccountInfo() {
		
	}
}

public class Account {
	public long	  id = 0;
	public String password;
	public AccountInfo info;
	
	//  π”√” œ‰√‹¬Î◊¢≤·
	public void registerByEmail(String email, String password) {
		if(db.instance().isEmailUsed(email)) {
			
		}
	}
}
