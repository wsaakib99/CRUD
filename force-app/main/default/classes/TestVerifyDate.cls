@isTest
public class TestVerifyDate {
	
    @isTest static void testWithin30Days(){
        Boolean dateWithin30Days = VerifyDate.DateWithin30Days(Date.newInstance(2022, 11, 20), Date.newInstance(2022, 11, 25));
    	System.assertEquals(true, dateWithin30Days);
    }
    
    @isTest static void testAbove30Days(){
        Boolean dateAbove30Days = VerifyDate.DateWithin30Days(Date.newInstance(2022, 11, 20), Date.newInstance(2023, 11, 25));
    	System.assertEquals(false, dateAbove30Days);
    }
    
    @isTest static void testIsLastDay(){
        Date lastDay = VerifyDate.SetEndOfMonthDate(Date.newInstance(2022, 11, 20));
    	System.assertEquals(Date.newInstance(2022, 11, 30), lastDay);
    }
    
    @isTest static void testCheckDateWithin30Days(){
        Date lastDay = VerifyDate.CheckDates(Date.newInstance(2022, 11, 23), Date.newInstance(2022, 11, 25));
    	System.assertEquals(Date.newInstance(2022, 11, 25), lastDay);
    }
    
    @isTest static void testCheckDateAbove30Days(){
        Date lastDay = VerifyDate.CheckDates(Date.newInstance(2022, 11, 23), Date.newInstance(2023, 11, 25));
    	System.assertEquals(Date.newInstance(2022, 11, 30), lastDay);
    }
    
}