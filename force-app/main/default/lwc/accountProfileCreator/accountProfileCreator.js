import { api, LightningElement, wire } from 'lwc';
import getProfile from '@salesforce/apex/AccountProfileService.getProfile';

export default class AccountProfileCreator extends LightningElement {
    @api recordId;
    profile;
    errorMessage;

    @wire(getProfile, { accountId: '$recordId' })
    wiredProfile({ data, error }) {
        if (data) {
            this.profile = data;
            this.errorMessage = null;
        } else if (error) {
            this.profile = null;
            this.errorMessage = error?.body?.message || 'Unable to load account profile.';
        }
    }

    get hasProfile() {
        return !!this.profile;
    }

    get hasContact() {
        return !!this.profile?.contactId;
    }

    get hasOpportunity() {
        return !!this.profile?.opportunityId;
    }
}