public without sharing class AccountCasesPdfCtrl {
    @AuraEnabled
    public static List<Case> getAccountCasesPrevWeek() {
        DateTime today = DateTime.now();
        String dayOfWeek = today.format('u');
        Date lastSunday = today.addDays(-Integer.valueOf(dayOfWeek)).date();
        Date previousMonday = lastSunday.addDays(-6);

        return [
            SELECT Account.Name, Owner.Name, CaseNumber, Status, Priority, Origin
            FROM Case
            WHERE CreatedDate >= :previousMonday AND CreatedDate <= :lastSunday
            ORDER BY Account.Name
        ];
    }
}