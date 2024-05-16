@isTest
public class AccountCasesPdfCtrlTest {
    @testSetup
    static void setup() {
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        List<Case> lastWeekCases = new List<Case>{
            new Case(AccountId = testAccount.Id, Status = 'New', Priority = 'High', Origin = 'Web'),
            new Case(AccountId = testAccount.Id, Status = 'Closed', Priority = 'Low', Origin = 'Phone')
        };
        insert lastWeekCases;

        List<Case> otherCases = new List<Case>{
            new Case(AccountId = testAccount.Id, Status = 'New', Priority = 'High', Origin = 'Web'),
            new Case(AccountId = testAccount.Id, Status = 'Closed', Priority = 'Low', Origin = 'Phone')
        };
        insert otherCases;
    }

    @isTest
    static void testGetAccountCasesPrevWeek() {
        Test.startTest();
        List<Case> cases = AccountCasesPdfCtrl.getAccountCasesPrevWeek();
        Test.stopTest();

        System.assertNotEquals(cases.size(), [SELECT COUNT() FROM Case], 'Invalid number of Case records');
    }
}