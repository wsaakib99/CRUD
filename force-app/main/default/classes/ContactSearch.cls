public class ContactSearch {
    public static Contact[] searchForContacts(String lname, String pcode){
        Contact[] cntcs = [SELECT Id, FirstName, LastName FROM Contact WHERE LastName =: lname AND MailingPostalCode =:pcode ];
        return cntcs;
    }  
}