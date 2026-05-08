public with sharing class ChurnPredictionHandler {
    public static void handleBeforeUpdate(List<Case> newCases, Map<Id, Case> oldCaseMap) {
        if (newCases == null || newCases.isEmpty()) {
            return;
        }

        for (Case caseRecord : newCases) {
            Case oldCase = oldCaseMap == null ? null : oldCaseMap.get(caseRecord.Id);
            Decimal churnScore = readChurnScore(caseRecord);
            Boolean scoreIncreased = oldCase == null || churnScore > readChurnScore(oldCase);

            if (churnScore >= 80 && scoreIncreased) {
                caseRecord.Priority = 'High';
                caseRecord.Status = caseRecord.Status == 'Closed' ? caseRecord.Status : 'Escalated';
                caseRecord.Subject = prefixSubject(caseRecord.Subject, '[Churn Risk]');
            }
        }
    }

    public static void handleAfterUpdate(List<Case> newCases) {
        List<Task> tasks = new List<Task>();
        for (Case caseRecord : newCases) {
            Decimal churnScore = readChurnScore(caseRecord);
            if (churnScore >= 80 && caseRecord.OwnerId != null) {
                tasks.add(new Task(
                    WhatId = caseRecord.Id,
                    OwnerId = caseRecord.OwnerId,
                    Subject = 'Review high churn risk case',
                    Priority = 'High',
                    Status = 'Not Started',
                    ActivityDate = Date.today().addDays(1)
                ));
            }
        }
        if (!tasks.isEmpty()) {
            insert tasks;
        }
    }

    private static Decimal readChurnScore(Case caseRecord) {
        Object scoreValue = caseRecord.get('Churn_Risk_Score__c');
        return scoreValue == null ? 0 : Decimal.valueOf(String.valueOf(scoreValue));
    }

    private static String prefixSubject(String subject, String prefix) {
        String safeSubject = String.isBlank(subject) ? 'Customer case' : subject;
        return safeSubject.startsWith(prefix) ? safeSubject : prefix + ' ' + safeSubject;
    }
}
