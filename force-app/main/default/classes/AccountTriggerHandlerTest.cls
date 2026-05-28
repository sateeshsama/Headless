@IsTest
private class AccountTriggerHandlerTest {
    @IsTest
    static void insertWithPositiveRevenue_succeeds() {
        Account acc = new Account(Name = 'Test Positive', AnnualRevenue = 1000);

        Database.SaveResult result = Database.insert(acc, false);

        System.assert(result.isSuccess(), 'Insert with positive AnnualRevenue should succeed.');
    }

    @IsTest
    static void insertWithNegativeRevenue_fails() {
        Account acc = new Account(Name = 'Test Negative', AnnualRevenue = -1);

        Database.SaveResult result = Database.insert(acc, false);

        System.assert(!result.isSuccess(), 'Insert with negative AnnualRevenue should fail.');
        System.assertEquals(
            'Annual Revenue cannot be negative.',
            result.getErrors()[0].getMessage(),
            'Error message should match.'
        );
    }

    @IsTest
    static void insertWithNullRevenue_succeeds() {
        Account acc = new Account(Name = 'Test Null', AnnualRevenue = null);

        Database.SaveResult result = Database.insert(acc, false);

        System.assert(result.isSuccess(), 'Insert with null AnnualRevenue should succeed.');
    }

    @IsTest
    static void updateWithNegativeRevenue_fails() {
        Account acc = new Account(Name = 'Test Update Negative', AnnualRevenue = 500);
        insert acc;

        acc.AnnualRevenue = -500;
        Database.SaveResult result = Database.update(acc, false);

        System.assert(!result.isSuccess(), 'Update with negative AnnualRevenue should fail.');
        System.assertEquals(
            'Annual Revenue cannot be negative.',
            result.getErrors()[0].getMessage(),
            'Error message should match.'
        );
    }

    @IsTest
    static void updateWithPositiveRevenue_succeeds() {
        Account acc = new Account(Name = 'Test Update Positive', AnnualRevenue = 500);
        insert acc;

        acc.AnnualRevenue = 999;
        Database.SaveResult result = Database.update(acc, false);

        System.assert(result.isSuccess(), 'Update with positive AnnualRevenue should succeed.');
    }

    @IsTest
    static void bulkInsert_onlyNegativeRecordsFail() {
        List<Account> accounts = new List<Account>();
        for (Integer i = 0; i < 100; i++) {
            accounts.add(new Account(Name = 'Valid ' + i, AnnualRevenue = 100));
        }
        for (Integer i = 0; i < 100; i++) {
            accounts.add(new Account(Name = 'Invalid ' + i, AnnualRevenue = -1));
        }

        List<Database.SaveResult> results = Database.insert(accounts, false);

        Integer successCount = 0;
        Integer failureCount = 0;
        for (Database.SaveResult sr : results) {
            if (sr.isSuccess()) {
                successCount++;
            } else {
                failureCount++;
            }
        }

        System.assertEquals(100, successCount, 'Exactly 100 records should succeed.');
        System.assertEquals(100, failureCount, 'Exactly 100 records should fail.');
    }
}