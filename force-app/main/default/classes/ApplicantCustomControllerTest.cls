@istest
public with sharing class ApplicantCustomControllerTest {
    static String  applicantId;
    static ApplicantCustomController acc = new ApplicantCustomController();
    @istest
    static void TestSaveApplicant(){
       acc.applicant.FirstName__c= 'Wahid';
       acc.applicant.LastName__c= 'Sakib';
       acc.applicant.Email__c= 'RandomString@email.com';
       acc.applicant.Gender__c= 'Male';
       acc.applicant.NID__c= 123456567;
       acc.applicant.Phone__c= '+01854582598';
       acc.applicant.Age__c= 65;
       acc.applicant.Address__c= 'He[pojkdfp[hgiojf[dphij[idpfh';
       acc.applicant.Loan_Amount__c= 1000;

       Pagereference result =  acc.saveApplicant();
       
       Pagereference expected = new Pagereference('/apex/ApplicantForm');
       expected.getParameters().put('id', acc.applicant.id);
       expected.getParameters().put('tab', 'applicant');
       expected.setRedirect(true);

       System.assertEquals(expected.getParameters().get('id'), result.getParameters().get('id'));
       System.assertEquals(expected.getUrl(), result.getUrl());
       System.assertEquals(expected.getRedirect(), result.getRedirect());
       applicantId = acc.applicant.id;
    }

    @istest
    static void TestSaveGuaranor() {
        TestSaveApplicant();
        acc.guarantor.Name__c= 'wSGDSGDSG';
        acc.guarantor.Ownership__c= 100;
        acc.guarantor.SSIN_FIEN__c= 2432445;
        acc.guarantor.Date_of_birth__c= Date.newInstance(2022, 12,6);
        acc.guarantor.Applicant__c = acc.applicant.id;

        Pagereference result =  acc.saveGuarantor();
  
        Pagereference expected = new Pagereference('/apex/ApplicantForm');
        expected.getParameters().put('id', applicantId);
        expected.getParameters().put('tab', 'guarantors');
        expected.setRedirect(true);

        System.assertEquals(expected.getParameters().get('id'), result.getParameters().get('id'));
        System.assertNotEquals(null, result.getParameters().get('guarantorId'));
        // System.assertEquals(expected.getUrl(), result.getUrl());
        System.assertEquals(expected.getRedirect(), result.getRedirect());
    }

    @istest
    static void TestSaveGuaranorAboveHundredOwnership() {
        TestSaveApplicant();
        acc.guarantor.Name__c= 'wSGDSGDSG';
        acc.guarantor.Ownership__c= 102;
        acc.guarantor.SSIN_FIEN__c= 2432445;
        acc.guarantor.Date_of_birth__c= Date.newInstance(2022, 12,6);
        acc.guarantor.Applicant__c = acc.applicant.id;

        Pagereference result =  acc.saveGuarantor();
  
        Pagereference expected = new Pagereference('/apex/ApplicantForm');
        expected.getParameters().put('id', applicantId);
        expected.getParameters().put('tab', 'guarantors');
        expected.setRedirect(false);

        System.assertEquals(expected.getParameters().get('id'), result.getParameters().get('id'));
        System.assertEquals(null, result.getParameters().get('guarantorId'));
        Boolean hasMessage = false;
        for(Apexpages.Message msg: Apexpages.getMessages()){
            if(msg.getDetail().contains('Could not add new Guarantor. Total Ownership exceded 100%')) {
                hasMessage = true;
            }
        }
        System.assertEquals(true, hasMessage);
        System.assertEquals(expected.getRedirect(), result.getRedirect());
    }

    @istest
    static void TestSaveGuaranorAboveHundredOwnershipBySummingUp() {
        TestSaveApplicant();
        TestSaveGuaranor();
        acc.guarantor.Name__c= 'wSGDSGDS34G';
        acc.guarantor.Ownership__c= 60;
        acc.guarantor.SSIN_FIEN__c= 243244532;
        acc.guarantor.Date_of_birth__c= Date.newInstance(2022, 12,6);
        acc.guarantor.Applicant__c = acc.applicant.id;

        Pagereference result =  acc.saveGuarantor();
  
        Pagereference expected = new Pagereference('/apex/ApplicantForm');
        expected.getParameters().put('id', applicantId);
        expected.getParameters().put('tab', 'guarantors');
        expected.setRedirect(false);

        System.assertEquals(expected.getParameters().get('id'), result.getParameters().get('id'));
        System.assertEquals(null, result.getParameters().get('guarantorId'));
        Boolean hasMessage = false;
        for(Apexpages.Message msg: Apexpages.getMessages()){
            if(msg.getDetail().contains('Could not add new Guarantor. Total Ownership exceded 100%')) {
                hasMessage = true;
            }
        }
        System.assertEquals(true, hasMessage);
        System.assertEquals(expected.getRedirect(), result.getRedirect());
    }

    @istest
    static void TestSaveAssetDetails() {
        TestSaveApplicant();
         acc.asset.Asset_Price__c= 1000;
         acc.asset.Condition__c= 'USED';
         acc.asset.Make__c= 'BMW';
         acc.asset.Model__c= 'X9';
         acc.asset.Serial__c= 'SEQDEF';
         acc.asset.Year__c= Date.newInstance(2022, 1, 1);
        Pagereference result =  acc.saveAssetDetail();
  
        Pagereference expected = new Pagereference('/apex/ApplicantForm');
        expected.getParameters().put('id', applicantId);
        expected.getParameters().put('tab', 'asset_details');
        expected.setRedirect(true);

        System.assertEquals(expected.getParameters().get('id'), result.getParameters().get('id'));
        System.assertNotEquals(null, result.getParameters().get('assetDetailId'));
        System.assertEquals(expected.getRedirect(), result.getRedirect());
    }

    @istest
    static void TestSubmit() {
        TestSaveApplicant();
        PageReference result = acc.submit();
        Pagereference expected = new Pagereference('/apex/ApplicantForm');
        expected.getParameters().put('id', applicantId);
        expected.getParameters().put('tab', 'submit');
        expected.setRedirect(true);

        System.assertEquals('Submitted', acc.applicant.Status__c);
        System.assertEquals(expected.getParameters().get('id'), result.getParameters().get('id'));
        System.assertEquals(expected.getUrl(), result.getUrl());
        System.assertEquals(expected.getRedirect(), result.getRedirect());
    }

    @istest
    static void TestGetApplicant() {
        TestSaveApplicant();
        Applicant__c result = acc.getApplicant(acc.applicant.id);
        System.assertEquals(result.id, acc.applicant.id);

    }

    @istest
    static void TestGetGuarantors() {
        TestSaveApplicant();
        TestSaveGuaranor();
        List<Guarantor__c> result = acc.getGuarantors(acc.applicant.id);
        System.assertNotEquals(0, result.size());

    }

    @istest
    static void TestGetAssetDetails() {
        TestSaveApplicant();
        TestSaveAssetDetails();
        List<Asset_Detail__c> result = acc.getAssetDetails(acc.applicant.id);
        System.assertNotEquals(0, result.size());

    }
}
