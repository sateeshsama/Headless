public with sharing class AccountProfileService {
    public class ProfileRequest {
        @AuraEnabled
        public String accountName;
        @AuraEnabled
        public String accountPhone;
        @AuraEnabled
        public String accountWebsite;
        @AuraEnabled
        public String accountIndustry;
        @AuraEnabled
        public String accountBillingCity;

        @AuraEnabled
        public String contactFirstName;
        @AuraEnabled
        public String contactLastName;
        @AuraEnabled
        public String contactEmail;
        @AuraEnabled
        public String contactPhone;

        @AuraEnabled
        public String opportunityName;
        @AuraEnabled
        public String opportunityStageName;
        @AuraEnabled
        public Date opportunityCloseDate;
        @AuraEnabled
        public Decimal opportunityAmount;
    }

    public class ProfileResult {
        @AuraEnabled
        public Id accountId;
        @AuraEnabled
        public Id contactId;
        @AuraEnabled
        public Id opportunityId;
    }

    public class ProfileView {
        @AuraEnabled
        public Id accountId;
        @AuraEnabled
        public String accountName;
        @AuraEnabled
        public String accountPhone;
        @AuraEnabled
        public String accountWebsite;
        @AuraEnabled
        public String accountIndustry;
        @AuraEnabled
        public String accountBillingCity;

        @AuraEnabled
        public Id contactId;
        @AuraEnabled
        public String contactName;
        @AuraEnabled
        public String contactEmail;
        @AuraEnabled
        public String contactPhone;

        @AuraEnabled
        public Id opportunityId;
        @AuraEnabled
        public String opportunityName;
        @AuraEnabled
        public String opportunityStageName;
        @AuraEnabled
        public Date opportunityCloseDate;
        @AuraEnabled
        public Decimal opportunityAmount;
    }

    @AuraEnabled(cacheable=true)
    public static ProfileView getProfile(Id accountId) {
        if (accountId == null) {
            throw new AuraHandledException('Account Id is required.');
        }

        Account accountRecord = [
            SELECT Id, Name, Phone, Website, Industry, BillingCity
            FROM Account
            WHERE Id = :accountId
            LIMIT 1
        ];

        List<Contact> contactRecords = [
            SELECT Id, Name, Email, Phone
            FROM Contact
            WHERE AccountId = :accountId
            ORDER BY LastModifiedDate DESC
            LIMIT 1
        ];

        List<Opportunity> opportunityRecords = [
            SELECT Id, Name, StageName, CloseDate, Amount
            FROM Opportunity
            WHERE AccountId = :accountId
            ORDER BY CloseDate DESC NULLS LAST
            LIMIT 1
        ];

        ProfileView result = new ProfileView();
        result.accountId = accountRecord.Id;
        result.accountName = accountRecord.Name;
        result.accountPhone = accountRecord.Phone;
        result.accountWebsite = accountRecord.Website;
        result.accountIndustry = accountRecord.Industry;
        result.accountBillingCity = accountRecord.BillingCity;

        if (!contactRecords.isEmpty()) {
            Contact contactRecord = contactRecords[0];
            result.contactId = contactRecord.Id;
            result.contactName = contactRecord.Name;
            result.contactEmail = contactRecord.Email;
            result.contactPhone = contactRecord.Phone;
        }

        if (!opportunityRecords.isEmpty()) {
            Opportunity opportunityRecord = opportunityRecords[0];
            result.opportunityId = opportunityRecord.Id;
            result.opportunityName = opportunityRecord.Name;
            result.opportunityStageName = opportunityRecord.StageName;
            result.opportunityCloseDate = opportunityRecord.CloseDate;
            result.opportunityAmount = opportunityRecord.Amount;
        }

        return result;
    }

    @AuraEnabled
    public static ProfileResult createProfile(ProfileRequest requestData) {
        if (requestData == null || String.isBlank(requestData.accountName)) {
            throw new AuraHandledException('Account Name is required.');
        }
        if (String.isBlank(requestData.contactLastName)) {
            throw new AuraHandledException('Contact Last Name is required.');
        }
        if (String.isBlank(requestData.opportunityName)) {
            throw new AuraHandledException('Opportunity Name is required.');
        }

        Account newAccount = new Account(
            Name = requestData.accountName,
            Phone = requestData.accountPhone,
            Website = requestData.accountWebsite,
            Industry = requestData.accountIndustry,
            BillingCity = requestData.accountBillingCity
        );
        insert newAccount;

        Contact newContact = new Contact(
            AccountId = newAccount.Id,
            FirstName = requestData.contactFirstName,
            LastName = requestData.contactLastName,
            Email = requestData.contactEmail,
            Phone = requestData.contactPhone
        );
        insert newContact;

        String stageName = String.isBlank(requestData.opportunityStageName)
            ? 'Prospecting'
            : requestData.opportunityStageName;
        Date closeDate = requestData.opportunityCloseDate == null
            ? Date.today().addDays(30)
            : requestData.opportunityCloseDate;

        Opportunity newOpportunity = new Opportunity(
            AccountId = newAccount.Id,
            Name = requestData.opportunityName,
            StageName = stageName,
            CloseDate = closeDate,
            Amount = requestData.opportunityAmount
        );
        insert newOpportunity;

        ProfileResult result = new ProfileResult();
        result.accountId = newAccount.Id;
        result.contactId = newContact.Id;
        result.opportunityId = newOpportunity.Id;
        return result;
    }
}