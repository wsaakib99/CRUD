public with sharing class ApplicantCustomController {
    public Applicant__c applicant{get;set;}
    public Guarantor__c guarantor{get; set;}
    public Document__c document{get; set;}
    public Asset_Detail__c asset{get; set;}
    public List<Guarantor__c> guarantors{get;set;}
    public List<Document__c> documents{get;set;}
    public List<Asset_Detail__c> assets{get;set;}
    public blob file{get;set;}
    public String fileName{get; set; }
    
    public ApplicantCustomController(){
        this.applicant = new Applicant__c();
        this.guarantor = new Guarantor__c();
        this.document = new Document__c();
        this.asset = new Asset_Detail__c();
        
        String applicantId = ApexPages.currentPage().getParameters().get('id');
        
        if(applicantId != null){
            this.getApplicant(applicantId);
            this.getGuarantors(applicantId);
            this.getAssetDetails(applicantId);
            this.getDocuments(applicantId);
        }
    }
    
    private void getApplicant(String id){
        this.applicant = [SELECT FirstName__c, 
                          LastName__c, 
                          Address__c, 
                          Email__c,
                          Gender__c,
                          NID__c,
                          Phone__c,
                          Loan_Amount__c,
                          Status__c,
                          Age__c FROM Applicant__c WHERE id = :id];
    }
    
    private void getGuarantors(String applicantId){
        this.guarantors = [SELECT Name__c, 
                          Ownership__c, 
                          SSIN_FIEN__c, 
                          Date_of_birth__c
                          FROM Guarantor__c WHERE applicant__c = :applicantId];
    }
    
    private void getAssetDetails(String applicantId){
        this.assets = [SELECT Asset_Price__c, 
                          Condition__c, 
                          Make__c, 
                          Model__c,
                          Serial__c,
                          Year__c
                          FROM Asset_Detail__c WHERE applicant__c = :applicantId];
    }
    
    private void getDocuments(String applicantId){
       this.documents= [SELECT Type__c, 
                          Name__c, 
                          File_Name__c 
                          FROM Document__c WHERE applicant__c = :applicantId];
    }

    public PageReference saveApplicant(){
        UPSERT this.applicant;
        Pagereference pr = new Pagereference('/apex/ApplicantForm');
        pr.getParameters().put('id', this.applicant.id);
        pr.setRedirect(true);
        return pr;
    }
    
    public PageReference saveGuarantor(){
        try{
            Decimal totalOwnership = this.guarantor.Ownership__c;
        for (Guarantor__c guarantor : this.guarantors) {
            totalOwnership += guarantor.Ownership__c;
        }

        if(totalOwnership > 100){
             NoAccessException na = new NoAccessException();
             na.setMessage('Could not add new Guarantor. Total Ownership exceded 100%');
             throw na;
        }
        this.guarantor.Applicant__c = this.applicant.id;
        UPSERT this.guarantor;
        this.getGuarantors(this.applicant.id);
        this.guarantor = new Guarantor__c();
        return null;
        }
        catch(Exception e){
            ApexPages.Message message = new Apexpages.Message(Apexpages.Severity.Error, e.getMessage());
            Apexpages.addMessage(message);
            return null;
        }
        
    }
    public PageReference saveAssetDetail(){
        this.asset.Applicant__c = this.applicant.id;
        upsert this.asset;
        this.asset = new Asset_Detail__c();
        this.getAssetDetails(this.applicant.id);
        return null;
    }
    public PageReference saveDocument(){
        try{
            ContentVersion v = new ContentVersion();
            v.versionData = file;
            v.title = this.fileName;
            v.ContentLocation = 's';
            v.PathOnClient='/';
            insert v;
            this.document.File_Name__c= v.id;
            system.debug(this.fileName);
            this.document.Applicant__c = this.applicant.id;
            UPSERT this.document;
            this.document = new Document__c();
            this.getDocuments(this.applicant.id);
            return null;
        }catch(Exception e){
            ApexPages.Message message = new Apexpages.Message(Apexpages.Severity.Error, e.getMessage());
            Apexpages.addMessage(message);
            return null;
        }
        
    }
    public PageReference submit(){
        this.applicant.Status__c = 'Submitted';
        UPSERT this.applicant;
        return null;
    }
    
    
}