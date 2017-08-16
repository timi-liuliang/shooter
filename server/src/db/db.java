package db;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;
import java.sql.ResultSet;


// data base manager
public class db {
	protected static db inst = null;
	protected Connection con = null;
	
	public db() {
		try {
			//Class.forName("org.postgresql.Driver");
			con = DriverManager.getConnection("jdbc:postgresql://localhost:5432/td", "postgres", "Q19870816q");		
			System.out.println("db:connected");		
		}catch(Exception e){
			e.printStackTrace();
		}
	}
	
	public static db instance() {
		if(inst==null)
			inst = new db();

		return inst;
	}
	
	protected boolean isExist(String sql) {
		try {
			int rows = 0;
			Statement st = con.createStatement();
			ResultSet rs = st.executeQuery(sql);
			if(rs.next()) {
				rows = rs.getInt("rows");
			}
			rs.close();
			
			if(rows>0) {
				return true;
			}else {
				return false;
			}			
			
		}catch(Exception e) {
			e.printStackTrace();
		}
			
		return true;
	}
	
	// 邮箱是否已被使用
	public boolean isEmailUsed(String email) {
		//String sql = String.format("SELECT COUNT(account) AS rows FROM account WHERE info @> \'{\"email\":%s}\';", email);	
		String sql = String.format("SELECT COUNT(account) AS rows FROM account");// WHERE info @> \'{\"email\":%s}\';", email);
		return isExist(sql);
	}
	
	// 根据邮箱密码新建账号
	public void saveNewAccount(String password, String json) {
		try {
			Statement st = con.createStatement();
			
			String sql = String.format("INSERT INTO account(password,info) VALUES(\'%s\', \'%s\');", password, json);
			
			System.out.println("db:" + sql);
			st.executeUpdate(sql);
			st.close();
			
		}catch(Exception e) {
			e.printStackTrace();
		}
	}
	
	public account_table getAccountTableByEmail(String email) {	
		account_table table = new account_table();
		try{	
			Statement st = con.createStatement();
			
			String sql = String.format("SELECT * FROM account WHERE info @> \'{\"email\":%s}\';", email);
			ResultSet rs = st.executeQuery(sql);
			if(rs.next()) {
				table.account  = rs.getLong("account");
				table.password = rs.getString("password");
				table.info = rs.getString("info");
				System.out.println("db:" + sql);
			}
			rs.close();
			st.close();
					
		}catch(Exception e){
			e.printStackTrace();
		}
		
		return table;
	}
	
	
	public boolean isPlayerExist(long player) {
		String sql = String.format("SELECT COUNT(player) AS rows FROM player WHERE player=\'%d\';", player);	
		
		return isExist(sql);
	}
	
	public void saveNewPlayer(long account, String json) {
		try {
			Statement st = con.createStatement();
			
			String sql = String.format("INSERT INTO player(account, info) VALUES(\'%d\', \'%s\');", account, json);
			
			System.out.println("db:" + sql);
			st.executeUpdate(sql);
			st.close();
			
		}catch(Exception e) {
			e.printStackTrace();
		}
	}
	
	public void savePlayer(long player, String json) {
		try {
			Statement st = con.createStatement();
			
			String sql = String.format("UPDATE player SET info=\'%s\' WHERE player=\'%d\';", json, player);		
			System.out.println("db:" + sql);
			st.executeUpdate(sql);
			st.close();
			
		}catch(Exception e) {
			e.printStackTrace();
		}
	}
	
	public String getPlayerInfo(long account, long player) {	
		String jsonData = "";
		try{	
			Statement st = con.createStatement();
			
			String sql = String.format("SELECT * FROM player WHERE account=\'%d\' AND player=\'%d\';", account, player);	
			ResultSet rs = st.executeQuery(sql);
			if(rs.next()) {
				jsonData = rs.getString("info");
				System.out.println("db:" + sql);
			}
			rs.close();
			st.close();
					
		}catch(Exception e){
			e.printStackTrace();
		}
		
		return jsonData;
	}
}
