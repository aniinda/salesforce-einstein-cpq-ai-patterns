global with sharing class CPQPricingIntelligence implements SBQQ.PricingPlugin {
    global void onInit(SBQQ.PricingContext context) {
        applyRecommendations(context);
    }

    global void onBeforeCalculate(SBQQ.PricingContext context) {
        applyRecommendations(context);
    }

    global void onAfterCalculate(SBQQ.PricingContext context) {
        enforceApprovalNarrative(context);
    }

    private static void applyRecommendations(SBQQ.PricingContext context) {
        if (context == null || context.quote == null) {
            return;
        }

        Decimal quoteAmount = decimalValue(context.quote.get('SBQQ__NetAmount__c'));
        Decimal confidence = calculateConfidence(quoteAmount);
        Decimal recommendedDiscount = recommendedDiscountFor(quoteAmount, confidence);

        context.quote.put('Recommended_Discount__c', recommendedDiscount);
        context.quote.put('Pricing_Confidence__c', confidence);
        context.quote.put('Approval_Tier__c', approvalTier(recommendedDiscount, confidence));
    }

    private static void enforceApprovalNarrative(SBQQ.PricingContext context) {
        if (context == null || context.quote == null) {
            return;
        }

        Decimal discount = decimalValue(context.quote.get('Recommended_Discount__c'));
        Decimal confidence = decimalValue(context.quote.get('Pricing_Confidence__c'));
        String tier = approvalTier(discount, confidence);
        context.quote.put('Approval_Tier__c', tier);
        context.quote.put('Approval_Narrative__c', 'Einstein recommendation: ' + discount + '% discount with ' + confidence + '% confidence. Approval tier: ' + tier + '.');
    }

    private static Decimal calculateConfidence(Decimal quoteAmount) {
        if (quoteAmount == null) {
            return 55;
        }
        if (quoteAmount >= 500000) {
            return 72;
        }
        if (quoteAmount >= 100000) {
            return 82;
        }
        return 88;
    }

    private static Decimal recommendedDiscountFor(Decimal quoteAmount, Decimal confidence) {
        if (quoteAmount == null) {
            return 5;
        }
        if (quoteAmount >= 500000 && confidence >= 70) {
            return 18;
        }
        if (quoteAmount >= 100000) {
            return 12;
        }
        return 6;
    }

    private static String approvalTier(Decimal discount, Decimal confidence) {
        if (discount >= 20 || confidence < 65) {
            return 'Finance Review';
        }
        if (discount >= 12) {
            return 'Sales Manager';
        }
        return 'Standard';
    }

    private static Decimal decimalValue(Object value) {
        if (value == null) {
            return null;
        }
        return Decimal.valueOf(String.valueOf(value));
    }
}
