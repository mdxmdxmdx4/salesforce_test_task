@isTest
public class ServiceCaseQueueServiceTest {
    @isTest
    static void testGetUserCases() {
        User testUser = TestFactory.getSomeUser(true);
        List<Case> testCases = TestFactory.getSomeCasesList(testUser.id, true);
        
        Test.startTest();
        List<Case> cases = ServiceCaseQueueService.getUserCases(testUser.Id);
        Test.stopTest();
        
        System.assertEquals(testCases.size(), cases.size(), 'Invalid number of cases');
    }

    @isTest
    static void testUpdateCaseStatus() {
        User testUser = TestFactory.getSomeUser(true);
        Case testCase = TestFactory.getSomeCase(testUser.id, true);
        
        Test.startTest();
        ServiceCaseQueueService.updateCaseStatus(testCase.Id, 'Closed');
        Test.stopTest();
        
        Case updatedCase = [SELECT Id, Status FROM Case WHERE Id = :testCase.Id];
        System.assertEquals('Closed', updatedCase.Status, 'Case status is not updated');
    }
}