public with sharing class AccountFormController {
  @AuraEnabled
  public static Id createAccount(
    String name,
    String phone,
    String website,
    String industry
  ) {
    if (String.isBlank(name)) {
      throw new AuraHandledException('Account Name is required');
    }

    Account a = new Account(Name = name);
    if (!String.isBlank(phone))
      a.Phone = phone;
    if (!String.isBlank(website))
      a.Website = website;
    if (!String.isBlank(industry))
      a.Industry = industry;

    insert a;
    return a.Id;
  }
}
