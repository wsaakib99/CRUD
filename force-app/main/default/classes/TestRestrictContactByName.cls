@isTest
public class TestRestrictContactByName {
    @isTest static void testInsertSuccess(){
        Contact cntc = new Contact(FirstName = 'Wahid', LastName ='Sakib');
        
        Test.startTest();
        Database.SaveResult result = Database.insert(cntc, false);
        System.assertEquals(true, result.isSuccess());
    }
    
    @isTest static void testInsertFail(){
        Contact cntc = new Contact(FirstName = 'Wahid', LastName ='INVALIDNAME');
        
        Test.startTest();
        Database.SaveResult result = Database.insert(cntc, false);
        System.assertEquals(false, result.isSuccess());
        System.Assert(result.getErrors().size() > 0);
        System.assertEquals('The Last Name "'+cntc.LastName+'" is not allowed for DML', result.getErrors()[0].getMessage());
    }
}