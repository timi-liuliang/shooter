package db;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.sql.ResultSet;
import App.app;

// data base manager
public class db {
	private static final Logger logger = LogManager.getLogger("db");
	protected static db inst = null;
	protected Connection con = null;
	
	public db() {
		try {
			//Class.forName("org.postgresql.Driver");
			con = DriverManager.getConnection("jdbc:postgresql://localhost:5432/shooter", "postgres", "Q19870816q");		
			logger.info("db:connected");		
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
		String sql = String.format("SELECT COUNT(account) AS rows FROM account WHERE info @> \'{\"email\":\"%s\"}\';", email);	
		return isExist(sql);
	}
	
	// OSID是否已被使用
	public boolean isOSIDUsed(String osid) {
		String sql = String.format("SELECT COUNT(account) AS rows FROM account WHERE info @> \'{\"osid\":\"%s\"}\';", osid);	
		return isExist(sql);
	}
	
	// 根据邮箱密码新建账号
	public void saveNewAccount(String password, String json) {
		try {
			Statement st = con.createStatement();
			
			String sql = String.format("INSERT INTO account(password,info) VALUES(\'%s\', \'%s\');", password, json);
			
			logger.info(String.format("db:create new account"));
			st.executeUpdate(sql);
			st.close();
			
		}catch(Exception e) {
			e.printStackTrace();
		}
	}
	
	public void saveAccount(long account, String password, String json) {
		try {
			Statement st = con.createStatement();
			
			String sql = String.format("UPDATE account SET info=\'%s\', password=\'%s\' WHERE account=\'%d\';", json, password, account);		
			logger.info(String.format("db: save account [%d]", account));
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
			
			String sql = String.format("SELECT * FROM account WHERE info @> \'{\"email\":\"%s\"}\';", email);
			ResultSet rs = st.executeQuery(sql);
			if(rs.next()) {
				table.account  = rs.getLong("account");
				table.password = rs.getString("password");
				table.info = rs.getString("info");
			}
			rs.close();
			st.close();
					
		}catch(Exception e){
			e.printStackTrace();
		}
		
		return table;
	}
	
	public account_table getAccountTableByOSID(String osid) {	
		account_table table = new account_table();
		try{	
			Statement st = con.createStatement();
			
			String sql = String.format("SELECT * FROM account WHERE info @> \'{\"osid\":\"%s\"}\';", osid);
			ResultSet rs = st.executeQuery(sql);
			if(rs.next()) {
				table.account  = rs.getLong("account");
				table.password = rs.getString("password");
				table.info = rs.getString("info");
			}
			rs.close();
			st.close();
					
		}catch(Exception e){
			e.printStackTrace();
		}
		
		return table;
	}
	
	
	public boolean isPlayerExist(long account) {
		String sql = String.format("SELECT COUNT(player) AS rows FROM player WHERE account=\'%d\';", account);	
		
		return isExist(sql);
	}
	
	public void saveNewPlayer(long account, String json) {
		try {
			Statement st = con.createStatement();
			
			String sql = String.format("INSERT INTO player(account, info) VALUES(\'%d\', \'%s\');", account, json);
			
			logger.info("create new player");
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
			logger.info(String.format("db:save player[%d]", player));
			st.executeUpdate(sql);
			st.close();
			
		}catch(Exception e) {
			e.printStackTrace();
		}
	}
	
	public player_table getPlayerTable(long account) {	
		player_table table = new player_table();
		try{	
			Statement st = con.createStatement();
			
			String sql = String.format("SELECT * FROM player WHERE account=\'%d\';", account);	
			ResultSet rs = st.executeQuery(sql);
			if(rs.next()) {
				table.player = rs.getLong("player");
				table.account = rs.getLong("account");
				table.info = rs.getString("info");
			}
			rs.close();
			st.close();
					
		}catch(Exception e){
			e.printStackTrace();
		}
		
		return table;
	}
	
	
	public void saveGlobalKeyValue(String key, String json) {
		try {
			Statement st = con.createStatement();
			
			String sql = String.format("INSERT INTO global(key,value) VALUES(\'%s\',\'%s\') ON conflict(key) DO UPDATE SET value=\'%s\';", key, json, json);
			
			st.executeUpdate(sql);
			st.close();
			
		}catch(Exception e) {
			
		}
	}
	
	// 根据邮箱密码新建账号
	public String getGlobalValue(String key) {
		String result = "";
		try{	
			Statement st = con.createStatement();
			
			String sql = String.format("SELECT * FROM global WHERE key=\'%s\';", key);
			ResultSet rs = st.executeQuery(sql);
			if(rs.next()) {
				result  = rs.getString("value");
			}
			rs.close();
			st.close();
					
		}catch(Exception e){
			e.printStackTrace();
		}
		
		return result;
	}
}
