public class RandomContactFactory {
    public static List<Contact> generateRandomContacts(Integer numTest, String lname){
        List<Contact> cntc = new List<Contact>();
        
        for(Integer i = 0; i < numTest; i++){
            cntc.add(new Contact(FirstName = 'Wahid' + i, LastName=lname));
        }
        return cntc;
    }
}