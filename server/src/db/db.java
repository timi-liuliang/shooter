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
	
	public boolean isEmailUsed(String email) {
		String sql = String.format("SELECT COUNT(id) AS rows FROM account WHERE player=\'%s\';", email);	
		
		return isExist(sql);
	}
	
	public boolean isPlayerExist(long player) {
		String sql = String.format("SELECT COUNT(id) AS rows FROM player WHERE player=\'%d\';", player);	
		
		return isExist(sql);
	}
	
	public void saveNewPlayer(long account, String json) {
		try {
			Statement st = con.createStatement();
			
			String sql = String.format("INSERT INTO player(account_id, info) VALUES(\'%d\', \'%s\', \'%s\');", account, json);
			
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
