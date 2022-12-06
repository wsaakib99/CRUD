public class ContactAndLeadSearch {
    public static List<List< sObject>> searchContactsAndLeads(String text){
        return [FIND: text IN ALL FIELDS RETURNING Contact(FirstName, LastName), Lead(FirstName, LastName)];       
    }
}