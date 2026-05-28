import { LightningElement, track, api } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import createAccount from "@salesforce/apex/AccountFormController.createAccount";

export default class AccountForm extends LightningElement {
  @api title;
  @track accountData = {
    Name: "",
    Phone: "",
    Website: "",
    Industry: ""
  };

  @track isLoading = false;
  @track errors = {};

  industryOptions = [
    { label: "Technology", value: "Technology" },
    { label: "Finance", value: "Finance" },
    { label: "Healthcare", value: "Healthcare" },
    { label: "Retail", value: "Retail" },
    { label: "Manufacturing", value: "Manufacturing" },
    { label: "Other", value: "Other" }
  ];

  handleInputChange(event) {
    const { name, value } = event.target;
    this.accountData[name] = value;
    if (this.errors[name]) {
      delete this.errors[name];
      this.errors = { ...this.errors };
    }
  }

  validateForm() {
    this.errors = {};
    if (!this.accountData.Name) {
      this.errors.Name = "Account Name is required";
    }
    return Object.keys(this.errors).length === 0;
  }

  async handleSubmit() {
    if (!this.validateForm()) {
      this.showToast("Error", "Please fill in all required fields", "error");
      return;
    }

    this.isLoading = true;
    try {
      const result = await createAccount({
        name: this.accountData.Name,
        phone: this.accountData.Phone,
        website: this.accountData.Website,
        industry: this.accountData.Industry
      });

      this.showToast("Success", "Account created: " + result, "success");
      this.resetForm();
    } catch (error) {
      const message =
        error && error.body && error.body.message
          ? error.body.message
          : error.message || "Unknown error";
      this.showToast("Error", message, "error");
    } finally {
      this.isLoading = false;
    }
  }

  handleReset() {
    this.resetForm();
  }

  resetForm() {
    this.accountData = {
      Name: "",
      Phone: "",
      Website: "",
      Industry: ""
    };
    this.errors = {};
    this.isLoading = false;
  }

  showToast(title, message, variant) {
    const event = new ShowToastEvent({
      title,
      message,
      variant
    });
    this.dispatchEvent(event);
  }
}
