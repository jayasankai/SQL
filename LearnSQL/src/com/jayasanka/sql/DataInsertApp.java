package com.jayasanka.sql;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.Random;

public class DataInsertApp {

	public static void main(String[] args) {
		System.out.println("DataInsertApp :: Start.");

		DataInsertApp app = new DataInsertApp();

		app.processDataInsertion();

		System.out.println("DataInsertApp :: End.");
	}

	private void processDataInsertion() {
		Connection conn = null;
		Statement stmt = null;
		try {
			try {
				Class.forName("com.mysql.cj.jdbc.Driver");
			} catch (Exception e) {
				System.err.println(e);
			}

			conn = (Connection) DriverManager.getConnection("jdbc:mysql://localhost:3306/learnDataPartition", "root", "1qaz2wsx@123");
			System.out.println("Connection created successfully.");
			stmt = (Statement) conn.createStatement();

			// Insert department data
			String[] departments = new String[] {"IT", "HR", "Finance", "Marketing", "Operation"};
			Map<String, Integer> deptVsEmpCount = new HashMap<>();
			deptVsEmpCount.put("IT", 400);
			deptVsEmpCount.put("HR", 10);
			deptVsEmpCount.put("Finance", 12);
			deptVsEmpCount.put("Marketing", 30);
			deptVsEmpCount.put("Operation", 125);
			
			Map<String, Long> deptIds = departmentDataInsertion(conn, stmt, departments);
			
			for (Map.Entry<String, Long> entry : deptIds.entrySet()) {
				String deptName = entry.getKey();
				Long deptId = entry.getValue();
				
				Integer empCount = deptVsEmpCount.get(deptName);
				
				// insert employee data
				employeeDataInsertion(conn, stmt, deptId, deptName, empCount);
			}
			

			System.out.println("Record inserted successfully.");
		} catch (SQLException excep) {
			excep.printStackTrace();
		} catch (Exception excep) {
			excep.printStackTrace();
		} finally {
			try {
				if (stmt != null)
					conn.close();
			} catch (SQLException se) {
			}
			try {
				if (conn != null)
					conn.close();
			} catch (SQLException se) {
				se.printStackTrace();
			}
		}
	}

	private Map<String, Long> departmentDataInsertion(Connection conn, Statement stmt, String[] departments) throws SQLException {
		System.out.println("Departmnt data insertion :: Started.");
		Map<String, Long> deptVsIds = new HashMap<>();

		for (String deparment : departments) {				
			long pKey = generatePrimaryKey();
			System.out.println("Department PK: " + pKey + " Name: " + deparment);
			
			String deptQuery = "INSERT INTO department VALUES (" + pKey + ", '" + deparment +"', 'Singapore');";
			stmt.executeUpdate(deptQuery);
			
			deptVsIds.put(deparment, pKey);
		}
		
		System.out.println("Departmnt data insertion :: Done.");

		return deptVsIds;
	}
	
	private void employeeDataInsertion(Connection conn, Statement stmt, Long deptId, String deptName, Integer empCount) throws SQLException {
		System.out.println("Employee data insertion :: Started. Deparment Name: " + deptName + ", Employee Count: " +  empCount);
		
		for (int i = 0; i < empCount; i++) {			
			long pKey = generatePrimaryKey();
			String prefix = String.format("%03d", (int) (Math.random() * 1000));
			int salary = Integer.parseInt(prefix) * 10000;
			String userName = "User_" + deptName + i;
			System.out.println("Employee:: Key: " + pKey + " Name: " + userName + " DepKey: " + deptId + " Slary: " + salary);
			
			String empQuery = "INSERT INTO employee VALUES (" + pKey + ", '" + userName + "', " + deptId + ", " + salary +");";
			stmt.executeUpdate(empQuery);
		}

		System.out.println("Employee data insertion :: Done.");
	}
	
	private long generatePrimaryKey() {
		Calendar calender = Calendar.getInstance();
		Date now = new Date();
		calender.setTime(now);
		calender.add(Calendar.YEAR, -((new Random().nextInt(3))));
		
		Date date = calender.getTime();
		
		SimpleDateFormat ft = new SimpleDateFormat("yyyyMMddhhmmss");
		String datetime = ft.format(date);
		int randNo = (new Random().nextInt(1, 100000));
		String prefix = String.format("%05d", randNo);
		long index = Long.parseLong(datetime + prefix);
		return index;
	}
}
