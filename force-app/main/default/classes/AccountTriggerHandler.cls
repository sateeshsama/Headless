public with sharing class AccountTriggerHandler {
    public void onBeforeInsert(List<Account> newAccounts) {
        validateAnnualRevenue(newAccounts);
    }

    public void onBeforeUpdate(List<Account> newAccounts, Map<Id, Account> oldMap) {
        validateAnnualRevenue(newAccounts);
    }

    private void validateAnnualRevenue(List<Account> accounts) {
        for (Account acc : accounts) {
            if (acc.AnnualRevenue != null && acc.AnnualRevenue < 0) {
                acc.AnnualRevenue.addError('Annual Revenue cannot be negative.');
            }
        }
    }
}