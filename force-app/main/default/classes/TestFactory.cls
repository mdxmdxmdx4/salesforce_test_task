@isTest
public class TestFactory {
  public static User getSomeUser(Boolean doInsert) {
		Profile p = [SELECT Id, Name FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        User testUser = new User(firstname = 'Not_real', LastName='User', CompanyName = 'ownInc',
        City = 'Paris', Street = 'Croissant', Username = 'hyfweuyhafwe@gmail.gov.de', Email = 'unofficial@gov.de',
        Alias = 'test', TimeZoneSidKey = 'America/Los_Angeles', EmailEncodingKey = 'UTF-8',
        LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ProfileId = p.Id);
        if(doInsert) {
      		insert testUser;
    	}
    	return testUser;
	}
    
    public static Case getSomeCase(Id userId, Boolean doInsert){
        Case testCase = new Case(OwnerId = userId, Status = 'New', Priority = 'High', Origin = 'Web');
         if(doInsert) {
      		insert testCase;
    	}
        return testCase;
    }
    
    public static List<Case> getSomeCasesList(Id userId, Boolean doInsert){
        List<Case> testCases = new List<Case>{
            new Case(OwnerId = userId, Status = 'New', Priority = 'High', Origin = 'Web'),
            new Case(OwnerId = userId, Status = 'Closed', Priority = 'Low', Origin = 'Phone')
        };
            if(doInsert) {
      		insert testCases;
    	}
        return testCases;
    }
}