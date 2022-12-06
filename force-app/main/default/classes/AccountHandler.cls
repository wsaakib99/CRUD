public class AccountHandler {
    public static Account insertNewAccount(String name){
        if(name == ''){
            return null;
        }
        
        Account acct = new Account(name = name);
        insert acct;
        return acct;
    }
}