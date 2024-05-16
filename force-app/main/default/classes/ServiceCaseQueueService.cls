public with sharing class ServiceCaseQueueService {
    @AuraEnabled(cacheable=true)
    public static List<Case> getUserCases(Id userId) {
        List<Group> queueList = [SELECT Id FROM Group WHERE Type = 'Queue' AND Id IN (SELECT GroupId FROM GroupMember WHERE UserOrGroupId = :userId)];
        String query = 'SELECT Id, CaseNumber, OwnerId, Status, Priority, Origin, CreatedDate FROM Case WHERE (OwnerId = :userId OR OwnerId IN :queueList) ORDER BY OwnerId ASC, CreatedDate DESC LIMIT 25';
        List<Case> caseList = Database.query(query);
        caseList.sort(new PriorityComparator());
        return caseList;
    }

    public class PriorityComparator implements Comparator<Case> {
        Map<String, Integer> priorityMap = new Map<String, Integer> {
            'High' => 3,
            'Medium' => 2,
            'Low' => 1
        };

        public Integer compare(Case c1, Case c2) {
            return priorityMap.get(c2.Priority) - priorityMap.get(c1.Priority);
        }
    }

    @AuraEnabled
    public static void updateCaseStatus(Id caseId, String status) {
        Case caseRecord = [SELECT Id, Status FROM Case WHERE Id = :caseId];
        caseRecord.Status = status;
        update caseRecord;
    }

}
