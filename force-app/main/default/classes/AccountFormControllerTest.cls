@isTest
private class AccountFormControllerTest {
  @isTest
  static void testCreateAccount() {
    Test.startTest();
    Id accId = AccountFormController.createAccount(
      'Test Account from Apex',
      '1234567890',
      'https://example.com',
      'Technology'
    );
    Test.stopTest();

    Account a = [
      SELECT Id, Name, Phone, Website, Industry
      FROM Account
      WHERE Id = :accId
    ];
    System.assertEquals('Test Account from Apex', a.Name);
    System.assertEquals('1234567890', a.Phone);
    System.assertEquals('https://example.com', a.Website);
    System.assertEquals('Technology', a.Industry);
  }
}
