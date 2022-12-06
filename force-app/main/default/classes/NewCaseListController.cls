public class NewCaseListController {
    public List<Case> getNewCases(){
        String Status = 'New';
        return Database.query('SELECT ID, CaseNumber FROM Case WHERE Status =: Status');
    }
}