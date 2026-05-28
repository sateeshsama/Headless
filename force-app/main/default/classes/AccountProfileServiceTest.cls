@IsTest
private class AccountProfileServiceTest {
  @IsTest
  static void getProfile_returnsAccountContactOpportunity() {
    Account acc = new Account(
      Name = 'Acme Corp',
      Phone = '415-555-1212',
      Industry = 'Technology'
    );
    insert acc;

    Contact con = new Contact(
      AccountId = acc.Id,
      FirstName = 'Jane',
      LastName = 'Doe',
      Email = 'jane.doe@example.com',
      Phone = '415-555-3434'
    );
    insert con;

    Opportunity opp = new Opportunity(
      AccountId = acc.Id,
      Name = 'Acme New Deal',
      StageName = 'Prospecting',
      CloseDate = Date.today().addDays(30),
      Amount = 100000
    );
    insert opp;

    Test.startTest();
    AccountProfileService.ProfileView result = AccountProfileService.getProfile(
      acc.Id
    );
    Test.stopTest();

    System.assertNotEquals(null, result);
    System.assertEquals(acc.Id, result.accountId);
    System.assertEquals('Acme Corp', result.accountName);
    System.assertEquals(con.Id, result.contactId);
    System.assertEquals('Jane Doe', result.contactName);
    System.assertEquals(opp.Id, result.opportunityId);
    System.assertEquals('Acme New Deal', result.opportunityName);
  }

  @IsTest
  static void getProfile_handlesNoRelatedRecords() {
    Account acc = new Account(Name = 'No Child Records');
    insert acc;

    Test.startTest();
    AccountProfileService.ProfileView result = AccountProfileService.getProfile(
      acc.Id
    );
    Test.stopTest();

    System.assertNotEquals(null, result);
    System.assertEquals(acc.Id, result.accountId);
    System.assertEquals(null, result.contactId);
    System.assertEquals(null, result.opportunityId);
  }

  @IsTest
  static void getProfile_throwsForMissingAccountId() {
    Test.startTest();
    try {
      AccountProfileService.getProfile(null);
      System.assert(false, 'Expected exception for missing Account Id.');
    } catch (Exception ex) {
      System.assert(true);
    }
    Test.stopTest();
  }

  @IsTest
  static void createProfile_createsLinkedRecords() {
    AccountProfileService.ProfileRequest requestData = new AccountProfileService.ProfileRequest();
    requestData.accountName = 'Acme Corp';
    requestData.accountPhone = '415-555-1212';
    requestData.accountWebsite = 'https://acme.example';
    requestData.accountIndustry = 'Technology';
    requestData.accountBillingCity = 'San Francisco';
    requestData.contactFirstName = 'Jane';
    requestData.contactLastName = 'Doe';
    requestData.contactEmail = 'jane.doe@example.com';
    requestData.contactPhone = '415-555-3434';
    requestData.opportunityName = 'Acme New Deal';
    requestData.opportunityStageName = 'Prospecting';
    requestData.opportunityCloseDate = Date.today().addDays(45);
    requestData.opportunityAmount = 100000;

    Test.startTest();
    AccountProfileService.ProfileResult result = AccountProfileService.createProfile(
      requestData
    );
    Test.stopTest();

    System.assertNotEquals(null, result);
    System.assertNotEquals(null, result.accountId);
    System.assertNotEquals(null, result.contactId);
    System.assertNotEquals(null, result.opportunityId);

    Account insertedAccount = [
      SELECT Id, Name
      FROM Account
      WHERE Id = :result.accountId
      LIMIT 1
    ];
    Contact insertedContact = [
      SELECT Id, AccountId, LastName
      FROM Contact
      WHERE Id = :result.contactId
      LIMIT 1
    ];
    Opportunity insertedOpportunity = [
      SELECT Id, AccountId, StageName
      FROM Opportunity
      WHERE Id = :result.opportunityId
      LIMIT 1
    ];

    System.assertEquals('Acme Corp', insertedAccount.Name);
    System.assertEquals(insertedAccount.Id, insertedContact.AccountId);
    System.assertEquals(insertedAccount.Id, insertedOpportunity.AccountId);
    System.assertEquals('Prospecting', insertedOpportunity.StageName);
  }

  @IsTest
  static void createProfile_throwsForMissingAccountName() {
    AccountProfileService.ProfileRequest requestData = new AccountProfileService.ProfileRequest();
    requestData.contactLastName = 'Doe';
    requestData.opportunityName = 'Any Deal';

    Test.startTest();
    try {
      AccountProfileService.createProfile(requestData);
      System.assert(false, 'Expected exception for missing Account Name.');
    } catch (Exception ex) {
      System.assert(true);
    }
    Test.stopTest();
  }
}
