package com.cybershield.dao;


import java.sql.*;
import java.util.List;
import java.util.ArrayList;

import com.cybershield.model.Threat;

import com.cybershield.util.DBConnection;



public class ThreatDAO {



public boolean threatExists(String url){


String sql =
"SELECT COUNT(*) FROM THREATS WHERE URL=?";


try(Connection con=DBConnection.getConnection();

PreparedStatement ps=con.prepareStatement(sql)){


ps.setString(1,url);


ResultSet rs=ps.executeQuery();


if(rs.next()){

return rs.getInt(1)>0;

}


}
catch(Exception e){

e.printStackTrace();

}


return false;

}





public void addThreat(String url,String email){



String sql =
"INSERT INTO THREATS "
+
"(THREAT_ID,URL,EMAIL,REPORT_COUNT,STATUS)"
+
"VALUES(THREAT_SEQ.NEXTVAL,?,?,1,'ACTIVE')";



try(Connection con=DBConnection.getConnection();

PreparedStatement ps=con.prepareStatement(sql)){



ps.setString(1,url);

ps.setString(2,email);


ps.executeUpdate();



}
catch(Exception e){

e.printStackTrace();

}


}






public void increaseCount(String url){


String sql =
"UPDATE THREATS "
+
"SET REPORT_COUNT = REPORT_COUNT + 1 "
+
"WHERE URL=?";



try(Connection con=DBConnection.getConnection();

PreparedStatement ps=con.prepareStatement(sql)){



ps.setString(1,url);


ps.executeUpdate();


}
catch(Exception e){

e.printStackTrace();

}


}
public List<Threat> getAllThreats() {


    List<Threat> list = new ArrayList<>();


    String sql =
    "SELECT * FROM THREATS ORDER BY REPORT_COUNT DESC";


    try(Connection con = DBConnection.getConnection();

        PreparedStatement ps =
        con.prepareStatement(sql)){


        ResultSet rs = ps.executeQuery();



        while(rs.next()){


            Threat t = new Threat();


            t.setThreatId(
            rs.getInt("THREAT_ID")
            );


            t.setUrl(
            rs.getString("URL")
            );


            t.setEmail(
            rs.getString("EMAIL")
            );


            t.setReportCount(
            rs.getInt("REPORT_COUNT")
            );


            t.setStatus(
            rs.getString("STATUS")
            );


            list.add(t);

        }



    }
    catch(Exception e){

        e.printStackTrace();

    }


    return list;

}







public boolean removeThreat(int id){


    String sql =
    "DELETE FROM THREATS WHERE THREAT_ID=?";



    try(Connection con =
        DBConnection.getConnection();

        PreparedStatement ps =
        con.prepareStatement(sql)){



        ps.setInt(1,id);


        return ps.executeUpdate()>0;


    }
    catch(Exception e){

        e.printStackTrace();

    }


    return false;

}

public int countThreats(){


    String sql =
    "SELECT COUNT(*) FROM THREATS";


    try(Connection con =
        DBConnection.getConnection();

        PreparedStatement ps =
        con.prepareStatement(sql)){


        ResultSet rs =
        ps.executeQuery();


        if(rs.next())
            return rs.getInt(1);


    }
    catch(Exception e){

        e.printStackTrace();

    }


    return 0;

}




}