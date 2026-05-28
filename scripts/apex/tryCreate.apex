AccountProfileService.ProfileRequest r = new AccountProfileService.ProfileRequest();
r.contactLastName = 'Doe';
r.opportunityName = 'Any Deal';

System.debug('About to call createProfile');
try {
    AccountProfileService.ProfileResult res = AccountProfileService.createProfile(r);
    System.debug('Result: ' + res);
} catch (Exception e) {
    System.debug('Caught Exception: ' + e);
}
