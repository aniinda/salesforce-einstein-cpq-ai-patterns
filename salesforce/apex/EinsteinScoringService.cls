public with sharing class EinsteinScoringService {
    public class ScoreResult {
        @AuraEnabled public Id opportunityId;
        @AuraEnabled public Decimal score;
        @AuraEnabled public String scoreBand;
        @AuraEnabled public String explanation;
    }

    @AuraEnabled
    public static ScoreResult scoreOpportunity(Id opportunityId) {
        if (opportunityId == null) {
            throw new AuraHandledException('opportunityId is required.');
        }

        Opportunity opportunityRecord = [
            SELECT Id, Amount, StageName, Probability, CloseDate, Type
            FROM Opportunity
            WHERE Id = :opportunityId
            LIMIT 1
        ];

        ScoreResult result = calculateScore(opportunityRecord);
        opportunityRecord.Probability = Integer.valueOf(result.score);
        update opportunityRecord;
        return result;
    }

    // NOTE: This is an illustrative scoring surface using opportunity
    // fields as proxies. In production, replace this logic with an
    // actual Einstein Discovery or Prediction Builder API callout.
    // Field-level prediction outputs should be read from Einstein-managed
    // fields on the Opportunity object, not calculated here.
    private static ScoreResult calculateScore(Opportunity opportunityRecord) {
        Decimal score = opportunityRecord.Probability == null ? 50 : opportunityRecord.Probability;
        if (opportunityRecord.Amount != null && opportunityRecord.Amount >= 250000) {
            score += 8;
        }
        if (opportunityRecord.CloseDate != null && opportunityRecord.CloseDate < Date.today()) {
            score -= 15;
        }
        if (opportunityRecord.StageName == 'Negotiation/Review') {
            score += 10;
        }
        if (opportunityRecord.Type == 'Existing Customer - Upgrade') {
            score += 5;
        }

        score = Math.max(0, Math.min(100, score));

        ScoreResult result = new ScoreResult();
        result.opportunityId = opportunityRecord.Id;
        result.score = score;
        result.scoreBand = score >= 75 ? 'High' : score >= 45 ? 'Medium' : 'Low';
        result.explanation = 'Illustrative Einstein scoring surface based on opportunity value, stage, timing, and type.';
        return result;
    }

    public class BulkOpportunityScoringBatch implements Database.Batchable<SObject>, Database.Stateful {
        public Database.QueryLocator start(Database.BatchableContext context) {
            return Database.getQueryLocator([
                SELECT Id, Amount, StageName, Probability, CloseDate, Type
                FROM Opportunity
                WHERE IsClosed = false
            ]);
        }

        public void execute(Database.BatchableContext context, List<Opportunity> scope) {
            List<Opportunity> updates = new List<Opportunity>();
            for (Opportunity opportunityRecord : scope) {
                ScoreResult result = calculateScore(opportunityRecord);
                opportunityRecord.Probability = Integer.valueOf(result.score);
                updates.add(opportunityRecord);
            }
            if (!updates.isEmpty()) {
                update updates;
            }
        }

        public void finish(Database.BatchableContext context) {
            System.debug(LoggingLevel.INFO, 'Bulk opportunity scoring completed.');
        }
    }
}
